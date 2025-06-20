--dofile("Scripts/Database/Weapons/warheads.lua")
--local GALLON_TO_KG = 3.785 * 0.8

local pylon_mass 	= 0.0

declare_loadout({
	category		 = CAT_FUEL_TANKS,
	CLSID			 = "{FUEL_1KL_FGR4}",
	attribute		 =  {wsType_Air,wsType_Free_Fall,wsType_FuelTank,WSTYPE_PLACEHOLDER},
	Picture			 = "PTB.png",
	displayName		 = _("Fuel Tank 1000 liters"),
	Weight_Empty	 = 25,
	Weight			 = 1000,
	Cx_pil			 = 0.002,
	shape_table_data = 
	{
		{
			name 	= "FuelTank_1000L",
			file	= "FuelTank_1000L";
			life	= 1;
			fire	= { 0, 1};
			username	= "FuelTank 1000L";
			index	= WSTYPE_PLACEHOLDER;
		},
	},
	Elements	= 
	{
		{
			ShapeName	= "FuelTank_1000L",
		}, 
	}, 
})
