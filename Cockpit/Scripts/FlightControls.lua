-- ****************************************************
-- ****************************************************
-- F-16 SFM LUA scripts for FSTB by Beaker
-- ****************************************************
-- ****************************************************

dofile(LockOn_Options.script_path.."Functions/Filters.lua")

local dev = GetSelf()
dev:listen_command(68)
dev:listen_command(71)
for i=1,4 do					-- flight controls
	dev:listen_command(9000+i)
end
for i=5,9 do					-- flaps
	dev:listen_command(10000+i)
end
for i=10,12 do					-- hook
	dev:listen_command(10000+i)
end
dev:listen_command(10119)
for i=13,15 do					-- speedbrake
	dev:listen_command(10000+i)
end
for i=16,18 do					-- NWS
	dev:listen_command(10000+i)
end

for i=7,8 do					-- Toebrakes
	dev:listen_command(9000+i)
end

dev:listen_command(430)
dev:listen_command(431)
dev:listen_command(147)
dev:listen_command(148)
dev:listen_command(73)

dev:listen_command(3000+85) -- gear handle

local update_rate = 0.0125 -- 0.05
make_default_activity(update_rate)
local sensor_data = get_base_data()

iCommandPlaneLightsOnOff = 175

function initArgs(condition)
	if condition == 0 then -- ground cold
		arg_values[38] = 0.79
		arg_targets[38] = arg_values[38]
		arg_values[0] = 1.0
		arg_values[3] = 1.0
		arg_values[5] = 1.0
		arg_targets[0] = arg_values[0]
		arg_targets[3] = arg_values[3]
		arg_targets[5] = arg_values[5]
		arg_values[9] = flap_max_defl
		arg_values[10] = flap_max_defl
		arg_targets[9] = arg_values[9]
		arg_targets[10] = arg_values[10]
	elseif condition == 1 then -- ground hot
		arg_values[38] = 0.0
		arg_targets[38] = arg_values[38]
		arg_values[0] = 1.0
		arg_values[3] = 1.0
		arg_values[5] = 1.0
		arg_targets[0] = arg_values[0]
		arg_targets[3] = arg_values[3]
		arg_targets[5] = arg_values[5]
		arg_values[9] = 1.0
		arg_values[10] = 1.0
		arg_targets[9] = arg_values[9]
		arg_targets[10] = arg_values[10]
	elseif condition == 2 then -- air hot
		arg_values[38] = 0.0
		arg_targets[38] = arg_values[38]
		arg_values[0] = 0.0
		arg_values[3] = 0.0
		arg_values[5] = 0.0
		arg_targets[0] = arg_values[0]
		arg_targets[3] = arg_values[3]
		arg_targets[5] = arg_values[5]
		arg_values[9] = 0.0
		arg_values[10] = 0.0
		arg_targets[9] = arg_values[9]
		arg_targets[10] = arg_values[10]
	end
end


function post_initialize()
	arg_targets = {}
	arg_values = {}
	BossJet = false
	gear_pos_param = get_param_handle("GEAR_POS")
	flcs_gains = get_param_handle("FLCS_GAINS") -- 0 - UA, 1 = LDG
	speedbrake = 0
	WOW = 1
	NWS_toggle = 1
	rudpos = 0
	rollpos = 0
	nwstarget = 0
	rudset = 0
	rudauthority = 0.21
	k = 0.042254
	-- 0.082724 for 0.025
	vaporflag = 0
	flap_max_defl = 1.0

	local birth = LockOn_Options.init_conditions.birth_place
		initArgs(0)
		gearhandle = 1
		
	if birth == "AIR_HOT" then
		initArgs(2)
		downlockflag = 0
		gearhandle = 1
		
	elseif birth == "GROUND_HOT" then
		initArgs(1)
		downlockflag = 2
		gearhandle = 1

	end
	gear_pos_param:set(gearhandle)
	
	
	spdbrkannun	= get_param_handle("SPDBRKANNUN")
end







function setArgTarget(arg,value)
	arg_targets[arg] = value
end
function filter_first_order_lag_arg(current,target,kval)
	return target + (1 - kval) * current
end
function filter_linear_rate_arg(value,target,rate)
	if value > target then
		value = value - rate
		if value < target then value = target end
	elseif value < target then
		value = value + rate
		if value > target then value = target end
	end
	return value
end

function updateArgValues()
	current_arg = 38 -- canopy
	arg_values[current_arg] = filter_linear_rate_arg(arg_values[current_arg],arg_targets[current_arg],1/(5/update_rate)) -- rate = 1/(sec/update_rate)
	set_aircraft_draw_argument_value(current_arg,arg_values[current_arg])
	
	current_arg = 0 -- nose gear
	arg_values[current_arg] = filter_linear_rate_arg(arg_values[current_arg],arg_targets[current_arg],1/(4.0/update_rate))
	set_aircraft_draw_argument_value(current_arg,arg_values[current_arg])
	current_arg = 3 -- right main gear
	arg_values[current_arg] = filter_linear_rate_arg(arg_values[current_arg],arg_targets[current_arg],1/(5.8/update_rate))
	set_aircraft_draw_argument_value(current_arg,arg_values[current_arg])
	current_arg = 5 -- left main gear
	arg_values[current_arg] = filter_linear_rate_arg(arg_values[current_arg],arg_targets[current_arg],1/(5.6/update_rate))
	set_aircraft_draw_argument_value(current_arg,arg_values[current_arg])
	
	current_arg = 9 -- flap right
	arg_values[current_arg] = filter_linear_rate_arg(arg_values[current_arg],arg_targets[current_arg],1/(2/update_rate)) -- 10deg/s?
	set_aircraft_draw_argument_value(current_arg,arg_values[current_arg])
	current_arg = 10 -- flap left
	arg_values[current_arg] = filter_linear_rate_arg(arg_values[current_arg],arg_targets[current_arg],1/(2/update_rate))
	set_aircraft_draw_argument_value(current_arg,arg_values[current_arg])
	
	--current_arg = 99
	--arg_values[current_arg] = filter_first_order_lag_arg(arg_values[current_arg], arg_targets[current_arg], 0.5)
	--set_aircraft_draw_argument_value(current_arg,arg_values[current_arg])
end






function gearextend()						-- set gear targets and return animation progress
	setArgTarget(0,1)
	setArgTarget(3,1)
	setArgTarget(5,1)
	
	setArgTarget(9,flap_max_defl) -- set flaps with gear
	setArgTarget(10,flap_max_defl)
	
	if arg_values[0] + arg_values[3] + arg_values[5] == 3 then
		gearhandle = 1 -- transit done, stops gearextend() from being called
		return 2 -- gear animation is complete, set downlock flag
	else
		return 1 -- gear in transit
	end
end

function gearretract()						-- set gear targets and return animation progress
	setArgTarget(0,0)
	setArgTarget(3,0)
	setArgTarget(5,0)
	
	setArgTarget(9,0) -- set flaps with gear
	setArgTarget(10,0)
	
	
	if arg_values[0] + arg_values[3] + arg_values[5] == 0 then
		gearhandle = 1 -- transit done, stops gearretract() from being called
		return 0 -- gear animation is complete, unset downlock flag 
	else
		return 1 -- gear in transit
	end
end

function update()
	local alpha = sensor_data.getAngleOfAttack()*57.2957795
	local IAS = sensor_data.getIndicatedAirSpeed()*1.94384449
	local pitchrate = sensor_data.getRateOfPitch()
	local phi = sensor_data.getRoll()
	local g_load = sensor_data.getVerticalAcceleration()
	local fuelweight = sensor_data.getTotalFuelWeight()*2.20462
	local flapset =  get_aircraft_draw_argument_value(10)
	WOW = sensor_data.getWOW_NoseLandingGear()
	
	
-- NWS/rudder
	if WOW == 0 then  -- nosewheel airborne/gear up
		rudauthority = ramp(IAS,	250,0.5, 	450,0.9)
		if not track_is_reading() then 
			dispatch_action(nil,2003,rudpos*rudauthority) 
			set_aircraft_draw_argument_value(17,-rudpos*rudauthority)
		end
	elseif WOW == 1 then  -- on nosewheel
		if NWS_toggle == 1 then
			rudauthority = 1 -- NWS = jesus christ almighty
			nwstarget = rudpos*0.8
		else
			rudauthority = ramp(IAS,	250,0.5, 	450,0.9)
			nwstarget = 0
		end
		rudset = nwstarget + (1 - k) * rudset
		
		if not track_is_reading() then 
			dispatch_action(nil,2003,rudset*0.042)
			set_aircraft_draw_argument_value(2,-rudset*0.042)
			set_aircraft_draw_argument_value(17,-rudpos*rudauthority) -- rudpos because nwstarget is zeroed
		end
	end
	
	
	
-- example for vapor animation
	--if g_load > 1 then
	--	set_aircraft_draw_argument_value(280,0.22222222*g_load-0.22222222)--0.0156023*g_load^2.32192809
	--end

	
	
-- gear handle
	if gearhandle == 2 then
		--dev:performClickableAction(3085, 0)
		if downlockflag ~= 2 then
			--set_aircraft_draw_argument_value(208,1)
			downlockflag = gearextend()
		end
	elseif gearhandle == 0 then
		--dev:performClickableAction(3085, 1)
		if downlockflag ~= 0 then
			--set_aircraft_draw_argument_value(208,0)
			set_aircraft_draw_argument_value(2,0)
			downlockflag = gearretract()
		end
	end

	
-- speedbrake toggle
	local speedbrake_rate = 1/(2/update_rate) -- 2 second extend
	if speedbrake == 1 then
		spdbrkannun:set(1)
		local arg =  get_aircraft_draw_argument_value(182)
		if arg < 1 then
			
			arg = arg + speedbrake_rate
			set_aircraft_draw_argument_value(182,arg)
		end
	end
	
	if speedbrake == -1 then
		local arg =  get_aircraft_draw_argument_value(182)
		if arg > 0 then
			arg = arg - speedbrake_rate
			set_aircraft_draw_argument_value(182,arg)
		end
		if arg <= 0 then

			spdbrkannun:set(0)
		end
	end
-- speedbrake hold
	if speedbrake == 2 then
		spdbrkannun:set(1)
		local arg =  get_aircraft_draw_argument_value(182)
		if arg < 1 then
			arg = arg + speedbrake_rate
			set_aircraft_draw_argument_value(182,arg)
		else
			set_aircraft_draw_argument_value(182,1)
			speedbrake = 0
		end
	end
	
	if speedbrake == -2 then
		local arg =  get_aircraft_draw_argument_value(182)
		if arg > 0 then
			arg = arg - speedbrake_rate
			set_aircraft_draw_argument_value(182,arg)
		end
		if arg <= 0 then
			speedbrake = 0
			spdbrkannun:set(0)
		end
	end

	set_aircraft_draw_argument_value(21,get_aircraft_draw_argument_value(182))
	
	
-- DO NOT ADD ADDITIONAL CODE AFTER THIS LINE. -------------------------------------------------------------------------------------------
	if math.abs(speedbrake) < 2 then speedbrake = 0 end
	updateArgValues()
end

function SetCommand(command,value)
		
		if command == 71 then -- canopy open/close
			if arg_targets[38] == 0.79 then
				setArgTarget(38,0.0)
			else
				setArgTarget(38,0.79)
			end
		end
	
		
		if command == 73 then		----Speedbrake toggle
			local arg =  get_aircraft_draw_argument_value(182)
			if arg <= 0 then
				speedbrake = 2
			elseif arg > 0 then
				speedbrake = -2
			end	
		end
		
		if command == 148 then		--Speedbrake Retract
			speedbrake = -1
				if not track_is_reading() then 

				end
		end
			
		if command == 147 then		--Speedbrake Extend
			speedbrake = 1
				if not track_is_reading() then
		
				end
		end
		
		
		if command == 10016 then		--NWS toggle
			if NWS_toggle < 1 then
				NWS_toggle = NWS_toggle + 1
			elseif NWS_toggle > 0 then
				NWS_toggle = NWS_toggle - 1
				set_aircraft_draw_argument_value(2,0)
			end
		end
		
	--Roll
		if command == 2002 then
			rollpos = value
		end	
	
	--Rudder
		if command == 9003 then
			rudpos = value
		end	

		
		if command == 3085 then		--Gear Lever (clickable)
				if value == 0 then gearhandle = 2 end -- gear down
				if value == 1 then gearhandle = 0 end

		end
			
		
		if command == 430 and WOW == 0 then --gear up
			gearhandle = 0
			gear_pos_param:set(gearhandle)
			flcs_gains:set(0)
		end
		
		if command == 431 and WOW == 0 then -- gear down
			gearhandle = 2
			gear_pos_param:set(gearhandle)
			flcs_gains:set(1)
		end
		
		if command == 68 and WOW == 0 then  -- gear toggle
			if downlockflag == 2 then
				gearhandle = 0 -- gear up
				gear_pos_param:set(gearhandle)
				flcs_gains:set(0)
			end
			if downlockflag == 0 then
				gearhandle = 2 -- gear down
				gear_pos_param:set(gearhandle)
				flcs_gains:set(1)
			end
			gear_pos_param:set(gearhandle)
		end
		
end

need_to_be_closed = false -- close lua state after initialization