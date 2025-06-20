dofile(LockOn_Options.script_path.."devices.lua")
dofile(LockOn_Options.script_path.."command_defs.lua")
dofile(LockOn_Options.script_path.."ElectricSystem.lua")
dofile(LockOn_Options.script_path.."ElectricSystem_API.lua")

local dev = GetSelf()
local sensor_data = get_base_data()

local update_time_step = 0.02
make_default_activity(update_time_step)

local ccElectricSystem =
                    {
                        BATT = get_param_handle("BATT"),
                    }

local ccLights =
                    {
                        NAV = get_param_handle("NAV_LT"),
    
                        TAXI = get_param_handle("TAXI_LT"),
                        ACOL = get_param_handle("ACOL_LT"),
                    }

dev:listen_command(LIGHTS.Nav)
dev:listen_command(LIGHTS.AntiCol)
dev:listen_command(LIGHTS.LandTaxi)


function post_initialize()
    local birth = LockOn_Options.init_conditions.birth_place
    if birth == "GROUND_HOT" or birth == "AIR_HOT" then
        dev:performClickableAction(LIGHTS.Nav,1,true)
        ccLights.NAV:set(0)
        dev:performClickableAction(LIGHTS.AntiCol,1,true)
        dispatch_action(nil,175,1)
        dev:performClickableAction(LIGHTS.LandTaxi,0,true)

    elseif birth == "GROUND_COLD" then
        dev:performClickableAction(LIGHTS.Nav,0,true)
        ccLights.NAV:set(0)
        dev:performClickableAction(LIGHTS.AntiCol,0,true)
        dispatch_action(nil,175,0)
        dev:performClickableAction(LIGHTS.LandTaxi,0,true)
 
    end
    print_message_to_user("LIGHTS INIT")
end

function SetCommand(command,value)
    battSw = get_cockpit_draw_argument_value(21)

    if command == LIGHTS.Nav then
        if battSw == 1 then
            if get_cockpit_draw_argument_value(16) == 0 then
                dev:performClickableAction(LIGHTS.Nav,1,true)
                ccLights.NAV:set(1)
            elseif get_cockpit_draw_argument_value(16) > 0 then
                dev:performClickableAction(LIGHTS.Nav,0,true)
                ccLights.NAV:set(0)
            end
        elseif battSw < 1 then
            dev:performClickableAction(LIGHTS.Nav,0,true)
            ccLights.NAV:set(0)
        end
    end

    if command == LIGHTS.AntiCol then
        if battSw == 1 then
            if get_cockpit_draw_argument_value(17) == 0 then
                dev:performClickableAction(LIGHTS.AntiCol,1,true)
                dispatch_action(nil,175,1)
            elseif get_cockpit_draw_argument_value(17) > 0 then
                dev:performClickableAction(LIGHTS.AntiCol,0,true)
                dispatch_action(nil,175,0)
            end
        elseif battSw < 1 then
            dev:performClickableAction(LIGHTS.AntiCol,0,true)
            dispatch_action(nil,175,0)
        end
    end
end

function update()
    set_aircraft_draw_argument_value(190,ccLights.NAV:get())
    set_aircraft_draw_argument_value(191,ccLights.NAV:get())
    set_aircraft_draw_argument_value(192,ccLights.NAV:get())
end