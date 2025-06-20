dofile(LockOn_Options.script_path.."devices.lua")
dofile(LockOn_Options.script_path.."command_defs.lua")
dofile(LockOn_Options.script_path.."ElectricSystem_API.lua")
dofile(LockOn_Options.script_path.."utils.lua")

startup_print("electric_system: load")

local electric_system = GetSelf()
local sensor_data = get_base_data()

local update_time_step = 0.02
make_default_activity(update_time_step)

local ccElectricSystem =
                        {
                            BATT = get_param_handle("BATT"),
                            GENL = get_param_handle("GENL"),
                            GENR = get_param_handle("GENR"),
                            APU = get_param_handle("APU"),
                        }

local HUD =
            {
                POWER = get_param_handle("HUD_PWR"),
            }

electric_system:listen_command(ELECTRICAL.Batt)
electric_system:listen_command(ELECTRICAL.GenL)
electric_system:listen_command(ELECTRICAL.GenR)
electric_system:listen_command(ELECTRICAL.APU)

function update_elec_state()
    if (electric_system:get_AC_Bus_1_voltage() > 0 or electric_system:get_AC_Bus_2_voltage() > 0) then
        elec_primary_ac_ok:set(1)
    else
        elec_primary_ac_ok:set(0)
    end

    if electric_system:get_DC_Bus_1_voltage() > 0 and ccElectricSystem.BATT:get() == 1 then
        elec_primary_dc_ok:set(1)
    else
        elec_primary_dc_ok:set(0)
    end
end

function post_initialize()
    startup_print("electric_system: postinit start")
    local birth = LockOn_Options.init_conditions.birth_place
    if birth == "GROUND_HOT" or birth == "AIR_HOT" then
        electric_system:performClickableAction(ELECTRICAL.Batt,1,true)
        electric_system:performClickableAction(ELECTRICAL.GenL,1,true)
        electric_system:performClickableAction(ELECTRICAL.GenR,1,true)
        electric_system:performClickableAction(ELECTRICAL.APU,0,true)
        HUD.POWER:set(1)
    elseif birth == "GROUND_COLD" then
        electric_system:performClickableAction(ELECTRICAL.Batt,0,true)
        electric_system:performClickableAction(ELECTRICAL.GenL,0,true)
        electric_system:performClickableAction(ELECTRICAL.GenR,0,true)
        electric_system:performClickableAction(ELECTRICAL.APU,0,true)
        HUD.POWER:set(0)
    end
    audioHost = create_sound_host("audioHost","3D",-3,0,0)
    sndBattery = audioHost:create_sound("Aircrafts/Typhoon FGR4/Cockpit/battery")
    sndAPUStart = audioHost:create_sound("Aircrafts/Typhoon FGR4/Cockpit/APU_Start")
    sndAPURun = audioHost:create_sound("Aircrafts/Typhoon FGR4/Cockpit/APU_Run")
    sndAPUStop = audioHost:create_sound("Aircrafts/Typhoon FGR4/Cockpit/APU_Stop")

    update_elec_state()
    startup_print("electric_system: postinit end")
end

function SetCommand(command,value)
    battSw = get_cockpit_draw_argument_value(21)
    APUSw = get_cockpit_draw_argument_value(25)
    genLSw = get_cockpit_draw_argument_value(26)
    genRSw = get_cockpit_draw_argument_value(27)
    Covers = set_aircraft_draw_argument_value(23)
    Ladder = set_aircraft_draw_argument_value(91)

    if command == ELECTRICAL.Batt then
        if battSw == 1 then
            electric_system:performClickableAction(ELECTRICAL.Batt,0,true)
            electric_system:DC_Battery_on(false)
            dispatch_action(nil,315,0)
            ccElectricSystem.BATT:set(0)
            HUD.POWER:set(0)
            Covers = 0
            Ladder = 0
        elseif battSw < 1 then
            electric_system:performClickableAction(ELECTRICAL.Batt,1,true)
            electric_system:DC_Battery_on(true)
            dispatch_action(nil,315,1)
            ccElectricSystem.BATT:set(1)
            HUD.POWER:set(1)
            Covers = 1
            Ladder = 1
        end
    end

    if command == ELECTRICAL.GenL then
        if genLSw == 1 then
            electric_system:performClickableAction(ELECTRICAL.GenL,0,true)
            electric_system:AC_Generator_1_on(false)
            ccElectricSystem.GENL:set(0)
        elseif genLSw < 1 then
            electric_system:performClickableAction(ELECTRICAL.GenL,1,true)
            electric_system:AC_Generator_1_on(true)
            ccElectricSystem.GENL:set(1)
        end
    end

    if command == ELECTRICAL.GenR then
        if genRSw == 1 then
            electric_system:performClickableAction(ELECTRICAL.GenR,0,true)
            electric_system:AC_Generator_2_on(false)
            ccElectricSystem.GENR:set(0)
        elseif genRSw < 1 then
            electric_system:performClickableAction(ELECTRICAL.GenR,1,true)
            electric_system:AC_Generator_2_on(true)
            ccElectricSystem.GENR:set(1)
        end
    end

    if command == ELECTRICAL.APU then
        if APUSw == 1 then
            electric_system:performClickableAction(ELECTRICAL.APU,0,true)
            --dispatch_action(nil,1071,0)
            ccElectricSystem.APU:set(0)
        elseif APUSw < 1 then
            electric_system:performClickableAction(ELECTRICAL.APU,1,true)
            --dispatch_action(nil,1071,1)
            ccElectricSystem.APU:set(1)
        end
    end
end

function update()
    update_elec_state()
end


startup_print("electric_system: load end")
need_to_be_closed = false