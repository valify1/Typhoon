mount_vfs_model_path	(current_mod_path.."/Shapes")
mount_vfs_texture_path	(current_mod_path.."/Textures/TyphoonFGR4.zip")
mount_vfs_liveries_path	(current_mod_path.."/Liveries")



local tips = {
	{ CLSID = "{A4BCC903-06C8-47bb-9937-A30FEDB4E741}"},
	{ CLSID = "{A4BCC903-06C8-47bb-9937-A30FEDB4E742}"},
	{ CLSID = "{A4BCC903-06C8-47bb-9937-A30FEDB4E743}"},
	{ CLSID = "{A4BCC903-06C8-47bb-9937-A30FEDB4E744}"},
	{ CLSID = "{A4BCC903-06C8-47bb-9937-A30FEDB4E745}"},
	{ CLSID = "{A4BCC903-06C8-47bb-9937-A30FEDB4E746}"},
}

local centerline = {
	{ CLSID = "{FUEL_1KL_FGR4}"},
}

local FGR4 =  {
	Name 				=   'Typhoon FGR4',

	shape_table_data 	= 
	{
		{
			file  		= "Typhoon_FGR4";
			username	= "Typhoon FGR4";
			index		= WSTYPE_PLACEHOLDER;
			life		= 20; -- прочность объекта (методом lifebar*) -- The strength of the object (ie. lifebar *)
			vis			= 3; -- множитель видимости (для маленьких объектов лучше ставить поменьше). Visibility factor (For a small objects is better to put lower nr).
			desrt		= "FGR4_destr"; --Name of destroyed object file name
			fire		= { 300, 2}; -- Fire on the ground after destoyed: 300sec 4m
			classname	= "lLandPlane";
			positioning	= "BYNORMAL";
		},
		{
			name  = "FGR4_destr";
			file  = "fgr4-oblomok";
			fire  = { 0, 1};
		}
	},

	Picture				= "FGR4.png",
	DisplayName			=	_("Typhoon FGR4"),
	mapclasskey			=	"P0091000024",
	WorldID				=   WSTYPE_PLACEHOLDER,
	attribute 			= 	{wsType_Air, wsType_Airplane, wsType_Fighter, WSTYPE_PLACEHOLDER, "Multirole fighters", "Refuelable", "Datalink", "Link16"},
	Categories			=	{"{78EFB7A2-FD52-4b57-A6A6-3BF0E1D6555F}", "Interceptor",},
	CanopyGeometry		=	makeAirplaneCanopyGeometry(LOOK_AVERAGE, LOOK_AVERAGE, LOOK_GOOD),
	Rate				=	50,	

	country_of_origin = "UK",

	-- Countermeasures, 
	passivCounterm = {
		CMDS_Edit = true,
		SingleChargeTotal = 120,
		chaff = {default = 60, increment = 10, chargeSz = 1},
		flare = {default = 60, increment = 10, chargeSz = 1},
		preferred_flare_kind = 2,
	},
	Sensors = {
		RADAR = "AN/APG-73",
		RWR = "Abstract RWR"
	},
	Countermeasures = {
		ECM = {"AN/ALQ-165"}
	},
	EPLRS = true,

	Pylons =	{
		pylon(
			1,
			0,-- make it "hatch" station , it will be invisible until hatch is closed , it is always closed on hornet
			0, 0, 0,
			{
				use_full_connector_position = true,
				connector = "PYLON_01",
			},
			tips, 1
		),
		pylon(
			2,
			0,
			0, 0, 0,
			{
				use_full_connector_position = true,
				connector = "PYLON_07",
			},
			centerline, 2
		),
		pylon(
			3,
			0,-- make it "hatch" station , it will be invisible until hatch is closed , it is always closed on hornet
			0, 0, 0,
			{
				use_full_connector_position = true,
				connector = "PYLON_13",
			},
			tips, 3
		),
	},
	
	--0043552: Hornet: Gun should not have tracers
	--Tracers are an option but not often used. My suggestion is to keep them by default because they look awesome, and make it a load option or a menu option to not use tracers.
	ammo_type ={ _("Default"),
				 _("No Tracers"),
				},
	Guns = {
		gun_mount("M_61", {count = 640}, {muzzle_pos_connector = "Gun_point_00"})
	},

	HumanRadio	= {
		frequency		= 305.0,
		editable		= true,
		minFrequency	=  30.000,
		maxFrequency	= 399.975,
		rangeFrequency = {
			{min =  30.0, max =  87.995, modulation	= MODULATION_FM},
			{min = 118.0, max = 135.995, modulation	= MODULATION_AM},
			{min = 136.0, max = 155.995, modulation	= MODULATION_AM_AND_FM},
			{min = 156.0, max = 173.995, modulation	= MODULATION_FM},
			{min = 225.0, max = 399.975, modulation	= MODULATION_AM_AND_FM}
		},
		modulation	= MODULATION_AM,
	},
	panelRadio	= {
		[1] = {
			name = _("COMM 1: ARC-210"),
			range = {
				{min =  30.0, max =  87.995, modulation	= MODULATION_FM},
				{min = 118.0, max = 135.995, modulation	= MODULATION_AM},
				{min = 136.0, max = 155.995, modulation	= MODULATION_AM_AND_FM},
				{min = 156.0, max = 173.995, modulation	= MODULATION_FM},
				{min = 225.0, max = 399.975, modulation	= MODULATION_AM_AND_FM}
			},
			channels = {
				[1] =  { name = _("Channel 1"),		default = 305.0, connect = true}, -- default
				[2] =  { name = _("Channel 2"),		default = 264.0},	-- min. water : 135.0, 264.0
				[3] =  { name = _("Channel 3"),		default = 265.0},	-- nalchik : 136.0, 265.0
				[4] =  { name = _("Channel 4"),		default = 256.0},	-- sochi : 127.0, 256.0
				[5] =  { name = _("Channel 5"),		default = 254.0},	-- maykop : 125.0, 254.0
				[6] =  { name = _("Channel 6"),		default = 250.0},	-- anapa : 121.0, 250.0
				[7] =  { name = _("Channel 7"),		default = 270.0},	-- beslan : 141.0, 270.0
				[8] =  { name = _("Channel 8"),		default = 257.0},	-- krasnodar-pashk. : 128.0, 257.0
				[9] =  { name = _("Channel 9"),		default = 255.0},	-- gelenjik : 126.0, 255.0
				[10] = { name = _("Channel 10"),	default = 262.0},	-- kabuleti : 133.0, 262.0
				[11] = { name = _("Channel 11"),	default = 259.0},	-- gudauta : 130.0, 259.0
				[12] = { name = _("Channel 12"),	default = 268.0},	-- soginlug : 139.0, 268.0
				[13] = { name = _("Channel 13"),	default = 269.0},	-- vaziani : 140.0, 269.0
				[14] = { name = _("Channel 14"),	default = 260.0},	-- batumi : 131.0, 260.0
				[15] = { name = _("Channel 15"),	default = 263.0},	-- kutaisi : 134.0, 263.0
				[16] = { name = _("Channel 16"),	default = 261.0},	-- senaki : 132.0, 261.0
				[17] = { name = _("Channel 17"),	default = 267.0},	-- lochini : 138.0, 267.0
				[18] = { name = _("Channel 18"),	default = 251.0},	-- krasnodar-center : 122.0, 251.0
				[19] = { name = _("Channel 19"),	default = 253.0},	-- krymsk : 124.0, 253.0
				[20] = { name = _("Channel 20"),	default = 266.0},	-- mozdok : 137.0, 266.0
			}
		},
		[2] = {
			name = _("COMM 2: ARC-210"),
			range = {
				{min =  30.0, max =  87.995, modulation	= MODULATION_FM},
				{min = 118.0, max = 135.995, modulation	= MODULATION_AM},
				{min = 136.0, max = 155.995, modulation	= MODULATION_AM_AND_FM},
				{min = 156.0, max = 173.995, modulation	= MODULATION_FM},
				{min = 225.0, max = 399.975, modulation	= MODULATION_AM_AND_FM}
			},
			channels = {
				[1] =  { name = _("Channel 1"),		default = 305.0},	-- default
				[2] =  { name = _("Channel 2"),		default = 264.0},	-- min. water : 135.0, 264.0
				[3] =  { name = _("Channel 3"),		default = 265.0},	-- nalchik : 136.0, 265.0
				[4] =  { name = _("Channel 4"),		default = 256.0},	-- sochi : 127.0, 256.0
				[5] =  { name = _("Channel 5"),		default = 254.0},	-- maykop : 125.0, 254.0
				[6] =  { name = _("Channel 6"),		default = 250.0},	-- anapa : 121.0, 250.0
				[7] =  { name = _("Channel 7"),		default = 270.0},	-- beslan : 141.0, 270.0
				[8] =  { name = _("Channel 8"),		default = 257.0},	-- krasnodar-pashk. : 128.0, 257.0
				[9] =  { name = _("Channel 9"),		default = 255.0},	-- gelenjik : 126.0, 255.0
				[10] = { name = _("Channel 10"),	default = 262.0},	-- kabuleti : 133.0, 262.0
				[11] = { name = _("Channel 11"),	default = 259.0},	-- gudauta : 130.0, 259.0
				[12] = { name = _("Channel 12"),	default = 268.0},	-- soginlug : 139.0, 268.0
				[13] = { name = _("Channel 13"),	default = 269.0},	-- vaziani : 140.0, 269.0
				[14] = { name = _("Channel 14"),	default = 260.0},	-- batumi : 131.0, 260.0
				[15] = { name = _("Channel 15"),	default = 263.0},	-- kutaisi : 134.0, 263.0
				[16] = { name = _("Channel 16"),	default = 261.0},	-- senaki : 132.0, 261.0
				[17] = { name = _("Channel 17"),	default = 267.0},	-- lochini : 138.0, 267.0
				[18] = { name = _("Channel 18"),	default = 251.0},	-- krasnodar-center : 122.0, 251.0
				[19] = { name = _("Channel 19"),	default = 253.0},	-- krymsk : 124.0, 253.0
				[20] = { name = _("Channel 20"),	default = 266.0},	-- mozdok : 137.0, 266.0
			}
		},
	},
	TACAN_AA	= true,

	Tasks		= {
		aircraft_task(CAP),
		aircraft_task(Escort),
		aircraft_task(FighterSweep),
		aircraft_task(Intercept),
		aircraft_task(PinpointStrike),
		aircraft_task(CAS),
		aircraft_task(GroundAttack),
		aircraft_task(RunwayAttack),
		aircraft_task(SEAD),
		aircraft_task(AFAC),
		aircraft_task(AntishipStrike),
		aircraft_task(Reconnaissance),
	},-- end of Tasks
	DefaultTask	=   aircraft_task(CAP),

	-------------------------
	M_empty					=	11000,			-- [kg] 25094 lb
	M_nominal				=	16000,
	M_max					=	23500,
	M_fuel_max				=	4996,
	H_max					=	19812,
	CAS_min					=	62,
	V_opt					=	180,
	V_take_off				=	69,
	V_land					=	65,
	V_max_sea_level			=	361.1,
	V_max_h					=	541.7,
	Mach_max				=	1.8,
	Vy_max					=	254,
	Ny_min					=	-3,
	Ny_max					=	9,
	Ny_max_e				=	9,
	bank_angle_max			=	65,
	AOA_take_off			=	0.16,
	range					=	1520,
	average_fuel_consumption =	0.85,
	thrust_sum_max			=	13000,
	thrust_sum_ab			=	20000,
	wing_area	=	51.2,
	wing_span	=	10.95,
	length		=	15.96,
	height		=	5.28,

	flaps_maneuver			=	0.5,
	stores_number			=	10,
	has_afteburner			=	true,
	has_speedbrake			=	true,
	brakeshute_name			=	1,
	radar_can_see_ground	=	true,
	RCS						=	5,
	detection_range_max		=	160,
	IR_emission_coeff		=	0.75,
	IR_emission_coeff_ab	=	4.0,
	air_refuel_receptacle_pos =	{6.731,	0.825,	0.492},
	tanker_type				=	2,

	wing_tip_pos			= 	{-2.466,	0.115,	5.73},



	tand_gear_max								=	3.73,
	nose_gear_pos								= 	{2.522,	-2.176,	0},
	nose_gear_amortizer_direct_stroke			= 	0,			-- down from nose_gear_pos !!!
	nose_gear_amortizer_reversal_stroke			= 	-0.181,		-- up
	nose_gear_amortizer_normal_weight_stroke	= 	-0.139,	-- down from nose_gear_pos
	nose_gear_wheel_diameter					=	0.5385,
	nose_gear_door_close_after_retract			=	false,

	main_gear_pos								= 	{-1.483, -2.076, 2.023},
	main_gear_amortizer_direct_stroke			=	0,			-- down from main_gear_pos !!!
	main_gear_amortizer_reversal_stroke			= 	-0.118,		-- up
	main_gear_amortizer_normal_weight_stroke	= 	-0.054,	-- down from main_gear_pos
	main_gear_wheel_diameter					=	0.68,
	main_gear_door_close_after_retract			=	false,


	engines_count	=	2,
	engines_nozzles = 
	{
       [1] = 
        {
            pos = 	{-6.751,	0.067,	-0.705},
            elevation					= 0,
            diameter					= 0.8,
            exhaust_length_ab			= 4,
            exhaust_length_ab_K			= 1.4,
			afterburner_circles_count	= 4,
			afterburner_circles_pos		= {0.2, 0.8},
			afterburner_circles_scale	= 1.0,
			afterburner_effect_texture	= "afterburner_F-15E_SE",
            smokiness_level				= 0.2, 
        }, -- end of [1]
        [2] = 
        {
            pos = 	{-6.751,	0.067,	0.705},
            elevation					= 0,
            diameter					= 0.8,
            exhaust_length_ab			= 4,
            exhaust_length_ab_K			= 1.4,
			afterburner_circles_count	= 4,
			afterburner_circles_pos		= {0.2, 0.8},
			afterburner_circles_scale	= 1.0,
			afterburner_effect_texture	= "afterburner_F-15E_SE",
            smokiness_level				=  0.2, 
        }, -- end of [2]
	}, -- end of engines_nozzles

	sounderName = "Aircraft/Planes/Typhoon FGR4",

	crew_members = 
	{
		[1] = 
		{
			ejection_seat_name	=	17,
			drop_canopy_name	=	"FGR4_fonar",
			canopy_pos = {0, 0, 0},
			pos = 	{3.755,	0.4,	0},
			bailout_arg = -1,
		}, -- end of [1]
	}, -- end of crew_members
	
	

	mechanimations = {
		Door0 = {
			{Transition = {"Close", "Open"},  Sequence = {{C = {{"Arg", 38, "to", 0.9, "in", 9.0},},},}, Flags = {"Reversible"},},
			{Transition = {"Open", "Close"},  Sequence = {{C = {{"Arg", 38, "to", 0.0, "in", 6.0},},},}, Flags = {"Reversible", "StepsBackwards"},},
			{Transition = {"Any", "Bailout"}, Sequence = {{C = {{"JettisonCanopy", 0},},},},},
		},
		ServiceHatches = {
			{Transition = {"Close", "Open"}, Sequence = {{C = {{"PosType", 3}, {"Sleep", "for", 30.0}}}, {C = {{"Arg", 24, "set", 1.0}}}}},
			{Transition = {"Open", "Close"}, Sequence = {{C = {{"PosType", 6}, {"Sleep", "for", 5.0}}}, {C = {{"Arg", 24, "set", 0.0}}}}},
		},
		CrewLadder = {
			{Transition = {"Dismantle", "Erect"}, Sequence = {
				{C = {{"Arg", 91, "to", 1.0, "in", 3.0}}},
			}},
			{Transition = {"Erect", "Dismantle"}, Sequence = {
				{C = {{"Arg", 91, "to", 0.0, "in", 3.0}}},
			}},
		},
	}, -- end of mechanimations

	-- add model draw args for network transmitting to this draw_args table (16 limit)
	net_animation = 
	{
		2,--[[nws]]
		13, --[[right LE flap]]
		14, --[[left LE flap]]
		15, --[[right flaperon]]
		16, --[[left flaperon]]
		19, --[[right canard]]
		20, --[[left canard]]
		89, --[[right nozzle]]
		90, --[[left nozzle]]
		99, --[[head move up/down]]
	},

	fires_pos = 
	{
		[1] = 	{-0.232,	0.262,	0},
		[2] = 	{-1.938,	0.08,	 1.344},
		[3] = 	{-1.945,	0.056,	-1.359},
		[4] = 	{-2.52,		0.265,	 3.274},
		[5] = 	{-2.52,		0.265,	-3.274},
		[6] = 	{-2.73,		0.255,	 4.634},
		[7] = 	{-2.73,		0.255,	-4.634},
		[8] = 	{-7.128,	0.039,	 0.5},
		[9] = 	{-7.728,	0.039,	-0.5},
		[10] = 	{-7.728,	0.039,	 0.5},
		[11] = 	{-7.728,	0.039,	-0.5},
	}, -- end of fires_pos
	
	--[[ effects_presets = {
		{effect = "APU_STARTUP_BLAST", preset = "F18", ttl = 3.0},
		{effect = "OVERWING_VAPOR", file = current_mod_path.."/Effects/FA-18C_overwingVapor.lua"},
	}, ]]
	chaff_flare_dispenser = 
	{
		[1] = 
		{
			dir = 	{0,	-1,	0},
			pos = 	{-0.94,	-0.71,	-0.843},
		}, -- end of [1]
		[2] = 
		{
			dir = 	{0,	-1,	0},
			pos = 	{-1.19,	-0.71,	-0.843},
		}, -- end of [2]
		[3] = 
		{
			dir = 	{0,	-1,	0},
			pos = 	{-0.94,	-0.71,	0.843},
		}, -- end of [3]
		[4] = 
		{
			dir = 	{0,	-1,	0},
			pos = 	{-1.19,	-0.71,	0.843},
		}, -- end of [4]
	}, -- end of chaff_flare_dispenser
	
	Failures =
	{
		-- electric system
		{ id = 'Failure_Elec_UtilityBattery',					label = _('Utility Battery FAILURE'), 								enable = false, hh = 0, mm = 0, mmint = 1, prob = 100 },
		{ id = 'Failure_Elec_EmergencyBattery',					label = _('Emergency Battery FAILURE'), 							enable = false, hh = 0, mm = 0, mmint = 1, prob = 100 },
		{ id = 'Failure_Elec_LeftGenerator',					label = _('Left Generator FAILURE'),								enable = false, hh = 0, mm = 0, mmint = 1, prob = 100 },
		{ id = 'Failure_Elec_RightGenerator',					label = _('Right Generator FAILURE'), 								enable = false, hh = 0, mm = 0, mmint = 1, prob = 100 },
		{ id = 'Failure_Elec_LeftTransformerRectifier',			label = _('Left Transformer-Rectifier FAILURE'), 					enable = false, hh = 0, mm = 0, mmint = 1, prob = 100 },
		{ id = 'Failure_Elec_RightTransformerRectifier',		label = _('Right Transformer-Rectifier FAILURE'), 					enable = false, hh = 0, mm = 0, mmint = 1, prob = 100 },
		-- hydraulic system
		{ id = 'Failure_Hyd_HYD1A_Leak',						label = _('HYD 1A LEAKAGE'),										enable = false, hh = 0, mm = 0, mmint = 1, prob = 100 },
		{ id = 'Failure_Hyd_HYD1B_Leak',						label = _('HYD 1B LEAKAGE'), 										enable = false, hh = 0, mm = 0, mmint = 1, prob = 100 },
		{ id = 'Failure_Hyd_HYD2A_Leak',						label = _('HYD 2A LEAKAGE'), 										enable = false, hh = 0, mm = 0, mmint = 1, prob = 100 },
		{ id = 'Failure_Hyd_HYD2B_Leak',						label = _('HYD 2B LEAKAGE'), 										enable = false, hh = 0, mm = 0, mmint = 1, prob = 100 },
		{ id = 'Failure_Hyd_IsolatedHYD2BSystem_Leak',			label = _('Isolated HYD 2B System LEAKAGE'), 						enable = false, hh = 0, mm = 0, mmint = 1, prob = 100 },
		-- power plant
		{ id = 'Failure_PP_EngL_Main_FFCS',						label = _('Left Engine: Main Fuel Flow Control System FAILURE'),	enable = false, hh = 0, mm = 0, mmint = 1, prob = 100 },
		{ id = 'Failure_PP_EngR_Main_FFCS',						label = _('Right Engine: Main Fuel Flow Control System FAILURE'),	enable = false, hh = 0, mm = 0, mmint = 1, prob = 100 },
		{ id = 'Failure_PP_EngL_AB_FFCS',						label = _('Left Engine: AB Fuel Flow Control System FAILURE'),		enable = false, hh = 0, mm = 0, mmint = 1, prob = 100 },
		{ id = 'Failure_PP_EngR_AB_FFCS',						label = _('Right Engine: AB Fuel Flow Control System FAILURE'),		enable = false, hh = 0, mm = 0, mmint = 1, prob = 100 },
		{ id = 'Failure_PP_EngL_Nozzle_CS',						label = _('Left Engine: Nozzle Control System FAILURE'),			enable = false, hh = 0, mm = 0, mmint = 1, prob = 100 },
		{ id = 'Failure_PP_EngR_Nozzle_CS',						label = _('Right Engine: Nozzle Control System FAILURE'),			enable = false, hh = 0, mm = 0, mmint = 1, prob = 100 },
		{ id = 'Failure_PP_EngL_OilLeak',						label = _('Left Engine: Oil LEAKAGE'),								enable = false, hh = 0, mm = 0, mmint = 1, prob = 100 },
		{ id = 'Failure_PP_EngR_OilLeak',						label = _('Right Engine: Oil LEAKAGE'),								enable = false, hh = 0, mm = 0, mmint = 1, prob = 100 },
		{ id = 'Failure_PP_LeftPTS',							label = _('Left PTS FAILURE'),										enable = false, hh = 0, mm = 0, mmint = 1, prob = 100 },
		{ id = 'Failure_PP_RightPTS',							label = _('Right PTS FAILURE'),										enable = false, hh = 0, mm = 0, mmint = 1, prob = 100 },
		{ id = 'Failure_PP_LeftAMAD_OilLeak',					label = _('Left AMAD Oil LEAKAGE'),									enable = false, hh = 0, mm = 0, mmint = 1, prob = 100 },
		{ id = 'Failure_PP_RightAMAD_OilLeak',					label = _('Right AMAD Oil LEAKAGE'),								enable = false, hh = 0, mm = 0, mmint = 1, prob = 100 },
		-- fuel system
		{ id = 'Failure_Fuel_LeftBoostPump',					label = _('Left Boost Pump FAILURE'),								enable = false, hh = 0, mm = 0, mmint = 1, prob = 100 },
		{ id = 'Failure_Fuel_RightBoostPump',					label = _('Right Boost Pump FAILURE'),								enable = false, hh = 0, mm = 0, mmint = 1, prob = 100 },
		{ id = 'Failure_Fuel_Tank1Transfer',					label = _('Tank 1 Transfer FAILURE'),								enable = false, hh = 0, mm = 0, mmint = 1, prob = 100 },
		{ id = 'Failure_Fuel_Tank4Transfer',					label = _('Tank 4 Transfer FAILURE'),								enable = false, hh = 0, mm = 0, mmint = 1, prob = 100 },
		{ id = 'Failure_Fuel_ExtTankTransferL',					label = _('External Left Wing Tank Transfer FAILURE'),				enable = false, hh = 0, mm = 0, mmint = 1, prob = 100 },
		{ id = 'Failure_Fuel_ExtTankTransferR',					label = _('External Right Wing Tank Transfer FAILURE'),				enable = false, hh = 0, mm = 0, mmint = 1, prob = 100 },
		{ id = 'Failure_Fuel_ExtTankTransferC',					label = _('External Centerline Tank Transfer FAILURE'),				enable = false, hh = 0, mm = 0, mmint = 1, prob = 100 },
		{ id = 'Failure_Fuel_QuantityGaging',					label = _('Fuel Quantity Gaging System FAILURE'),					enable = false, hh = 0, mm = 0, mmint = 1, prob = 100 },
		-- gear system
		{ id = 'Failure_Gear_WOW',								label = _('WOW System FAILURE'),									enable = false, hh = 0, mm = 0, mmint = 1, prob = 100 },
		{ id = 'Failure_Gear_NWS',								label = _('NWS FAILURE'),											enable = false, hh = 0, mm = 0, mmint = 1, prob = 100 },
		-- ECS
		{ id = 'Failure_ECS_Valve',								label = _('ECS Valve FAILURE'),										enable = false, hh = 0, mm = 0, mmint = 1, prob = 100 },
		{ id = 'Failure_ECS_OBOGS',								label = _('OBOGS FAILURE'),											enable = false, hh = 0, mm = 0, mmint = 1, prob = 100 },
		-- control system
		{ id = 'Failure_Ctrl_LEF',								label = _('LEF FAILURE'),											enable = false, hh = 0, mm = 0, mmint = 1, prob = 100 },
		{ id = 'Failure_Ctrl_Aileron',							label = _('Aileron FAILURE'),										enable = false, hh = 0, mm = 0, mmint = 1, prob = 100 },
		{ id = 'Failure_Ctrl_FCS_Ch1',							label = _('FCS Channel 1 FAILURE'),									enable = false, hh = 0, mm = 0, mmint = 1, prob = 100 },
		{ id = 'Failure_Ctrl_FCS_Ch2',							label = _('FCS Channel 2 FAILURE'),									enable = false, hh = 0, mm = 0, mmint = 1, prob = 100 },
		{ id = 'Failure_Ctrl_FCS_Ch3',							label = _('FCS Channel 3 FAILURE'),									enable = false, hh = 0, mm = 0, mmint = 1, prob = 100 },
		{ id = 'Failure_Ctrl_FCS_Ch4',							label = _('FCS Channel 4 FAILURE'),									enable = false, hh = 0, mm = 0, mmint = 1, prob = 100 },
		-- computers
		{ id = 'Failure_Comp_ADC',								label = _('ADC FAILURE'),											enable = false, hh = 0, mm = 0, mmint = 1, prob = 100 },
		{ id = 'Failure_Comp_MC1',								label = _('MC 1 FAILURE'),											enable = false, hh = 0, mm = 0, mmint = 1, prob = 100 },
		{ id = 'Failure_Comp_MC2',								label = _('MC 2 FAILURE'),											enable = false, hh = 0, mm = 0, mmint = 1, prob = 100 },
		--{ id = 'Failure_Comp_CSC_Mux',							label = _('CSC MUX FAILURE'),										enable = false, hh = 0, mm = 0, mmint = 1, prob = 100 },
		-- sensors
		{ id = 'Failure_Sens_LeftPitotHeater',					label = _('Left PITOT Heater FAILURE'),								enable = false, hh = 0, mm = 0, mmint = 1, prob = 100 },
		{ id = 'Failure_Sens_RightPitotHeater',					label = _('Right PITOT Heater FAILURE'),							enable = false, hh = 0, mm = 0, mmint = 1, prob = 100 },
	},

	Damage = verbose_to_dmg_properties(
	{
		["NOSE_CENTER"]				= {args = {146}, critical_damage = 3},-- NOSE_CENTER
		["NOSE_BOTTOM"]				= {args = {148}, critical_damage = 3},-- NOSE_BOTTOM
		["NOSE_LEFT_SIDE"]			= {args = {150}, critical_damage = 3},-- NOSE_LEFT_SIDE
		["NOSE_RIGHT_SIDE"]			= {args = {149}, critical_damage = 3},-- NOSE_RIGHT_SIDE
		
		["COCKPIT"]					= {args = {65},  critical_damage = 1},-- COCKPIT
		["CABIN_BOTTOM"]			= {args = {152}, critical_damage = 3},-- CABIN_BOTTOM
		["CABIN_LEFT_SIDE"]			= {args = {298}, critical_damage = 3},-- CABIN_LEFT_SIDE
		["CABIN_RIGHT_SIDE"]		= {args = {299}, critical_damage = 3},-- CABIN_RIGHT_SIDE
		["FRONT_GEAR_BOX"]			= {args = {265}, critical_damage = 2},
		["WHEEL_F"]					= {args = {135}, critical_damage = 3},-- WHEEL_F

		["FUSELAGE_LEFT_SIDE"]		= {args = {154}, critical_damage = 3},-- FUSELAGE_LEFT_SIDE
		["FUSELAGE_RIGHT_SIDE"]		= {args = {153}, critical_damage = 3},-- FUSELAGE_RIGHT_SIDE
		["FUSELAGE_BOTTOM"]			= {args = {152}, critical_damage = 4},-- FUSELAGE_BOTTOM
		["LEFT_GEAR_BOX"]			= {args = {267}, critical_damage = 3},
		["WHEEL_L"]					= {args = {137}, critical_damage = 3},-- WHEEL_L
		["RIGHT_GEAR_BOX"]			= {args = {266}, critical_damage = 3},
		["WHEEL_R"]					= {args = {136}, critical_damage = 3},-- WHEEL_R

		["TAIL_LEFT_SIDE"]			= {args = {158}, critical_damage = 3},-- TAIL_LEFT_SIDE
		["TAIL_RIGHT_SIDE"]			= {args = {157}, critical_damage = 3},-- TAIL_RIGHT_SIDE
		["TAIL_BOTTOM"]				= {args = {156}, critical_damage = 3},-- 
		["HOOK"]					= {critical_damage = 2},
		["AIR_BRAKE"]				= {args = {183}, critical_damage = 1},-- 

		["ENGINE_L"]				= {args = {177}, critical_damage = 2},-- ENGINE_L	-- 178,179
		["ENGINE_R"]				= {args = {160}, critical_damage = 2},-- ENGINE_R	-- 161,162

		["WING_L_IN"]				= {args = {225}, critical_damage = 5, deps_cells = {"WING_L_CENTER", "WING_L_OUT", "WING_L_PART_IN", "WING_L_PART_OUT", "ELERON_L", "FLAP_L_IN"}},-- WING_L_IN
		["WING_L_CENTER"]			= {args = {224}, critical_damage = 4, deps_cells = {"WING_L_OUT", "WING_L_PART_IN", "WING_L_PART_OUT", "ELERON_L"}},-- WING_L_CENTER
		["WING_L_OUT"]				= {args = {223}, critical_damage = 3},		-- WING_L_OUT
		["WING_L_PART_IN"]			= {args = {230}, critical_damage = 1.5},	-- WING_L_PART_IN  -- inboard slat
		["WING_L_PART_OUT"]			= {args = {232}, critical_damage = 1.5},	-- WING_L_PART_OUT -- outboard slat
		["FLAP_L_IN"]				= {args = {227}, critical_damage = 2},		-- FLAP_L_IN -- flap
		["ELERON_L"]				= {args = {226}, critical_damage = 1},		-- ELERON_L

		["WING_R_IN"]				= {args = {215}, critical_damage = 5,deps_cells = {"WING_R_CENTER", "WING_R_OUT", "WING_R_PART_IN", "WING_R_PART_OUT", "ELERON_R", "FLAP_R_IN"}},-- WING_R_IN
		["WING_R_CENTER"]			= {args = {214}, critical_damage = 4,deps_cells = {"WING_R_OUT", "WING_R_PART_IN", "WING_R_PART_OUT", "ELERON_R"}},-- WING_R_CENTER
		["WING_R_OUT"]				= {args = {213}, critical_damage = 3},		-- WING_R_OUT
		["WING_R_PART_IN"]			= {args = {220}, critical_damage = 1.5},	-- WING_R_PART_IN  -- inboard slat
		["WING_R_PART_OUT"]			= {args = {222}, critical_damage = 1.5},	-- WING_R_PART_OUT -- outboard slat
		["FLAP_R_IN"]				= {args = {217}, critical_damage = 2},		-- FLAP_R_IN -- flap
		["ELERON_R"]				= {args = {216}, critical_damage = 1},		-- ELERON_R

		["FIN_L_BOTTOM"]			= {args = {245}, critical_damage = 4, deps_cells = {"RUDDER_L"}},
		["FIN_L_CENTER"]			= {args = {245}, critical_damage = 4, deps_cells = {"RUDDER_L"}},	-- ??
		["FIN_L_TOP"]				= {args = {244}, critical_damage = 4},
		["RUDDER_L"]				= {args = {248}, critical_damage = 1},-- RUDDER_L

		["FIN_R_BOTTOM"]			= {args = {242}, critical_damage = 4, deps_cells = {"RUDDER_R"}},
		["FIN_R_CENTER"]			= {args = {242}, critical_damage = 4, deps_cells = {"RUDDER_R"}},	-- ??
		["FIN_R_TOP"]				= {args = {241}, critical_damage = 4},
		["RUDDER_R"]				= {args = {247}, critical_damage = 1},-- RUDDER_R

		["STABILIZER_L_IN"]			= {args = {235}, critical_damage = 2},-- STABILIZER_L_IN
		["STABILIZER_R_IN"]			= {args = {233}, critical_damage = 2},-- STABILIZER_R_IN

	}),-- end of Damage
	
	AddPropAircraft = {
		{ id = "OuterBoard",			control = 'comboList', label = _('Outerboard rockets mode'),
			values = {
				{id =  0, dispName = _("Single")},
				{id =  1, dispName = _("Ripple")},
			},
			defValue	= 0,
			wCtrl		= 150,
			playerOnly	= true
		},
		{ id = "InnerBoard",			control = 'comboList', label = _('Innerboard rockets mode'),
			values = {
				{id = 0, dispName = _("Single")},
				{id = 1, dispName = _("Ripple")},
			},
			defValue	= 0,
			wCtrl		= 150,
			playerOnly = true
		}, 
	},
	
	dataCartridge = true,
	
	DamageParts 	=
 	{
		[1] = "F4E_oblomok_wing_R",
		[2] = "F4E_oblomok_wing_L",
	},
	
	SFM_Data = {
		aerodynamics = 
		{
			Cy0	=	0,
			Mzalfa	=	6,
			Mzalfadt	=	1.2,
			kjx	=	2.0,
			kjz	=	0.017,
			Czbe	=	-0.016,
			cx_gear	=	0.0268,
			cx_flap	=	0.05,
			cy_flap	=	0.52,
			cx_brk	=	0.06,
			table_data = 
			{
				--		M		Cx0					Cya					B					B4					Omxmax	Aldop				Cymax
			[1] =	{0,		0.0165,				0.07,				0.25,				0.032,				0.5,	60,					2.1},
			[2] =	{0.2,	0.0165,				0.07,				0.25,				0.032,				1.5,	60,					2.1},
			[3] =	{0.4,	0.0165,				0.066,				0.25,				0.032,				2.5,	60,					2.1},
			[4] =	{0.6,	0.0165,				0.06,				0.25,				0.043,				3.6,	60,					2.1},
			[5] =	{0.7,	0.017,				0.0575,				0.25,				0.045,				3.6,	45,	2.15},
			[6] =	{0.8,	0.024,				0.055,				0.25,				0.052,				3.6,	43,	2.2},
			[7] =	{0.9,	0.041,				0.0525,				0.25,				0.058,				3.6,	40,					2.25},
			[8] =	{1,		0.062,				0.05,				0.2,				0.1,				3.6,	35,	2.3},
			[9] =	{1.05,	0.061,				0.0475,				0.3,				0.095,				3.6,	35,					2.35},
			[10] =	{1.1,	0.06,				0.0455,				0.4,				0.09,				3.4,	33,					2.4},
			[11] =	{1.2,	0.051,				0.0425,				0.45,				0.12,				2.7,	32,					2.35},
			[12] =	{1.3,	0.046,				0.04,				0.45,				0.17,				2,		31,					2.3},
			[13] =	{1.49,	0.044,				0.0375,				0.45,				0.2,				1.5125,	30,				2.25},
			[14] =	{1.5,	0.043903225806452,	0.0355,				0.452,				0.2058064516129,	1.5,	27,					2.2},
			[15] =	{1.7,	0.041967741935484,	0.0325,				0.45,				0.32193548387097,	1.2,	26,					2.1},
			[16] =	{1.8,	0.041,				0.03,				0.45,				0.38,				1.2,	25,				2.0},
			[17] =	{2,		0.042,				0.0275,				0.45,				2.5,				1.2,	23,				1.9},
			[18] =	{2.2,	0.041,				0.0255,				0.45,				3.2,				1.2,	22,					1.85},
			[19] =	{2.5,	0.039,				0.0225,				0.45,				4.5,				1.2,	20,					1.8},
			[20] =	{3.9,	0.035,				0.02,				0.5,				6,					1.2,	20,					1.75},
			}, -- end of table_data
			-- M - Mach number
			-- Cx0 - Coefficient, drag, profile, of the airplane
			-- Cya - Normal force coefficient of the wing and body of the aircraft in the normal direction to that of flight. Inversely proportional to the available G-loading at any Mach value. (lower the Cya value, higher G available) per 1 degree AOA
			-- B - Polar quad coeff
			-- B4 - Polar 4th power coeff
			-- Omxmax - roll rate, rad/s
			-- Aldop - Alfadop Max AOA at current M - departure threshold
			-- Cymax - Coefficient, lift, maximum possible (ignores other calculations if current Cy > Cymax)
		}, -- end of aerodynamics
		engine =
		{
			Nmg		=	60,
			MinRUD	=	0,
			MaxRUD	=	1,
			MaksRUD	=	0.85,
			ForsRUD	=	0.91,
			type	=	"TurboFan",
			hMaxEng	=	16.76,
			dcx_eng	=	0.0125,
			cemax	=	1.2,
			cefor	=	2.8,
			dpdh_m	=	6200,
			dpdh_f	=	9500,
			table_data =
			{
				[1] =	{0,	107000,	170000},
				[2] =	{0.2,	104000,	189000},
				[3] =	{0.4,	104000,	189500},
				[4] =	{0.6,	115000,	190000},
				[5] =	{0.7,	115000,	195000},
				[6] =	{0.8,	120000,	198000},
				[7] =	{0.9,	140000,	200000},
				[8] =	{1,		100000,	210000},
				[9] =	{1.096,	96000,	210000},
				[10] =	{1.2,	86000,	210000},
				[11] =	{1.3,	68000,	210000},
				[12] =	{1.4,	55000,	216000},
				[13] =	{1.6,	56000,	226000},
				[14] =	{1.8,	56000,	236000},
				[15] =	{2.2,	52000,	246000},
				[16] =	{2.35,	43000,	256000},
				[17] =	{3.9,	25000,	200000},
			}, -- end of table_data
		}, -- end of engine
	},
	
	lights_data =
	{
		typename =	"collection",
		lights 	 = 
		{
			[WOLALIGHT_STROBES]	= {
				typename	=	"collection",
				lights 		= {
					{ typename = "argnatostrobelight", argument = 193, period = 1.2},		-- beacon lights
				},
			},--must be collection
			[WOLALIGHT_LANDING_LIGHTS]	= {
				typename	= 	"collection",
				lights		= {
					{ typename  = "argumentlight",	argument  = 210, },
				},
			},--must be collection
			[WOLALIGHT_TAXI_LIGHTS]	= {
				typename	= 	"collection",
				lights		= {
					{ typename  = "argumentlight",	argument  = 210, },
				},
			},--must be collection
			[WOLALIGHT_NAVLIGHTS]	= {
				typename 	= "collection",
				lights 		= {
					{ typename  = "argumentlight", argument  = 190, },				-- red
					{ typename  = "argumentlight", argument  = 191, },				-- green
					{ typename  = "argumentlight", argument  = 192, },				-- white
				},
			},--must be collection
			[WOLALIGHT_FORMATION_LIGHTS] = {
				typename	= "collection",
				lights		= {
					{ typename  = "argumentlight",	argument  = 88, },
				},		-- green bars
			},--must be collection
			-- REFUEL
			[WOLALIGHT_REFUEL_LIGHTS] = {
				typename = "collection",
				lights	 = {
					{ typename = "argumentlight",	argument = 212, },				-- AR light
				},
			},
			[WOLALIGHT_CABIN_NIGHT] = {
				typename = "collection",
				lights = {
					{ typename = "argumentlight", argument = 69, },
				},
			},
		}, -- end of lights
	},-- end of lights_data
	
	ColdStartDefaultControls = {
        [19]     = 1.0,        -- [15] = Canards
        [20]     = 1.0,        -- [16] = Canards
        [17]    = 1.0,        -- [17] = Right rudder
        [23]    = 1.0,         -- [23] = Covers
        [38]    = 1.0,         -- [38] = Canopy Open
        [99]    = 1.0,        -- [99] = Ladder
        [89]    = 1.0,        -- [89] = Right nozzle
        [90]    = 1.0,        -- [90] = Left nozzle
	}

}

add_aircraft(FGR4)