dofile(LockOn_Options.script_path.."devices.lua")
dofile(LockOn_Options.script_path.."command_defs.lua")
dofile(LockOn_Options.script_path.."ElectricSystem.lua")
dofile(LockOn_Options.script_path.."ElectricSystem_API.lua")

local dev = GetSelf()
local sensor_data = get_base_data()

local update_time_step = 0.02
make_default_activity(update_time_step)

local math =
            {
                ias_conversion_to_knots = 1.9504132,
                ias_conversion_to_kmh = 3.6,
                DEGREE_TO_RAD = 0.0174532925199433,
                RADIANS_TO_DEGREES = 57.29577951308233,
                METERS_TO_INCHES = 3.2808,
}

local ccParameters =
            {
                RALT = get_param_handle("RALT"),
                ALT = get_param_handle("ALT"),
                PITCH = get_param_handle("PITCH"),
                ROLL = get_param_handle("ROLL"),
            }

local HUDparams =
            {
                BRIGHTNESS = get_param_handle("HUD_BRT"),
                BALANCE = get_param_handle("HUD_BAL"),
                POWER = get_param_handle("HUD_PWR"),
                HUD_X = get_param_handle("HUD_X"),
                HUD_Y = get_param_handle("HUD_Y"),
                WL = get_param_handle("WL"),
                WL_NORM = get_param_handle("WL_NORM"),
                WL_GEAR = get_param_handle("WL_GEAR"),
                WL_BRAKE = get_param_handle("WL_BRAKE"),
                WL_GEAR_BRAKE = get_param_handle("WL_GEAR_BRAKE"),
                HDG_MOV = get_param_handle("HDG_MOV"),
                HDG_STR = get_param_handle("HDG_STR"),
                GEAR_L = get_param_handle("GEAR_L"),
                GEAR_R = get_param_handle("GEAR_R"),
                GEAR_F = get_param_handle("GEAR_F"),
                BANK = get_param_handle("BANK"),
                BANK_SCALE = get_param_handle("BANK_SCALE"),
            }

local HUDWarnings =
            {
                PULL_UP = get_param_handle("PULL_UP"),
            }

dev:listen_command(HUD.Brightness)
dev:listen_command(HUD.Balance)
dev:listen_command(HUD.Contrast)
dev:listen_command(HUD.Depth)

function post_initialize()
    HUDparams.HUD_X:set(0)
    HUDparams.HUD_Y:set(0)
    local birth = LockOn_Options.init_conditions.birth_place
    if birth == "GROUND_HOT" or birth == "AIR_HOT" then
        HUDparams.BRIGHTNESS:set(1)
        --HUDparams.POWER:set(1)
    elseif birth == "GROUND_COLD" then
        HUDparams.BRIGHTNESS:set(0)
        --HUDparams.POWER:set(0)
    end
    print_message_to_user("HUD INIT")
end

function SetCommand(command,value)
    if command == HUD.Brightness then
        if HUDparams.POWER:get() == 1 then
            if HUDparams.BRIGHTNESS:get() == 0 then
                dev:performClickableAction(HUD.Brightness,1,true)
                HUDparams.BRIGHTNESS:set(1)
            elseif HUDparams.BRIGHTNESS:get() == 1 then
                dev:performClickableAction(HUD.Brightness,0,true)
                HUDparams.BRIGHTNESS:set(0)
            end
        elseif HUDparams.POWER:get() == 0 then
            dev:performClickableAction(HUD.Brightness,0,true)
            HUDparams.BRIGHTNESS:set(0)
        end
    end
end

function update_warnings()
    if HUDparams.POWER:get() == 1 then
        if get_aircraft_draw_argument_value(0) == 0 then
            if ccParameters.ALT:get() < 2000 then
                if ccParameters.PITCH:get() > -0.4 then
                    HUDWarnings.PULL_UP:set(1)
                elseif ccParameters.PITCH:get() < -0.4 then
                    HUDWarnings.PULL_UP:set(0)
                end
            elseif ccParameters.ALT:get() < 2500 then
                if ccParameters.PITCH:get() > -0.6 then
                    HUDWarnings.PULL_UP:set(1)
                elseif ccParameters.PITCH:get() < -0.6 then
                    HUDWarnings.PULL_UP:set(0)
                end
            end
        elseif get_aircraft_draw_argument_value(0) > 0 then
            HUDWarnings.PULL_UP:set(0)
        end
    end
end

function update_bank()
    HUDparams.BANK:set(sensor_data.getRoll())
    if HUDparams.BANK:get() > 1 then
        HUDparams.BANK:set(1)
    elseif HUDparams.BANK:get() < -1 then
        HUDparams.BANK:set(-1)
    end

    if HUDparams.POWER:get() == 1 then
        if HUDparams.BANK:get() > 0.5 or HUDparams.BANK:get() < -0.5 then
            HUDparams.BANK_SCALE:set(1)
        elseif HUDparams.BANK:get() < 0.5 or HUDparams.BANK:get() > -0.5 then
            HUDparams.BANK_SCALE:set(0)
        end
    end
end

function update_waterline()
    speedbrakes = get_aircraft_draw_argument_value(21)
    gear = get_aircraft_draw_argument_value(0)

    if HUDparams.POWER:get() == 1 then
        HUDparams.WL:set(1)
    elseif HUDparams.POWER:get() == 0 then
        HUDparams.WL:set(0)
    end

    if HUDparams.WL:get() == 1 then
        HUDparams.WL_NORM:set(1)
    elseif HUDparams.WL:get() == 0 then
        HUDparams.WL_NORM:set(0)
        HUDparams.WL_BRAKE:set(0)
        HUDparams.WL_GEAR:set(0)
        HUDparams.WL_GEAR_BRAKE:set(0)
    end

    if HUDparams.WL_NORM:get() == 1 then
        if speedbrakes > 0.1 and gear < 0.1 then
            HUDparams.WL_NORM:set(0)
            HUDparams.WL_BRAKE:set(1)
            HUDparams.WL_GEAR:set(0)
            HUDparams.WL_GEAR_BRAKE:set(0)
        elseif gear > 0.1 and speedbrakes < 0.1 then
            HUDparams.WL_NORM:set(0)
            HUDparams.WL_BRAKE:set(0)
            HUDparams.WL_GEAR:set(1)
            HUDparams.WL_GEAR_BRAKE:set(0)
        elseif gear > 0.1 and speedbrakes > 0.1 then
            HUDparams.WL_NORM:set(0)
            HUDparams.WL_BRAKE:set(0)
            HUDparams.WL_GEAR:set(0)
            HUDparams.WL_GEAR_BRAKE:set(1)
        elseif gear < 0.1 and speedbrakes < 0.1 then
            HUDparams.WL_NORM:set(1)
            HUDparams.WL_BRAKE:set(0)
            HUDparams.WL_GEAR:set(0)
            HUDparams.WL_GEAR_BRAKE:set(0)
        end
    end
end

function update_hdg()
    local temp_hdg = sensor_data.getHeading() * math.RADIANS_TO_DEGREES / 10
    if temp_hdg > 18 then
        temp_hdg = 36 - temp_hdg
        HUDparams.HDG_MOV:set(temp_hdg)
    elseif temp_hdg <= 18 then
        HUDparams.HDG_MOV:set(-temp_hdg)
    end
    HUDparams.HDG_STR:set(sensor_data.getHeading() * math.RADIANS_TO_DEGREES)
end

function update_gear()
    if get_aircraft_draw_argument_value(0) > 0.9 then
        HUDparams.GEAR_F:set("D")
    elseif get_aircraft_draw_argument_value(0) < 0.1 then
        HUDparams.GEAR_F:set("UP")
    elseif get_aircraft_draw_argument_value(0) > 0.1 and get_aircraft_draw_argument_value(0) < 0.9 then
        HUDparams.GEAR_F:set("X")
    end

    if get_aircraft_draw_argument_value(3) > 0.9 then
        HUDparams.GEAR_R:set("D")
    elseif get_aircraft_draw_argument_value(3) < 0.1 then
        HUDparams.GEAR_R:set("UP")
    elseif get_aircraft_draw_argument_value(3) > 0.1 and get_aircraft_draw_argument_value(0) < 0.9 then
        HUDparams.GEAR_R:set("X")
    end

    if get_aircraft_draw_argument_value(5) > 0.9 then
        HUDparams.GEAR_L:set("D")
    elseif get_aircraft_draw_argument_value(5) < 0.1 then
        HUDparams.GEAR_L:set("UP")
    elseif get_aircraft_draw_argument_value(5) > 0.1 and get_aircraft_draw_argument_value(0) < 0.9 then
        HUDparams.GEAR_L:set("X")
    end
end

function update()
    update_warnings()
    update_bank()
    update_waterline()
    update_hdg()
    update_gear()
    HUDparams.HUD_X:set(sensor_data.getAngleOfSlide())
    HUDparams.HUD_Y:set(sensor_data.getAngleOfAttack())
end