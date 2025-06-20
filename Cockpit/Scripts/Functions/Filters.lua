-- ****************************************************
-- ****************************************************
-- F-16 SFM LUA scripts for FSTB by Beaker
-- Filters.lua created with help of SilentEagle
-- ****************************************************
-- ****************************************************

-- FILTER TYPES

-- lag_filter
-- lead_lag_filter
-- second_order_filter
-- washout_filter
-- integrator
-- oscillator

-- CONTROLLER TYPES

-- rate_limiter (controls accel/decel)
-- pid_control (ideal or standard, 4 integrator types + wind-up integrator prevention)


function lag_filter(Input,previn1,prevout1,dt,c1) --From the form: C1/(s+C1)

	local den = 2.00 + dt*c1
	local ca = dt*c1/den
	local cb = (2.00 - dt*c1)/den
	local Output = Input*ca + previn1*ca + prevout1*cb

	previn1 = Input
	prevout1 = Output
	
	return Output,previn1,prevout1
end

function lead_lag_filter(Input,previn1,prevout1,dt,c1,c2,c3,c4) --From the form: (C1*s+C2)/(C3*s+C4)

	local den = 2.00*c3 + dt*c4
	local ca = (2.00*c1 + dt*c2)/den
	local cb = (dt*c2 - 2.00*c1)/den
	local cc = (2.00*c3 - dt*c4)/den
	local Output = Input*ca + previn1*cb + prevout1*cc

	previn1 = Input
	prevout1 = Output
	
	return Output,previn1,prevout1
end

function second_order_filter(Input,previn1,prevout1,previn2,prevout2,dt,c1,c2,c3,c4,c5,c6) --From the form: (C1*s^2+C2*s+C3)/(C4*s^2+C5*s+C6)

	local den = 4.0*c4 + 2.0*c5*dt + c6*dt*dt
	local ca = (4.0*c1 + 2.0*c2*dt + c3*dt*dt)/den
	local cb = (2.0*c3*dt*dt - 8.0*c1)/den
	local cc = (4.0*c1 - 2.0*c2*dt + c3*dt*dt)/den
	local cd = (2.0*c6*dt*dt - 8.0*c4)/den
	local ce = (4.0*c4 - 2.0*c5*dt + c6*dt*dt)/den	
	local Output = Input*ca + previn1*cb + previn2*cc - prevout1*cd - prevout2*ce
	
	previn2 = previn1
	prevout2 = prevout1
	previn1 = Input
	prevout1 = Output
	
	return Output,previn1,prevout1,previn2,prevout2
end

function washout_filter(Input,previn1,prevout1,dt,c1) --From the form: s/(s+C1)

	local den = 2.00 + dt*c1
	local ca = 2.00/den
	local cb = (2.00 - dt*c1)/den
	local Output = Input*ca - previn1*ca + prevout1*cb

	previn1 = Input
	prevout1 = Output
	
	return Output,previn1,prevout1
end

function integrator(Input,previn1,prevout1,dt,c1) --From the form: C1/s

	local ca = dt*c1/2.00
	local Output = Input*ca + previn1*ca + prevout1

	previn1 = Input
	prevout1 = Output
	
	return Output,previn1,prevout1
end

function oscillator(amplitude,frequency,phase_shift,sim_time) --Returns oscillation value.  Must be added to initial value in system code to see desired oscillation.

	local ps = phase_shift	-- phase shift = -c/k 
	local f = frequency --(1/s)
	
	local A = amplitude	  --Max oscillation value
	local k = f*(2*math.pi) --Converting to angular frequency
	local c = -ps*k  --Not sure if this is correct.
	local t = sim_time

	local Output = A*math.sin(k*t + c)
	
	return Output
end

--rate = rate_limiter(Input,target,rate,accel,decel,maxrate,minrate,maxdelta)
function rate_limiter(Input,target,rate,accel,decel,maxrate,minrate,maxdelta)
	local value = Input
	local delta = math.abs(target - Input)
	
	if delta>maxdelta then delta = maxdelta end
	
	if value > target then
		rate = rate + decel
		if rate < minrate then rate = minrate end
	elseif value < target then
		rate = rate + accel
		if rate > maxrate then rate = maxrate end
	end
	
	rate = rate*(delta/maxdelta)
	
	local Output = rate
	
	return Output
end

--rate = rate_limiter_simple(Input,target,rate,accel,maxrate,maxdelta)
function rate_limiter_simple(Input,target,rate,accel,maxrate,maxdelta)
	local value = Input
	local delta = math.abs(target - Input)
	
	if delta>maxdelta then delta = maxdelta end
	
	if value > target then
		rate = rate - accel
		if rate < -maxrate then rate = -maxrate end
	elseif value < target then
		rate = rate + accel
		if rate > maxrate then rate = maxrate end
	end
	
	rate = rate*(delta/maxdelta)
	
	local Output = rate
	
	return Output
end

function linear_rate(value,target,posrate,negrate)

	if value > target then
		value = value - negrate
		if value < target then value = target end
	elseif value < target then
		value = value + posrate
		if value > target then value = target end
	end
	
	local Output = value
	
	return Output
end

function linear_rate_simple(value,target,rate)

	if value > target then
		value = value - rate
		if value < target then value = target end
	elseif value < target then
		value = value + rate
		if value > target then value = target end
	end
	
	local Output = value
	
	return Output
end

--Output,Error_prev,I_out_total,(Error_prev2 - optional) = pid(Kp,Ki,Kd,Error,Error_prev,I_out_total,dt,Trigger,pid_type,integ_type,Error_prev2)
function pid(Kp,Ki,Kd,Error,Error_prev,I_out_total,dt,Trigger,pid_type,integ_type,Error_prev2)

  local I_out_delta = 0
  local Dval = 0
  local Output

  if dt == nil then dt = 0.05 end
  
  --pid_type = 0 (ideal) or 1 (standard)
  if pid_type ~= nil then 
	  if pid_type ~= 0 or pid_type ~= 1 then--anything other than 0 or 1
		pid_type = 0
	  end
  else
	pid_type = 0
  end

  
  -- if ProcessVariableDot then
    -- Dval = ProcessVariableDot
  -- else
    Dval = (Error - Error_prev)/dt
  -- end

  -- Do not continue to integrate the Error to the integrator if a wind-up
  -- condition is sensed - that is, if the property pointed to by the trigger
  -- element is non-zero. Reset the integrator to 0.0 if the Trigger value
  -- is negative.

  local test = 0.0
  if Trigger ~= nil then
	if Trigger ~= 0 then test = Trigger end
  end
  
  if math.abs(test) < 0.000001 and integ_type ~= nil then
	if integ_type == 0 then            			-- Use normal rectangular integration (0)
	  I_out_delta = Ki * dt * Error
	elseif integ_type == 1 then   					-- Use trapezoidal integration (1)
	  I_out_delta = (Ki/2.0) * dt * (Error + Error_prev)
	elseif integ_type == 2 then   					-- Use Adams Bashforth 2nd order integration (2)
	  I_out_delta = Ki * dt * (1.5*Error - 0.5*Error_prev)
	elseif integ_type == 3 and Error_prev2 ~= nil then    					-- Use Adams Bashforth 3rd order integration (3)
	  I_out_delta = (Ki/12.0) * dt * (23.0*Error - 16.0*Error_prev + 5.0*Error_prev2)
	else
	  integ_type = 2
	  I_out_delta = Ki * dt * (1.5*Error - 0.5*Error_prev) -- Use default Adams Bashforth 2nd order integration (02)
	end
  end
  
  if integ_type == nil then
    integ_type = 2
	I_out_delta = Ki * dt * (1.5*Error - 0.5*Error_prev) -- Use default Adams Bashforth 2nd order integration
  end

  if test < 0.0 then I_out_total = 0.0 end -- Reset integrator to 0.0
  
  if I_out_total ~= nil then
	I_out_total = I_out_total + I_out_delta
  else
	I_out_total = 0
  end
	
  if pid_type == 0  then
	Output = Kp*Error + I_out_total + Kd*Dval
  elseif pid_type == 1 then
    Output = Kp*(Error + I_out_total + Kd*Dval)
  end

  Error_prev = Error
  Error_prev2 = Error_prev

  if integ_type == 3 then
	return Output,Error_prev,I_out_total,Error_prev2
  else
	return Output,Error_prev,I_out_total
  end
end


function firstorderlag(input,target,k,magnet) -- smaller k values = faster response
	
	input = target + (1 - k) * input
	-- if magnet ~= nil and magnet > 0 then
		-- if math.abs(target - input) < magnet then
			-- input = target
		-- end
	-- end
	return input
	
end

function setk(response,sample,frac)
	local frac = frac or 0.999
	return 1 - math.log(1 - frac) * sample / response
end

function limit(input, lower_limit, upper_limit)
	if(input > upper_limit) then
		return upper_limit;
	elseif(input < lower_limit) then
		return lower_limit;
	else
		return input;
	end
end

function ramp_with_limits(input,x1,y1,x2,y2,lower_limit,upper_limit)
	local output = 0;
	output = (y2-y1)/(x2-x1)*input - (y2-y1)/(x2-x1)*x1 + y1;  --equation of the line described by (x1,y1) and (x2,y2)
	output = limit(output,lower_limit,upper_limit);
	return output;
end

function ramp(input,x1,y1,x2,y2,lower_limit,upper_limit)
	local output = 0;
	output = (y2-y1)/(x2-x1)*input - (y2-y1)/(x2-x1)*x1 + y1;  --equation of the line described by (x1,y1) and (x2,y2)
	return output;
end

function rate_limiter_simple_nodecel(Input,target,rate,accel,maxrate)
	value = Input;
	delta = math.abs(target - Input);
	
	if (value > target)
	then
		if (rate > 0) then rate = 0 end
		rate = rate - accel;
		if (rate < -maxrate) then rate = -maxrate end
		if (Input + rate < target) then Input = target else Input = Input + rate end
	elseif (value < target) then
		if (rate < 0) then rate = 0 end
		rate = rate + accel;
		if (rate > maxrate) then rate = maxrate end
		if (Input + rate > target) then Input = target else Input = Input + rate end
	end
	
	return Input, rate
end