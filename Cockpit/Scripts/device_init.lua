dofile(LockOn_Options.script_path.."devices.lua")
dofile(LockOn_Options.common_script_path.."tools.lua")
dofile(LockOn_Options.script_path.."materials.lua")

MainPanel = {"ccMainPanel",LockOn_Options.script_path.."mainpanel_init.lua"}

creators  = {}
creators[devices.COCKPIT]           = {"avLuaDevice"            ,LockOn_Options.script_path.."ccCockpit.lua"}
creators[devices.ELECTRICAL]        = {"avSimpleElectricSystem" ,LockOn_Options.script_path.."ElectricSystem.lua"}
--------------------
--- ccIndicators ---
--------------------
creators[devices.MFD]               = {"avLuaDevice"            ,LockOn_Options.script_path.."Displays/MFD/Device/device.lua"}
creators[devices.HUD]               = {"avLuaDevice"            ,LockOn_Options.script_path.."Displays/HUD/Device/device.lua"}
--creators[devices.ADI]               = {"avLuaDevice"            ,LockOn_Options.script_path.."Displays/ADI/Device/device.lua"}
--------------------
------ Engine ------
--------------------
--creators[devices.EJ200]             = {"avLuaDevice"            ,LockOn_Options.script_path.."Eurojet EJ200/Engine.lua"}
--creators[devices.FUEL]              = {"avLuaDevice"            ,LockOn_Options.script_path.."Eurojet EJ200/Fuel.lua"}
--creators[devices.APU]               = {"avLuaDevice"            ,LockOn_Options.script_path.."Eurojet EJ200/APU.lua"}
---------------------
-- Flight Controls --
---------------------
creators[devices.FLCS]              = {"avLuaDevice"            ,LockOn_Options.script_path.."FLCS.lua"}
creators[devices.FLTCTRLS]          = {"avLuaDevice"            ,LockOn_Options.script_path.."FlightControls.lua"}
---------------------
------ Systems ------
---------------------
creators[devices.LIGHTS]            = {"avLuaDevice"            ,LockOn_Options.script_path.."Lights.lua"}
creators[devices.INTERCOM]          = {"avIntercom"}
creators[devices.RADIO]             = {"avUHK_ARC_164", {devices.INTERCOM}, {devices.ELECTRICAL}}
creators[devices.NVG]               = {"avNightVisionGoggles"}

-- New stuff

-- Indicators
indicators = {}
indicators[#indicators + 1] = {"ccIndicator",LockOn_Options.script_path.."Displays/MFD/LEFT/init.lua",nil,{{"PNT_LMFD_CENTER"},{"PNT_LMFD_RIGHT"},{"PNT_LMFD_DOWN"}}}
indicators[#indicators + 1] = {"ccIndicator",LockOn_Options.script_path.."Displays/MFD/CENTER/init.lua",nil,{{"PNT_CMFD_CENTER"},{"PNT_CMFD_RIGHT"},{"PNT_CMFD_DOWN"}}}
indicators[#indicators + 1] = {"ccIndicator",LockOn_Options.script_path.."Displays/MFD/RIGHT/init.lua",nil,{{"PNT_RMFD_CENTER"},{"PNT_RMFD_RIGHT"},{"PNT_RMFD_DOWN"}}}

indicators[#indicators + 1] = {"ccIndicator",LockOn_Options.script_path.."Displays/HUD/Indicator/init.lua",nil,{{"PNT_HUD_CENTER"},{"PNT_HUD_RIGHT"},{"PNT_HUD_DOWN"}}}

--indicators[#indicators + 1] = {"ccIndicator",LockOn_Options.script_path.."Displays/ADI/Indicator/init.lua",nil,{{"PNT_ADI_CENTER"},{"PNT_ADI_RIGHT"},{"PNT_ADI_DOWN"}}}