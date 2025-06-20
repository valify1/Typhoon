-- ****************************************************
-- ****************************************************
-- F-16 SFM LUA scripts for FSTB by Beaker
-- ****************************************************
-- ****************************************************

dofile(LockOn_Options.script_path.."Functions/Filters.lua")
local FLCS_device 	    = GetSelf()
FLCS_device:listen_command(9000)
FLCS_device:listen_command(9002)
FLCS_device:listen_command(8999)
FLCS_device:listen_command(8998)
FLCS_device:listen_command(8997)
FLCS_device:listen_command(215)
FLCS_device:listen_command(97)
FLCS_device:listen_command(68) --gear
FLCS_device:listen_command(430)
FLCS_device:listen_command(431)
--local FLCS_debug = io.open("./Temp/Export.log", "w")
--FLCS_debug:write("FLCS Debug Log \r")
local sensor_data = get_base_data()

local update_time_step = 0.0125
make_default_activity(update_time_step)
--update will be called 10 times per second



function post_initialize()
	stick_pitch = 0
	--trim_bias_ua = 0.0 -- not used anymore... having separate biases resulted in trim hand-off hitching.
	--trim_bias_ldg = 0.0 -- not used anymore... having separate biases resulted in trim hand-off hitching.
	trim_bias_default = 0.3 -- for some reason, 0.0 results in approx 0.8-0.9G hands-off.
	trim_bias = trim_bias_default
	trim_bias_change = 0.0 -- set when trim button is depressed, added to trim bias during update()
	Error_prev = 0
	Error = 0
	iouttotalerror = 0
	Output = 0
	Trigger = 0
	gz_filtered = 1.0
	alpha_filtered = 0.0
	psidot_filtered = 0.0 -- pitch rate deg/s
	pitch_prev = 0.0 -- for calculating psidot
	alpha_prev = 0.0
	alphadot_filtered = 0.0
	stick_pitch_filtered = 0
	stick_pitch_lag = 0
	stabs_filtered = 0
	stick_pitch_rate = 0
	testthing		= get_param_handle("TESTTHING")
	testthing:set(1)
	maxgthing		= get_param_handle("MAX_G")
	gear_pos_param = get_param_handle("GEAR_POS") -- 2 down, 0 up
	flcs_gains = get_param_handle("FLCS_GAINS") -- 0 - UA, 1 = LDG
	flcs_gains_actual = 1 -- Update the parameter, not this. This will be the actual gain, run through a stepwise lag filter for smooth transition.
	stick_y = get_param_handle("STICK_Y") -- debug display purposes
	psidot_test = get_param_handle("PSI_DOT") -- debug display purposes
	stick_roll = 0.0 -- roll command
	dstab = 0.0 -- calculated differential stab (visual only)
	dstabtarget = 0.0 -- dstab is rate limited (linear_rate_simple())
	dtef = 0.0 -- calculated differential TEF (visual only)
	dteftarget = 0.0
	roll_limiter = 1.0 -- roll performance pct
	roll_command = 0 -- N/I now. 324 deg/sec max IRL. SFM currently produces ~237
	WOW = 1
	print_message_to_user("FLCS INIT")
	
	local birth = LockOn_Options.init_conditions.birth_place
		flcs_gains:set(1) -- ground cold
		flcs_gains_actual = 1
	if birth == "AIR_HOT" then
		flcs_gains:set(0)
		flcs_gains_actual = 0
	elseif birth == "GROUND_HOT" then
		flcs_gains:set(1)
		flcs_gains_actual = 1
	end

end

--Aerodynamic authority limit
--320	1
--400	0.6
--460	0.4
--500	0.3

function cruisegains(_stick_pitch_lag, _trim_bias)
	local pos_cmd_available = ramp_with_limits(ias,200,6,330,10, 4.0,17, 500, 20)
	local neg_cmd_available = ramp_with_limits(ias, 200, 4, 300, 5, 4, 8)
	local alpha_feedback = ramp_with_limits(alpha, 20, 0, 25, 7, 0, 8) -- shouldnt be based on pos_cmd_available... just combine weighted feedbacks and setpoints and integrate to 0!
	local process_feedback = gz_filtered
	
	local setpoint = 9 
	if _stick_pitch_lag >= 0 then
		setpoint = (1.05 + _trim_bias) + (_stick_pitch_lag * pos_cmd_available) - alpha_feedback -- (1g trim, adjusted for trim bias) + (% of commanded available G) - (aoa feedback to keep aoa < 25)
	else
		setpoint = (1.05 + _trim_bias) + (_stick_pitch_lag * neg_cmd_available) - alpha_feedback
	end
	
	local roll_limiter = 1.0 * ramp_with_limits(ias,160,0.5,250,1.0,0.6,1.0)
	return process_feedback, setpoint, roll_limiter
end
	
function landinggains(_stick_pitch_lag, _trim_bias)
	local pos_cmd_available = 	ramp_with_limits(ias,	160,1,	250,1,	0.5,1) -- deg/s available
	local neg_cmd_available = 	ramp_with_limits(ias,	160,0.5,	250,1.2,	0.5,1.2) -- deg/s available
	local alpha_feedback = 		ramp_with_limits(alpha,	10,0.0, 	14,5.0, 	0.0,5.0) -- begins at 10 aoa, max attainable approx 18 aoa (needs testing!)
	local process_feedback = psidot_filtered
	
	local setpoint = 0
	if _stick_pitch_lag >= 0 then
		setpoint = (0 + (_trim_bias*0.2)-(trim_bias_default*0.2)) + (_stick_pitch_lag * pos_cmd_available) - alpha_feedback -- (0 dps rate + trim) + (% of commanded available pitch rate) - (aoa feedback)
	else
		setpoint = (0 + (_trim_bias*0.2)-(trim_bias_default*0.2)) + (_stick_pitch_lag * neg_cmd_available) - alpha_feedback
	end
	
	local roll_limiter = 0.5
	return process_feedback, setpoint, roll_limiter
end

function LEFTarget()
	
	if WOW == 1 then
		return 0
	else
		return ramp_with_limits(alpha_filtered,0,0,25,1,0,1) * ramp_with_limits(ias,450,1,550,0,0,1)
	end
	
end

		
function update()
	alpha = sensor_data.getAngleOfAttack()*(180/math.pi)
	alphadot = alpha - alpha_prev
	alphadot_filtered = firstorderlag(alphadot_filtered,alphadot,0.4)
	alpha_filtered = firstorderlag(alpha_filtered,alpha,0.4)
	ias = sensor_data.getIndicatedAirSpeed()*1.94384449244
	
	psidot = ((sensor_data.getPitch() - pitch_prev)/update_time_step)*(180/math.pi) -- pitch rate deg/s
	psidot_filtered = linear_rate_simple(psidot_filtered,psidot,0.001) --firstorderlag(psidot_filtered,psidot,0.1)
	pitch_prev = sensor_data.getPitch()
	
	phi = sensor_data.getRoll()
	gz = sensor_data.getVerticalAcceleration()
	gz_filtered = firstorderlag(gz_filtered,gz,0.8)
	WOW = sensor_data.getWOW_NoseLandingGear()
	--maxgthing:set(alpha)
	psidot_test:set(psidot_filtered)

--&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
-- Lag the gains, breh
--&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
	flcs_gains_actual = linear_rate_simple(flcs_gains_actual,flcs_gains:get(),1/(2.0/update_time_step)) -- 2 seconds transition from landing to cruise gains
	
	
--&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
-- To lag or not to lag?
--&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
	--stick_pitch_lag = firstorderlag(stick_pitch_lag,stick_pitch,0.4 - (flcs_gains_actual * 0.3)) -- increase delay/decrease k by 0.15 with landing gains.
	stick_pitch_lag = stick_pitch

	
--&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
-- Determine setpoint and feedback
--&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
		local process_feedback = 0.0
		local setpoint = 0.0
		local roll_limiter = 1.0 -- FLCS off will get 1.0 via flow
		
		if flcs_gains_actual == 0 then
			process_feedback, setpoint, roll_limiter = cruisegains(stick_pitch_lag, trim_bias)
		
		elseif flcs_gains_actual == 1 then
			process_feedback, setpoint, roll_limiter = landinggains(stick_pitch_lag, trim_bias)
		
		else -- transition
			--Set up two variables for LERP
			local process_feedbackA = 0.0
			local setpointA = 0.0
			local roll_limiterA = 1.0
			local process_feedbackB = 0.0
			local setpointB = 0.0
			local roll_limiterB = 1.0
			--Get interpolated values
			process_feedbackA, setpointA, roll_limiterA = cruisegains(stick_pitch_lag, trim_bias)
			process_feedbackB, setpointB, roll_limiterB = landinggains(stick_pitch_lag, trim_bias)
			--LERP
			process_feedback 	= ramp(flcs_gains_actual,	0,process_feedbackA, 	1,process_feedbackB)
			setpoint 			= ramp(flcs_gains_actual,	0,setpointA, 			1,setpointB)
			roll_limiter 		= ramp(flcs_gains_actual,	0,roll_limiterA, 		1,roll_limiterB)
		end

		
--&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
-- Integrate
--&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
	local Error = process_feedback - setpoint
	--local proportional = ramp_with_limits(ias,200,1.0,500,0.8,0.5,1)
	Output,Error_prev,iouttotalerror = pid(0.45,0.05,0.05,Error,Error_prev,iouttotalerror,update_time_step,Trigger,1,2,0) --0.5,0.08,0.1
	if math.abs(Output) > 1 then Trigger = -1 else Trigger = 0 end -- if the PID is attempting to use more than availble stab deflection, disconnect integrator to avoid wind-up
	stick_pitch_filtered =  limit(Output,-1,1)
	stick_pitch_filtered = stick_pitch_filtered * limit((4980730.52 * ias ^-2.668),0.3,1.0)
	
	if flcs_gains_actual == 3 then -- FLCS off, no lag
		stick_pitch_filtered = -stick_pitch
		--stick_y:set(-stick_pitch_lag)
	end
	
	
--&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
-- Assign result
--&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
	dispatch_action(nil,2001,-stick_pitch_filtered)
	--FLCS_debug:write(ias..",".. -stick_pitch_filtered .. "\n")
	
	
--&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
-- Set stabs and roll surfaces
--&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
	--stick_pitch_filtered, stick_pitch_rate = rate_limiter_simple_nodecel(stick_pitch_filtered, Output, stick_pitch_rate, (0.69813*update_time_step)/15, 0.69813*update_time_step); 
	--stabs_filtered = firstorderlag(stabs_filtered,-stick_pitch_filtered,0.08,1)
	stabs_filtered,stick_pitch_rate = rate_limiter_simple_nodecel(stabs_filtered, -stick_pitch_filtered, stick_pitch_rate, (0.69813*update_time_step)/10, 0.69813*update_time_step);
	
	dstabtarget = stick_roll * ramp_with_limits(ias,	160,0.5,	400,0.25,	0.1,1.0)
	dstab = linear_rate_simple(dstab, dstabtarget, 1/(0.9/update_time_step))
	
	dteftarget = stick_roll * ramp_with_limits(ias,	250,1.0,	400,0.2,	0.0,1.0)
	dtef = linear_rate_simple(dtef, dteftarget, 1/(0.9/update_time_step))
	
--&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
-- Set arguments
--&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
	set_aircraft_draw_argument_value(19, stabs_filtered / 5)--R flaperon roll
	set_aircraft_draw_argument_value(20, stabs_filtered / 5)--L flaperon roll
	set_aircraft_draw_argument_value(15, stabs_filtered + dstab)--R stab
	set_aircraft_draw_argument_value(16, stabs_filtered - dstab)--L stab
	set_aircraft_draw_argument_value(13, linear_rate_simple(get_aircraft_draw_argument_value(13), LEFTarget(), 0.314159 * update_time_step)) -- R LEF
	set_aircraft_draw_argument_value(14, linear_rate_simple(get_aircraft_draw_argument_value(14), LEFTarget(), 0.314159 * update_time_step)) -- L LEF

	
--&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
-- Trim (if depressed)
--&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
	if trim_bias_change ~= 0.0 then
		trim_bias = trim_bias + trim_bias_change
	end
	
	
end

function SetCommand(command,value)
	
	
-- *************************************
-- *********** PITCH/GAINS *************
-- *************************************
	
	
	if command == 9000 then
			
		--stick_pitch = value

		if value > 0 then
			stick_pitch = limit((8.98773764 * value^1.58032647) / 8.9877, 0, 1) -- / 8.9877 because I'm dumb?
		elseif value < 0 then
			stick_pitch = limit((-12.98773764 * (-value)^1.58032647) / 12.9877, -1, 0)
		else
			stick_pitch = 0 -- cannot raise 0 to 0th
		end
		
		
	end
	if command == 8999 then
		--if flcs_gains:get() == 0 then
		--	flcs_gains:set(1)
		--	--trim_bias = 0.0
		--else
		--	flcs_gains:set(0)
		--end
		if flcs_gains:get() ~= 3 then
			flcs_gains:set(3)
		else
			flcs_gains:set(0)
		end
	end
	
-- *************************************
-- *************** GEAR ****************
-- *************************************
	
	--if command == 68 then
	--	if gear_pos_param:get() == 0 then -- gear retract command? (must be from up position. simplest way, not the best way.)
	--		flcs_gains:set(0)
	--	else
	--		flcs_gains:set(1)
	--	end
	--end
	--if command == 430 then --gear up
	--	flcs_gains:set(0)
	--end
	--
	--if command == 431 then -- gear down
	--	flcs_gains:set(1)
	--end
	
-- *************************************
-- *************** TRIM ****************
-- *************************************
	
	if command == 8997 then		-- trim down
		trim_bias_change = -0.005
	end
	if command == 8998 then		-- trim up
		trim_bias_change = 0.005
	end
	if command == 215 then -- iCommandPlaneTrimStop
		trim_bias_change = 0.0
	end
	if command == 97 then --iCommandPlaneTrimCancel
		trim_bias = trim_bias_default --- (0.3 * flcs_gains_actual)
	end
	
-- *************************************
-- *************** OTHER ***************
-- *************************************	
	
	if command == 9002 then
		stick_roll = value * roll_limiter
		dispatch_action(nil,2002,stick_roll)
	end

end

need_to_be_closed = false -- close lua state after initialization


