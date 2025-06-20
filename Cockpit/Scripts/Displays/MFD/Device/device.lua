dofile(LockOn_Options.script_path.."devices.lua")
dofile(LockOn_Options.script_path.."command_defs.lua")
dofile(LockOn_Options.script_path.."ElectricSystem.lua")
dofile(LockOn_Options.script_path.."ElectricSystem_API.lua")

local dev = GetSelf()
local sensor_data = get_base_data()

local update_time_step = 0.02
make_default_activity(update_time_step)

local ELECTRICAL =
                {
                    BATT = get_param_handle("BATT"),
                }

local LEFT_MFD =
                {
                    LMFD_PWR = get_param_handle("LMFD_PWR"),
                    LMFD_BRT = get_param_handle("LMFD_BRT"),
                    LMFD_BAL = get_param_handle("LMFD_BAL"),
                }

local CENTER_MFD =
                {
                    CMFD_PWR = get_param_handle("CMFD_PWR"),
                    CMFD_BRT = get_param_handle("CMFD_BRT"),
                    CMFD_BAL = get_param_handle("CMFD_BAL"),
                }

local RIGHT_MFD =
                {
                    RMFD_PWR = get_param_handle("RMFD_PWR"),
                    RMFD_BRT = get_param_handle("RMFD_BRT"),
                    RMFD_BAL = get_param_handle("RMFD_BAL"),
                }


local FUEL_PAGE = 
                {
                    FUEL_PAGE = get_param_handle("FUEL_PAGE"),
                    FUEL_TOTAL = get_param_handle("FUEL_TOTAL"),
                }

dev:listen_command(LMFD.Power)
dev:listen_command(LMFD.Brightness)
dev:listen_command(LMFD.Balance)

dev:listen_command(CMFD.Power)
dev:listen_command(CMFD.Brightness)
dev:listen_command(CMFD.Balance)

dev:listen_command(RMFD.Power)
dev:listen_command(RMFD.Brightness)
dev:listen_command(RMFD.Balance)

function post_initialize()
    --[[ LEFT_MFD.LMFD_BRT:set(1)
    CENTER_MFD.LMFD_BRT:set(1)
    RIGHT_MFD.RMFD_BRT:set(1) ]]
    local birth = LockOn_Options.init_conditions.birth_place
    if birth == "GROUND_HOT" or birth == "AIR_HOT" then
        LEFT_MFD.LMFD_PWR:set(1)
        CENTER_MFD.CMFD_PWR:set(1)
        RIGHT_MFD.RMFD_PWR:set(1)
    elseif birth == "GROUND_COLD" then
        LEFT_MFD.LMFD_PWR:set(0)
        CENTER_MFD.CMFD_PWR:set(0)
        RIGHT_MFD.RMFD_PWR:set(0)
    end
    print_message_to_user("MFD INIT")
end

function SetCommand(command,value)
    battSw = get_cockpit_draw_argument_value(21)

    if command == LMFD.Power then
        if battSw == 1 then
            if LEFT_MFD.LMFD_PWR:get() == 0 then
                LEFT_MFD.LMFD_PWR:set(1)
                dev:performClickableAction(LMFD.Power,1,true)
            elseif LEFT_MFD.LMFD_PWR:get() == 1 then
                LEFT_MFD.LMFD_PWR:set(0)
                dev:performClickableAction(LMFD.Power,1,true)
            end
        end
    end

    if command == RMFD.Power then
        if battSw == 1 then
            if RIGHT_MFD.RMFD_PWR:get() == 0 then
                RIGHT_MFD.RMFD_PWR:set(1)
                dev:performClickableAction(RMFD.Power,1,true)
            elseif RIGHT_MFD.RMFD_PWR:get() == 1 then
                RIGHT_MFD.RMFD_PWR:set(0)
                dev:performClickableAction(RMFD.Power,1,true)
            end
        end
    end

    if command == CMFD.Power then
        if battSw == 1 then
            if CENTER_MFD.CMFD_PWR:get() == 0 then
                CENTER_MFD.CMFD_PWR:set(1)
                dev:performClickableAction(CMFD.Power,1,true)
            elseif CENTER_MFD.CMFD_PWR:get() == 1 then
                CENTER_MFD.CMFD_PWR:set(0)
                dev:performClickableAction(CMFD.Power,1,true)
            end
        end
    end
end

function update_pwr_logic()
    if battSw == 0 then
        if CENTER_MFD.CMFD_PWR:get() == 1 then
            CENTER_MFD.CMFD_PWR:set(0)
        elseif RIGHT_MFD.RMFD_PWR:get() == 1 then
            RIGHT_MFD.RMFD_PWR:set(0)
        elseif LEFT_MFD.LMFD_PWR:get() == 1 then
            LEFT_MFD.LMFD_PWR:set(0)
        end
    end
end

function update()
    update_pwr_logic()
    FUEL_PAGE.FUEL_TOTAL:set(sensor_data.getTotalFuelWeight())
end