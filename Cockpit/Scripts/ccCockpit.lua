dofile(LockOn_Options.script_path.."devices.lua")
dofile(LockOn_Options.script_path.."command_defs.lua")
--dofile(LockOn_Options.script_path.."Systems/ElectricSystem.lua")

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
                        ccInit = get_param_handle("ccInit"),
                        ALT = get_param_handle("ALT"),
                        RALT = get_param_handle("RALT"),
                        LRPM = get_param_handle("LRPM"),
                        LFF = get_param_handle("LFF"),
                        RFF = get_param_handle("RFF"),
                        LEGT = get_param_handle("LEGT"),
                        REGT = get_param_handle("REGT"),
                        ROLL = get_param_handle("ROLL"),
                        PITCH = get_param_handle("PITCH"),
                        AOA = get_param_handle("AOA"),
                        MACH = get_param_handle("MACH"),
                        HDG = get_param_handle("HDG"),
                        SPEED = get_param_handle("SPEED"),
                        GS = get_param_handle("GS"),
                        ACCEL = get_param_handle("ACCEL"),
                        PILOT = get_param_handle("PILOT"),
                    }

local ccElectricSystem =
                    {
                        BATT = get_param_handle("BATT"),
                    }

local ccWarnings =
                    {
                        ALTITUDE = get_param_handle("ALTITUDE"),
                        STALL = get_param_handle("STALL"),
                        FUEL = get_param_handle("FUEL"),
                        OVERG = get_param_handle("OVERG"),
                    }

dev:listen_command(device_commands.pilotDraw)

function post_initialize()
    ccParameters.ccInit:set(1)
    ccWarnings.ALTITUDE:set(0)
    ccWarnings.STALL:set(0)
    ccWarnings.FUEL:set(0)
    ccWarnings.OVERG:set(0)
    audioHost = create_sound_host("audioHost","2D",0,0,0)
end

function SetCommand(command,value)
    if command == device_commands.pilotDraw then
        if get_cockpit_draw_argument_value(500) == 1 then
            ccParameters.PILOT:set(0)
        elseif get_cockpit_draw_argument_value(500) < 1 then
            ccParameters.PILOT:set(1)
        end
    end
end

function update_gauges()
    ccParameters.ALT:set(sensor_data.getBarometricAltitude() * math.METERS_TO_INCHES)
    ccParameters.RALT:set(sensor_data.getRadarAltitude())
    ccParameters.ACCEL:set(sensor_data.getVerticalAcceleration())
    ccParameters.SPEED:set(sensor_data.getIndicatedAirSpeed() * math.ias_conversion_to_knots)

    ccParameters.HDG:set(sensor_data.getHeading() * math.RADIANS_TO_DEGREES)
    if ccParameters.HDG:get() < 10 then
        ccParameters.HDG:set(0 + sensor_data.getHeading() * math.RADIANS_TO_DEGREES)
    elseif ccParameters.HDG:get() > 10 then
        ccParameters.HDG:set(sensor_data.getHeading() * math.RADIANS_TO_DEGREES)
    end

    ccParameters.MACH:set(sensor_data.getMachNumber())
    ccParameters.PITCH:set(-sensor_data.getPitch())
    ccParameters.ROLL:set(sensor_data.getRoll())
end
function update()
    if ccElectricSystem.MACH:get() == 1 then
        Covers = 1
    else
        Covers = 1
    end

    Covers = set_aircraft_draw_argument_value(23)
end

function update_clickables()
    local BATT_CLICK_REF = get_clickable_element_reference("PNT_BATTERY")
    local APU_CLICK_REF = get_clickable_element_reference("PNT_APU")
    local GEN_L_CLICK_REF = get_clickable_element_reference("PNT_GEN_L")
    local GEN_R_CLICK_REF = get_clickable_element_reference("PNT_GEN_R")

    BATT_CLICK_REF:update()
    APU_CLICK_REF:update()
    GEN_L_CLICK_REF:update()
    GEN_R_CLICK_REF:update()
end

function update()
    update_gauges()
    update_clickables()
end