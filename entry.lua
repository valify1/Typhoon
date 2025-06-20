self_ID = "EF-2000 Mod for the Virtual Typhoon Display Team"
declare_plugin(self_ID,
{
image     	 = "Typhoon FGR4.bmp",
installed 	 = true, -- if false that will be place holder , or advertising
dirName	  	 = current_mod_path,
displayName  = _("EF-2000"),
developerName = _("Virtual Typhoon Display Team"),

fileMenuName = _("EF-2000"),
update_id        = "EF-2000",
version		 = "EA",
state		 = "installed",
info		 = _("EF-2000 Mod for the Virtual Typhoon Display Team, DO NOT REDISTRIBUTE!"),

Skins	=
	{
		{
		    name	= _("Typhoon FGR4"),
			dir		= "Skins/1"
		},
	},
Missions =
	{
		{
			name		    = _("Typhoon FGR4"),
			dir			    = "Missions",
  		},
	},
LogBook =
	{
		{
			name		= _("Typhoon FGR4"),
			type		= "Typhoon FGR4",
		},
	},	
		
InputProfiles =
	{
		["Typhoon FGR4"] = current_mod_path .. '/Input/Typhoon FGR4',
	},
--[[ binaries 	 =
{
'FGR4FM',
}, ]]
	
})
----------------------------------------------------------------------------------------
mount_vfs_model_path	(current_mod_path.."/Cockpit/Shape")
mount_vfs_texture_path	(current_mod_path.."/Cockpit/Textures/FGR4_CPT_TEXTURES.zip")
mount_vfs_liveries_path (current_mod_path.."/Liveries")
mount_vfs_texture_path	(current_mod_path.."/Skins/1/ME")--for simulator loading window

dofile(current_mod_path.."/Views.lua")
dofile(current_mod_path..'/Weapons/Weapons.lua')
dofile(current_mod_path..'/FGR4.lua')

-------------------------------------------------------------------------------------
make_flyable('Typhoon FGR4',current_mod_path..'/Cockpit/Scripts/',nil, current_mod_path..'/comm.lua')
make_view_settings('Typhoon FGR4', ViewSettings, SnapViews)
-------------------------------------------------------------------------------------
plugin_done()
