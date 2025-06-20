dofile(LockOn_Options.script_path.."Displays/HUD/Indicator/definitions.lua")

SHOW_MASKS = false

local INDICES = {0,1,2,0,2,3}

local half_width = GetScale()
local half_height = GetAspect() * half_width

local aspect = GetAspect()

local fd_move_multi = 0.5
local fd_move_multi_yaw = 0.05

local FONT_SIZE = {0.015,0.015,0,0}

base_clip                           = CreateElement"ceMeshPoly"
base_clip.name                      = "base_clip"
base_clip.primitivetype             = "triangles"

num_points = 24
step = math.rad(360.0/num_points)
TFOV  = 1 * 1.5
verts = {}
for i = 1, num_points do
	verts[i] = {TFOV * math.cos(i * step), TFOV * math.sin(i * step)}
end

base_clip.vertices                  = verts --vert_gen(700,800)

inds = {}
j = 0
for i = 0, 29 do
	j = j + 1
	inds[j] = 0
	j = j + 1
	inds[j] = i + 1
	j = j + 1
	inds[j] = i + 2
end

base_clip.indices                   = inds --{0,1,2,1,2,3}
base_clip.init_pos                  = {0,-0.1,0}
base_clip.init_rot                  = {0,0,-25}
base_clip.material                  = MakeMaterial(nil,{2,2,4,255})
base_clip.element_params            =
                                    {
                                        "HUD_PWR"
                                    }
base_clip.controllers               =
                                    {
                                        {"opacity_using_parameter",0,1}
                                    }
base_clip.h_clip_relation           = h_clip_relations.REWRITE_LEVEL
base_clip.level                     = DEFAULT_NOCLIP_LEVEL
base_clip.isdraw                    = true
base_clip.change_opacity            = true
base_clip.isvisible                 = SHOW_MASKS
Add(base_clip)

hud_roll                            = CreateElement "ceSimple"
hud_roll.name                       = "hud_roll"
hud_roll.init_pos                   = {0,-2.6,7}
hud_roll.init_rot                   = {0,0,25}
hud_roll.element_params             =
                                    {
                                        "ROLL"
                                    }
hud_roll.controllers                =
                                    {
                                        {"rotate_using_parameter",0,1}
                                    }
hud_roll.collimated                 = true
hud_roll.use_mipfilter              = true
hud_roll.additive_alpha             = true
hud_roll.h_clip_relation            = h_clip_relations.COMPARE
hud_roll.level                      = DEFAULT_NOCLIP_LEVEL
hud_roll.parent_element             = base_clip.name
Add(hud_roll)

hud_pitch                           = CreateElement "ceSimple"
hud_pitch.name                      = "hud_pitch"
hud_pitch.init_pos                  = {0,0,0}
hud_pitch.element_params            =
                                    {
                                        "PITCH",
                                        "HUD_X"
                                    }
hud_pitch.controllers               =
                                    {
                                        {"move_up_down_using_parameter",0,2.2},
                                        {"move_left_right_using_parameter",1,fd_move_multi_yaw}
                                    }
hud_pitch.collimated                = true
hud_pitch.use_mipfilter             = true
hud_pitch.additive_alpha            = true
hud_pitch.h_clip_relation           = h_clip_relations.COMPARE
hud_pitch.level                     = DEFAULT_NOCLIP_LEVEL
hud_pitch.parent_element            = hud_roll.name
Add(hud_pitch)

warning_clip                           = CreateElement"ceMeshPoly"
warning_clip.name                      = "warning_clip"
warning_clip.primitivetype             = "triangles"
warning_clip.vertices                  = vert_gen(700,900)
warning_clip.indices                   = {0,1,2,0,2,3}
warning_clip.init_pos                  = {0,-0.6,7}
warning_clip.init_rot                  = {0,0,0}
warning_clip.material                  = MakeMaterial(nil,{2,2,4,255})
warning_clip.element_params            =
                                        {
                                            "HUD_PWR"
                                        }
warning_clip.controllers               =
                                        {
                                            {"opacity_using_parameter",0,1}
                                        }
warning_clip.h_clip_relation           = h_clip_relations.COMPARE
warning_clip.level                     = DEFAULT_NOCLIP_LEVEL
warning_clip.isdraw                    = true
warning_clip.change_opacity            = true
warning_clip.isvisible                 = SHOW_MASKS
Add(warning_clip)

altitude_clip                           = CreateElement"ceMeshPoly"
altitude_clip.name                      = "altitude_clip"
altitude_clip.primitivetype             = "triangles"
altitude_clip.vertices                  = vert_gen(400,400)
altitude_clip.indices                   = {0,1,2,0,2,3}
altitude_clip.init_pos                  = {1.1,0.7,7}
altitude_clip.init_rot                  = {0,0,0}
altitude_clip.material                  = MakeMaterial(nil,{2,2,4,255})
altitude_clip.element_params            =
                                        {
                                            "HUD_PWR"
                                        }
altitude_clip.controllers               =
                                        {
                                            {"opacity_using_parameter",0,1}
                                        }
altitude_clip.h_clip_relation           = h_clip_relations.COMPARE
altitude_clip.level                     = DEFAULT_NOCLIP_LEVEL + 1
altitude_clip.isdraw                    = true
altitude_clip.change_opacity            = true
altitude_clip.isvisible                 = SHOW_MASKS
Add(altitude_clip)

alt_needle_clip                         = CreateElement"ceMeshPoly"
alt_needle_clip.name                    = "alt_needle_clip"
alt_needle_clip.primitivetype           = "triangles"
alt_needle_clip.vertices                = vert_gen(50,250)
alt_needle_clip.indices                 = {0,1,2,0,2,3}
alt_needle_clip.init_pos                = {1.1,0.7,7}
alt_needle_clip.init_rot                = {0,0,0}
alt_needle_clip.material                = MakeMaterial(nil,{2,2,4,255})
alt_needle_clip.element_params          =
                                        {
                                            "HUD_PWR",
                                            "ALT"
                                        }
alt_needle_clip.controllers             =
                                        {
                                            {"opacity_using_parameter",0,1},
                                            {"rotate_using_parameter",1,-math.rad(360.0) / 1000},
                                        }
alt_needle_clip.h_clip_relation         = h_clip_relations.COMPARE
alt_needle_clip.level                   = DEFAULT_NOCLIP_LEVEL
alt_needle_clip.isdraw                  = true
alt_needle_clip.change_opacity          = true
alt_needle_clip.isvisible               = SHOW_MASKS
Add(alt_needle_clip)

rad_alt_clip                           = CreateElement"ceMeshPoly"
rad_alt_clip.name                      = "rad_alt_clip"
rad_alt_clip.primitivetype             = "triangles"
rad_alt_clip.vertices                  = vert_gen(400,400)
rad_alt_clip.indices                   = {0,1,2,0,2,3}
rad_alt_clip.init_pos                  = {1.6,0.7,7}
rad_alt_clip.init_rot                  = {0,0,0}
rad_alt_clip.material                  = MakeMaterial(nil,{2,2,4,50})
rad_alt_clip.element_params            =
                                        {
                                            "HUD_PWR"
                                        }
rad_alt_clip.controllers               =
                                        {
                                            {"opacity_using_parameter",0,1}
                                        }
rad_alt_clip.h_clip_relation           = h_clip_relations.COMPARE
rad_alt_clip.level                     = DEFAULT_NOCLIP_LEVEL
rad_alt_clip.isdraw                    = true
rad_alt_clip.change_opacity            = true
rad_alt_clip.isvisible                 = SHOW_MASKS
Add(rad_alt_clip)

speed_clip                           = CreateElement"ceMeshPoly"
speed_clip.name                      = "speed_clip"
speed_clip.primitivetype             = "triangles"
speed_clip.vertices                  = vert_gen(400,400)
speed_clip.indices                   = {0,1,2,0,2,3}
speed_clip.init_pos                  = {-1.2,0.7,7}
speed_clip.init_rot                  = {0,0,0}
speed_clip.material                  = MakeMaterial(nil,{2,2,4,255})
speed_clip.element_params            =
                                    {
                                            "HUD_PWR"
                                    }
speed_clip.controllers               =
                                    {
                                        {"opacity_using_parameter",0,1}
                                    }
speed_clip.h_clip_relation           = h_clip_relations.COMPARE
speed_clip.level                     = DEFAULT_NOCLIP_LEVEL + 1
speed_clip.isdraw                    = true
speed_clip.change_opacity            = true
speed_clip.isvisible                 = SHOW_MASKS
Add(speed_clip)

gear_clip                           = CreateElement"ceMeshPoly"
gear_clip.name                      = "gear_clip"
gear_clip.primitivetype             = "triangles"
gear_clip.vertices                  = vert_gen(500,150)
gear_clip.indices                   = {0,1,2,0,2,3}
gear_clip.init_pos                  = {-1.7,-0.4,7}
gear_clip.init_rot                  = {0,0,0}
gear_clip.material                  = MakeMaterial(nil,{2,2,4,255})
gear_clip.element_params            =
                                    {
                                            "HUD_PWR"
                                    }
gear_clip.controllers               =
                                    {
                                        {"opacity_using_parameter",0,1}
                                    }
gear_clip.h_clip_relation           = h_clip_relations.COMPARE
gear_clip.level                     = DEFAULT_NOCLIP_LEVEL
gear_clip.isdraw                    = true
gear_clip.change_opacity            = true
gear_clip.isvisible                 = SHOW_MASKS
Add(gear_clip)

weapon_clip                         = CreateElement"ceMeshPoly"
weapon_clip.name                    = "weapon_clip"
weapon_clip.primitivetype           = "triangles"
weapon_clip.vertices                = vert_gen(500,150)
weapon_clip.indices                 = {0,1,2,0,2,3}
weapon_clip.init_pos                = {1.4,-1.0,7}
weapon_clip.init_rot                = {0,0,0}
weapon_clip.material                = MakeMaterial(nil,{2,2,4,255})
weapon_clip.element_params          =
                                    {
                                            "HUD_PWR"
                                    }
weapon_clip.controllers             =
                                    {
                                        {"opacity_using_parameter",0,1}
                                    }
weapon_clip.h_clip_relation         = h_clip_relations.COMPARE
weapon_clip.level                   = DEFAULT_NOCLIP_LEVEL
weapon_clip.isdraw                  = true
weapon_clip.change_opacity          = true
weapon_clip.isvisible               = SHOW_MASKS
Add(weapon_clip)

mach_clip                           = CreateElement"ceMeshPoly"
mach_clip.name                      = "mach_clip"
mach_clip.primitivetype             = "triangles"
mach_clip.vertices                  = vert_gen(400,400)
mach_clip.indices                   = {0,1,2,0,2,3}
mach_clip.init_pos                  = {-1.7,0.55,7}
mach_clip.init_rot                  = {0,0,0}
mach_clip.material                  = MakeMaterial(nil,{2,2,4,255})
mach_clip.element_params            =
                                    {
                                        "HUD_PWR"
                                    }
mach_clip.controllers               =
                                    {
                                        {"opacity_using_parameter",0,1}
                                    }
mach_clip.h_clip_relation           = h_clip_relations.COMPARE
mach_clip.level                     = DEFAULT_NOCLIP_LEVEL + 1
mach_clip.isdraw                    = true
mach_clip.change_opacity            = true
mach_clip.isvisible                 = SHOW_MASKS
Add(mach_clip)

g_clip                              = CreateElement"ceMeshPoly"
g_clip.name                         = "g_clip"
g_clip.primitivetype                = "triangles"
g_clip.vertices                     = vert_gen(200,200)
g_clip.indices                      = {0,1,2,0,2,3}
g_clip.init_pos                     = {-1,-0.5,7}
g_clip.init_rot                     = {0,0,0}
g_clip.material                     = MakeMaterial(nil,{2,2,4,255})
g_clip.element_params               =
                                    {
                                        "HUD_PWR"
                                    }
g_clip.controllers                  =
                                    {
                                        {"opacity_using_parameter",0,1}
                                    }
g_clip.h_clip_relation              = h_clip_relations.COMPARE
g_clip.level                        = DEFAULT_NOCLIP_LEVEL
g_clip.isdraw                       = true
g_clip.change_opacity               = true
g_clip.isvisible                    = SHOW_MASKS
Add(g_clip)

tape_clip                           = CreateElement"ceMeshPoly"
tape_clip.name                      = "tape_clip"
tape_clip.primitivetype             = "triangles"
tape_clip.vertices                  = vert_gen(1200,300)
tape_clip.indices                   = {0,1,2,0,2,3}
tape_clip.init_pos                  = {0,1.2,7}
tape_clip.init_rot                  = {0,0,0}
tape_clip.material                  = MakeMaterial(nil,{2,255,4,255})
tape_clip.element_params            =
                                    {
                                        "HUD_PWR",
                                    }
tape_clip.controllers               =
                                    {
                                        {"opacity_using_parameter",0,1}
                                    }
tape_clip.h_clip_relation           = h_clip_relations.INCREASE_IF_LEVEL
tape_clip.level                     = DEFAULT_NOCLIP_LEVEL
tape_clip.isdraw                    = true
tape_clip.change_opacity            = true
tape_clip.isvisible                 = SHOW_MASKS
Add(tape_clip)

bank_clip                           = CreateElement"ceMeshPoly"
bank_clip.name                      = "bank_clip"
bank_clip.primitivetype             = "triangles"
bank_clip.vertices                  = vert_gen(100,1000)
bank_clip.indices                   = INDICES
bank_clip.init_pos                  = {0,-0.7,7}
bank_clip.init_rot                  = {0,0,0}
bank_clip.material                  = MakeMaterial(nil,{0,0,5,255})
bank_clip.element_params            =
                                    {
                                        "HUD_PWR",
                                        "BANK"
                                    }
bank_clip.controllers               =
                                    {
                                        {"opacity_using_parameter",0,1},
                                        {"rotate_using_parameter",1,1}
                                    }
bank_clip.h_clip_relation           = h_clip_relations.COMPARE
bank_clip.level                     = DEFAULT_NOCLIP_LEVEL
bank_clip.isdraw                    = true
bank_clip.change_opacity            = true
bank_clip.isvisible                 = SHOW_MASKS
Add(bank_clip)

--------------------------------------------------
--------------------------------------------------
-------------------- WARNINGS --------------------
--------------------------------------------------
--------------------------------------------------

-- CURRENTLY WIP

--[[ pullup                              = CreateElement"ceTexPoly"
pullup.name                         = create_guid_string()
pullup.vertices                     = vert_gen(256,512)
pullup.tex_coords                   = tex_coord_gen(0,0,64,128,64,128)
pullup.indices                      = INDICES
pullup.init_pos                     = {0,0,0}
pullup.init_rot                     = {0,0,0}
pullup.material                     = PULL_UP
pullup.element_params               =
                                    {
                                        "PULL_UP"
                                    }
pullup.controllers                  =
                                    {
                                        {"opacity_using_parameter",0,1}
                                    }
pullup.h_clip_relation              = h_clip_relations.COMPARE
pullup.level                        = DEFAULT_NOCLIP_LEVEL
pullup.collimated                   = true
pullup.use_mipfilter                = true
pullup.additive_alpha               = true
pullup.parent_element               = warning_clip.name
Add(pullup)

pullup                              = CreateElement"ceStringPoly"
pullup.material                     = "hud_font_base"
pullup.init_pos                     = {0,-0.6,0}
pullup.alignment                    = "CenterCenter"
pullup.stringdefs                   = FONT_SIZE
pullup.formats                      = {"PULL_UP"}
pullup.element_params               =
                                    {
                                        "",
                                        "PULL_UP",
                                    }
pullup.controllers                  = 
                                    {
                                        {"text_using_parameter",0},
                                        {"opacity_using_parameter",1,1}
                                    }
pullup.collimated                   = true
pullup.use_mipfilter                = true
pullup.additive_alpha               = true
pullup.isvisible                    = true
pullup.h_clip_relation              = h_clip_relations.COMPARE
pullup.level                        = DEFAULT_NOCLIP_LEVEL
pullup.parent_element               = warning_clip.name
Add(pullup) ]]

--------------------------------------------------
--------------------------------------------------
-------------------- ALTITUDE --------------------
--------------------------------------------------
--------------------------------------------------

altitude                            = CreateElement"ceStringPoly"
altitude.material                   = "hud_font_base"
altitude.init_pos                   = {0.28,0,0}
altitude.alignment                  = "RightCenter"
altitude.stringdefs                 = FONT_SIZE
altitude.formats                    = {"%.0f"}
altitude.element_params             =
                                    {
                                        "ALT",
                                        "HUD_PWR",
                                    }
altitude.controllers                = 
                                    {
                                        {"text_using_parameter",0},
                                        {"opacity_using_parameter",1,1}
                                    }
altitude.collimated                 = true
altitude.use_mipfilter              = true
altitude.additive_alpha             = true
altitude.isvisible                  = true
altitude.h_clip_relation            = h_clip_relations.COMPARE
altitude.level                      = DEFAULT_NOCLIP_LEVEL
altitude.parent_element             = altitude_clip.name
Add(altitude)

altitude                            = CreateElement"ceStringPoly"
altitude.material                   = "hud_font_base"
altitude.init_pos                   = {0,0,0}
altitude.alignment                  = "CenterCenter"
altitude.stringdefs                 = FONT_SIZE
altitude.formats                    = {"R\n%.0f"}
altitude.element_params             =
                                    {
                                        "RALT",
                                        "HUD_PWR",
                                    }
altitude.controllers                = 
                                    {
                                        {"text_using_parameter",0},
                                        {"opacity_using_parameter",1,1}
                                    }
altitude.collimated                 = true
altitude.use_mipfilter              = true
altitude.additive_alpha             = true
altitude.isvisible                  = true
altitude.h_clip_relation            = h_clip_relations.COMPARE
altitude.level                      = DEFAULT_NOCLIP_LEVEL
altitude.parent_element             = rad_alt_clip.name
Add(altitude)

alt_circle                          = CreateElement"ceTexPoly"
alt_circle.name                     = create_guid_string()
alt_circle.vertices                 = vert_gen(400,400)
alt_circle.tex_coords               = tex_coord_gen(0,0,128,128,128,128)
alt_circle.indices                  = INDICES
alt_circle.init_pos                 = {0,0,0}
alt_circle.init_rot                 = {0,0,0}
alt_circle.material                 = CIRCLE_MAT
alt_circle.element_params           =
                                    {
                                        "HUD_PWR"
                                    }
alt_circle.controllers              =
                                    {
                                        {"opacity_using_parameter",0,1}
                                    }
alt_circle.h_clip_relation          = h_clip_relations.COMPARE
alt_circle.level                    = DEFAULT_NOCLIP_LEVEL
alt_circle.collimated               = true
alt_circle.use_mipfilter            = true
alt_circle.additive_alpha           = true
alt_circle.parent_element           = altitude_clip.name
Add(alt_circle)

alt_needle                          = CreateElement"ceMeshPoly"
alt_needle.vertices                 = vert_gen(15,35)
alt_needle.primitivetype            = "triangles"
alt_needle.indices                  = INDICES
alt_needle.material                 = MakeMaterial(nil,HUD_COLOR)
alt_needle.name                     = create_guid_string()
alt_needle.init_pos                 = {0,0.25,0}
alt_needle.init_rot                 = {0,0,0}
alt_needle.collimated               = true
alt_needle.element_params           =
                                    {
                                        "HUD_PWR"
                                    }
alt_needle.controllers              =
                                    {
                                        {"opacity_using_parameter",0,1}
                                    }
alt_needle.use_mipfilter            = true
alt_needle.additive_alpha           = true
alt_needle.h_clip_relation          = h_clip_relations.COMPARE
alt_needle.level                    = DEFAULT_NOCLIP_LEVEL
alt_needle.parent_element           = alt_needle_clip.name
Add(alt_needle)

--------------------------------------------------
--------------------------------------------------
------------------- AA DISPLAY -------------------
--------------------------------------------------
--------------------------------------------------

weapon                            = CreateElement"ceStringPoly"
weapon.material                   = "hud_font_base"
weapon.init_pos                   = {0,0,0}
weapon.alignment                  = "CenterCenter"
weapon.stringdefs                 = FONT_SIZE
weapon.formats                    = {"M\nS\nG"}
weapon.element_params             =
                                {
                                    "",
                                    "HUD_PWR",
                                }
weapon.controllers                = 
                                {
                                    {"text_using_parameter",0},
                                    {"opacity_using_parameter",1,1}
                                }
weapon.collimated                 = true
weapon.use_mipfilter              = true
weapon.additive_alpha             = true
weapon.isvisible                  = true
weapon.h_clip_relation            = h_clip_relations.COMPARE
weapon.level                      = DEFAULT_NOCLIP_LEVEL
weapon.parent_element             = weapon_clip.name
Add(weapon)

weapon                            = CreateElement"ceStringPoly"
weapon.material                   = "hud_font_base"
weapon.init_pos                   = {0.06,0,0}
weapon.alignment                  = "LeftCenter"
weapon.stringdefs                 = FONT_SIZE
weapon.formats                    = {"0\n0\n0"}
weapon.element_params             =
                                {
                                    "",
                                    "HUD_PWR",
                                }
weapon.controllers                = 
                                {
                                    {"text_using_parameter",0},
                                    {"opacity_using_parameter",1,1}
                                }
weapon.collimated                 = true
weapon.use_mipfilter              = true
weapon.additive_alpha             = true
weapon.isvisible                  = true
weapon.h_clip_relation            = h_clip_relations.COMPARE
weapon.level                      = DEFAULT_NOCLIP_LEVEL
weapon.parent_element             = weapon_clip.name
Add(weapon)

--------------------------------------------------
--------------------------------------------------
---------------------- GEAR ----------------------
--------------------------------------------------
--------------------------------------------------

gear_f                            = CreateElement"ceStringPoly"
gear_f.material                   = "hud_font_base"
gear_f.init_pos                   = {0,0,0}
gear_f.alignment                  = "CenterCenter"
gear_f.stringdefs                 = FONT_SIZE
gear_f.formats                    = {"%s"}
gear_f.element_params             =
                                {
                                    "GEAR_F",
                                    "HUD_PWR",
                                }
gear_f.controllers                = 
                                {
                                    {"text_using_parameter",0},
                                    {"opacity_using_parameter",1,1}
                                }
gear_f.collimated                 = true
gear_f.use_mipfilter              = true
gear_f.additive_alpha             = true
gear_f.isvisible                  = true
gear_f.h_clip_relation            = h_clip_relations.COMPARE
gear_f.level                      = DEFAULT_NOCLIP_LEVEL
gear_f.parent_element             = gear_clip.name
Add(gear_f)

gear_r                            = CreateElement"ceStringPoly"
gear_r.material                   = "hud_font_base"
gear_r.init_pos                   = {0.3,0,0}
gear_r.alignment                  = "CenterCenter"
gear_r.stringdefs                 = FONT_SIZE
gear_r.formats                    = {"%s"}
gear_r.element_params             =
                                {
                                    "GEAR_R",
                                    "HUD_PWR",
                                }
gear_r.controllers                = 
                                {
                                    {"text_using_parameter",0},
                                    {"opacity_using_parameter",1,1}
                                }
gear_r.collimated                 = true
gear_r.use_mipfilter              = true
gear_r.additive_alpha             = true
gear_r.isvisible                  = true
gear_r.h_clip_relation            = h_clip_relations.COMPARE
gear_r.level                      = DEFAULT_NOCLIP_LEVEL
gear_r.parent_element             = gear_clip.name
Add(gear_r)

gear_l                            = CreateElement"ceStringPoly"
gear_l.material                   = "hud_font_base"
gear_l.init_pos                   = {-0.3,0,0}
gear_l.alignment                  = "CenterCenter"
gear_l.stringdefs                 = FONT_SIZE
gear_l.formats                    = {"%s"}
gear_l.element_params             =
                                {
                                    "GEAR_L",
                                    "HUD_PWR",
                                }
gear_l.controllers                = 
                                {
                                    {"text_using_parameter",0},
                                    {"opacity_using_parameter",1,1}
                                }
gear_l.collimated                 = true
gear_l.use_mipfilter              = true
gear_l.additive_alpha             = true
gear_l.isvisible                  = true
gear_l.h_clip_relation            = h_clip_relations.COMPARE
gear_l.level                      = DEFAULT_NOCLIP_LEVEL
gear_l.parent_element             = gear_clip.name
Add(gear_l)

--------------------------------------------------
--------------------------------------------------
--------------------- SPEED ----------------------
--------------------------------------------------
--------------------------------------------------

speed                            = CreateElement"ceStringPoly"
speed.material                   = "hud_font_base"
speed.init_pos                   = {0.28,0,0}
speed.alignment                  = "RightCenter"
speed.stringdefs                 = FONT_SIZE
speed.formats                    = {"%.0f"}
speed.element_params             =
                                {
                                    "SPEED",
                                    "HUD_PWR",
                                }
speed.controllers                = 
                                {
                                    {"text_using_parameter",0},
                                    {"opacity_using_parameter",1,1}
                                }
speed.collimated                 = true
speed.use_mipfilter              = true
speed.additive_alpha             = true
speed.isvisible                  = true
speed.h_clip_relation            = h_clip_relations.COMPARE
speed.level                      = DEFAULT_NOCLIP_LEVEL
speed.parent_element             = speed_clip.name
Add(speed)

mach                            = CreateElement"ceStringPoly"
mach.material                   = "hud_font_base"
mach.init_pos                   = {0.28,0.15,0}
mach.alignment                  = "CenterCenter"
mach.stringdefs                 = {0.013,0.013,0,0}
mach.formats                    = {"M"}
mach.element_params             =
                                {
                                    "",
                                    "HUD_PWR",
                                }
mach.controllers                = 
                                {
                                    {"text_using_parameter",0},
                                    {"opacity_using_parameter",1,1}
                                }
mach.collimated                 = true
mach.use_mipfilter              = true
mach.additive_alpha             = true
mach.isvisible                  = true
mach.h_clip_relation            = h_clip_relations.COMPARE
mach.level                      = DEFAULT_NOCLIP_LEVEL
mach.parent_element             = mach_clip.name
Add(mach)

mach                            = CreateElement"ceStringPoly"
mach.material                   = "hud_font_base"
mach.init_pos                   = {0.28,0,0}
mach.alignment                  = "CenterCenter"
mach.stringdefs                 = {0.013,0.013,0,0}
mach.formats                    = {"%.1f"}
mach.element_params             =
                                {
                                    "MACH",
                                    "HUD_PWR",
                                }
mach.controllers                = 
                                {
                                    {"text_using_parameter",0},
                                    {"opacity_using_parameter",1,1}
                                }
mach.collimated                 = true
mach.use_mipfilter              = true
mach.additive_alpha             = true
mach.isvisible                  = true
mach.h_clip_relation            = h_clip_relations.COMPARE
mach.level                      = DEFAULT_NOCLIP_LEVEL
mach.parent_element             = mach_clip.name
Add(mach)

accel                            = CreateElement"ceStringPoly"
accel.material                   = "hud_font_base"
accel.init_pos                   = {0.28,0,0}
accel.alignment                  = "RightCenter"
accel.stringdefs                 = {0.013,0.013,0,0}
accel.formats                    = {"%.1f >"}
accel.element_params             =
                                {
                                    "ACCEL",
                                    "HUD_PWR",
                                }
accel.controllers                = 
                                {
                                    {"text_using_parameter",0},
                                    {"opacity_using_parameter",1,1}
                                }
accel.collimated                 = true
accel.use_mipfilter              = true
accel.additive_alpha             = true
accel.isvisible                  = true
accel.h_clip_relation            = h_clip_relations.COMPARE
accel.level                      = DEFAULT_NOCLIP_LEVEL
accel.parent_element             = g_clip.name
Add(accel)

--------------------------------------------------
--------------------------------------------------
--------------------- LADDER ---------------------
--------------------------------------------------
--------------------------------------------------
horiz_line                          = CreateElement"ceTexPoly"
horiz_line.vertices                 = vert_gen(2200,64)
horiz_line.indices                  = INDICES
horiz_line.tex_coords               = tex_coord_gen(0,0,1024,32,1024,32)
horiz_line.material                 = HORIZ_LINE
horiz_line.name                     = create_guid_string()
horiz_line.init_pos                 = {0,0,0}
horiz_line.init_rot                 = {0,0,0}
horiz_line.collimated               = true
horiz_line.element_params           =
                                    {
                                        "HUD_PWR"
                                    }
horiz_line.controllers              =
                                    {
                                        {"opacity_using_parameter",0,1}
                                    }
horiz_line.use_mipfilter            = true
horiz_line.additive_alpha           = true
horiz_line.h_clip_relation          = h_clip_relations.COMPARE
horiz_line.level                    = DEFAULT_NOCLIP_LEVEL
horiz_line.parent_element           = hud_pitch.name
Add(horiz_line)

local i
local sign_number
local vertical_distance

for i = 1,18 do
    sign_number = i * 5
    vertical_distance = i * 1.8

    lines                           = CreateElement"ceTexPoly"
    lines.vertices                  = vert_gen(750,80)
    lines.indices                   = INDICES
    lines.tex_coords                = tex_coord_gen(0,0,82,17,82,17)
    lines.material                  = LINE_POS
    lines.name                      = create_guid_string()
    lines.init_pos                  = {0,vertical_distance,0}
    lines.init_rot                  = {0,0,0}
    lines.collimated                = true
    lines.element_params            =
                                    {
                                        "HUD_PWR"
                                    }
    lines.controllers               =
                                    {
                                        {"opacity_using_parameter",0,1}
                                    }
    lines.use_mipfilter             = true
    lines.additive_alpha            = true
    lines.h_clip_relation           = h_clip_relations.COMPARE
    lines.level                     = DEFAULT_NOCLIP_LEVEL
    lines.parent_element            = hud_pitch.name
    Add(lines)

    numbers                         = CreateElement"ceStringPoly"
    numbers.material                = "hud_font_base"
    numbers.init_pos                = {-0.65,vertical_distance - 0.09}
    numbers.alignment               = "LeftCenter"
    numbers.stringdefs              = {0.018,0.018,0,0}
    numbers.formats                 = {tostring(sign_number),"%s"}
    numbers.element_params          =
                                    {
                                        "NUMBERS",
                                        "HUD_PWR"
                                    }
    numbers.controllers             =
                                    {
                                        {"text_using_parameter",0},
                                        {"opacity_using_parameter",1,1}
                                    }
    numbers.collimated              = true
    numbers.use_mipfilter           = true
    numbers.additive_alpha          = true
    numbers.isvisible               = true
    numbers.h_clip_relation         = h_clip_relations.COMPARE
    numbers.level                   = DEFAULT_NOCLIP_LEVEL
    numbers.parent_element          = hud_pitch.name
    Add(numbers)
end

for i = 1,18 do
    sign_number = - i * 5
    vertical_distance = - i * 1.8

    lines                           = CreateElement"ceTexPoly"
    lines.vertices                  = vert_gen(800,80)
    lines.indices                   = INDICES
    lines.tex_coords                = tex_coord_gen(0,0,82,17,82,17)
    lines.material                  = LINE_NEG
    lines.name                      = create_guid_string()
    lines.init_pos                  = {0,vertical_distance,0}
    lines.init_rot                  = {0,0,0}
    lines.collimated                = true
    lines.element_params            =
                                    {
                                        "HUD_PWR"
                                    }
    lines.controllers               =
                                    {
                                        {"opacity_using_parameter",0,1}
                                    }
    lines.use_mipfilter             = true
    lines.additive_alpha            = true
    lines.h_clip_relation           = h_clip_relations.COMPARE
    lines.level                     = DEFAULT_NOCLIP_LEVEL
    lines.parent_element            = hud_pitch.name
    Add(lines)

    numbers                         = CreateElement"ceStringPoly"
    numbers.material                = "hud_font_base"
    numbers.init_pos                = {-0.7,vertical_distance + 0.09}
    numbers.alignment               = "LeftCenter"
    numbers.stringdefs              = {0.018,0.018,0,0}
    numbers.formats                 = {tostring(sign_number),"%s"}
    numbers.element_params          =
                                    {
                                        "NUMBERS",
                                        "HUD_PWR"
                                    }
    numbers.controllers             =
                                    {
                                        {"text_using_parameter",0},
                                        {"opacity_using_parameter",1,1}
                                    }
    numbers.collimated              = true
    numbers.use_mipfilter           = true
    numbers.additive_alpha          = true
    numbers.isvisible               = true
    numbers.h_clip_relation         = h_clip_relations.COMPARE
    numbers.level                   = DEFAULT_NOCLIP_LEVEL
    numbers.parent_element          = hud_pitch.name
    Add(numbers)

end


--------------------------------------------------
--------------------------------------------------
--------------------- HEADING --------------------
--------------------------------------------------
--------------------------------------------------
hdg_track                               = CreateElement"ceTexPoly"
hdg_track.vertices                      = vert_gen(50,50)
hdg_track.indices                       = INDICES
hdg_track.tex_coords                    = tex_coord_gen(0,0,21,19,21,19)
hdg_track.material                      = TRACK_POINTER
hdg_track.name                          = create_guid_string()
hdg_track.init_pos                      = {0,-2.2,7}
hdg_track.init_rot                      = {0,0,0}
hdg_track.collimated                    = true
hdg_track.element_params                =
                                        {
                                            "HUD_PWR"
                                        }
hdg_track.controllers                   =
                                        {
                                            {"opacity_using_parameter",0,1}
                                        }
hdg_track.use_mipfilter                 = true
hdg_track.additive_alpha                = true
hdg_track.h_clip_relation               = h_clip_relations.COMPARE
hdg_track.level                         = DEFAULT_NOCLIP_LEVEL
hdg_track.parent_element                = base_clip.name
Add(hdg_track)

local default_heading_bar_length = 4000

for count_i = 1,36 do
    bar_control                         = CreateElement"ceSimple"
    bar_control.name                    = "bar_control"
    bar_control.init_pos                = {0,0,0}
    bar_control.element_params          =
                                        {
                                            "HDG_MOV"
                                        }
    bar_control.controllers             =
                                        {
                                            {"move_left_right_using_parameter",0,-0.06} -- -math.rad(360.0) / 100}
                                        }
    bar_control.collimated              = true
    bar_control.use_mipfilter           = true
    bar_control.additive_alpha          = true
    bar_control.h_clip_relation         = h_clip_relations.COMPARE
    bar_control.level                   = DEFAULT_NOCLIP_LEVEL + 1
    bar_control.parent_element          = tape_clip.name
    bar_control.isvisible               = true
    Add(bar_control)
end

for i = -36,36 do
    sign_number = i * 01
    horizontal_distance = i * 0.3

    lines                           = CreateElement"ceTexPoly"
    lines.vertices                  = vert_gen(10,40)
    lines.indices                   = INDICES
    lines.tex_coords                = tex_coord_gen(0,0,82,17,82,17)
    lines.material                  = MakeMaterial(nil,HUD_COLOR)
    lines.name                      = create_guid_string()
    lines.init_pos                  = {i * 0.6,0,0}
    lines.init_rot                  = {0,0,0}
    lines.collimated                = true
    lines.element_params            =
                                    {
                                        "HUD_PWR"
                                    }
    lines.controllers               =
                                    {
                                        {"opacity_using_parameter",0,1}
                                    }
    lines.use_mipfilter             = true
    lines.additive_alpha            = true
    lines.h_clip_relation           = h_clip_relations.COMPARE
    lines.level                     = DEFAULT_NOCLIP_LEVEL + 1
    lines.parent_element            = bar_control.name
    Add(lines)

    lines                           = CreateElement"ceTexPoly"
    lines.vertices                  = vert_gen(10,10)
    lines.indices                   = INDICES
    lines.tex_coords                = tex_coord_gen(0,0,82,17,82,17)
    lines.material                  = MakeMaterial(nil,HUD_COLOR)
    lines.name                      = create_guid_string()
    lines.init_pos                  = {(i * 0.6) + 0.3,0,0}
    lines.init_rot                  = {0,0,0}
    lines.collimated                = true
    lines.element_params            =
                                    {
                                        "HUD_PWR"
                                    }
    lines.controllers               =
                                    {
                                        {"opacity_using_parameter",0,1}
                                    }
    lines.use_mipfilter             = true
    lines.additive_alpha            = true
    lines.h_clip_relation           = h_clip_relations.COMPARE
    lines.level                     = DEFAULT_NOCLIP_LEVEL + 1
    lines.parent_element            = bar_control.name
    Add(lines)
end

local heading_temp

for count_i = -22,22 do
    if count_i < 0 then
        heading_temp = 36 + count_i
    elseif count_i >= 0 then
        heading_temp = count_i
    end

    numbers                         = CreateElement"ceStringPoly"
    numbers.material                = "hud_font_base"
    numbers.init_pos                = {count_i * 0.6,0.15,0}
    numbers.alignment               = "CenterCenter"
    numbers.stringdefs              = {0.017,0.017,0,0}
    numbers.formats                 = {tostring(heading_temp),"%s"}
    numbers.element_params          =
                                    {
                                        "NUMBERS",
                                        "HUD_PWR"
                                    }
    numbers.controllers             =
                                    {
                                        {"text_using_parameter",0},
                                        {"opacity_using_parameter",1,1}
                                    }
    numbers.collimated              = true
    numbers.use_mipfilter           = true
    numbers.additive_alpha          = true
    numbers.isvisible               = true
    numbers.h_clip_relation         = h_clip_relations.COMPARE
    numbers.level                   = DEFAULT_NOCLIP_LEVEL + 1
    numbers.parent_element          = bar_control.name
    Add(numbers)
end

--------------------------------------------------
--------------------------------------------------
------------------- BANK SCALE -------------------
--------------------------------------------------
--------------------------------------------------

bs_indicator                        = CreateElement"ceTexPoly"
bs_indicator.vertices               = vert_gen(768,192)
bs_indicator.indices                = INDICES
bs_indicator.tex_coords             = tex_coord_gen(0,0,256,64,256,64)
bs_indicator.material               = BANK_SCALE
bs_indicator.name                   = create_guid_string()
bs_indicator.init_pos               = {0,-5.5,7}
bs_indicator.init_rot               = {0,0,0}
bs_indicator.collimated             = true
bs_indicator.element_params         =
                                    {
                                        "HUD_PWR"
                                    }
bs_indicator.controllers            =
                                    {
                                        {"opacity_using_parameter",0,1}
                                    }
bs_indicator.use_mipfilter          = true
bs_indicator.additive_alpha         = true
bs_indicator.h_clip_relation        = h_clip_relations.COMPARE
bs_indicator.level                  = DEFAULT_NOCLIP_LEVEL
bs_indicator.parent_element         = base_clip.name
Add(bs_indicator)

bs_indicator                        = CreateElement"ceTexPoly"
bs_indicator.vertices               = vert_gen(1300,300)
bs_indicator.indices                = INDICES
bs_indicator.tex_coords             = tex_coord_gen(0,0,256,64,256,64)
bs_indicator.material               = BANK_SCALE_EXT
bs_indicator.name                   = create_guid_string()
bs_indicator.init_pos               = {0,-5,7}
bs_indicator.init_rot               = {0,0,0}
bs_indicator.collimated             = true
bs_indicator.element_params         =
                                    {
                                        "HUD_PWR",
                                        "BANK_SCALE"
                                    }
bs_indicator.controllers            =
                                    {
                                        {"opacity_using_parameter",0,1},
                                        {"opacity_using_parameter",1,1}
                                    }
bs_indicator.use_mipfilter          = true
bs_indicator.additive_alpha         = true
bs_indicator.h_clip_relation        = h_clip_relations.COMPARE
bs_indicator.level                  = DEFAULT_NOCLIP_LEVEL
bs_indicator.parent_element         = base_clip.name
Add(bs_indicator)

carrot                              = CreateElement"ceTexPoly"
carrot.vertices                     = vert_gen(128,128)
carrot.indices                      = INDICES
carrot.tex_coords                   = tex_coord_gen(0,0,256,64,256,64)
carrot.material                     = BANK_CARROT
carrot.name                         = create_guid_string()
carrot.init_pos                     = {0,-0.85,0}
carrot.init_rot                     = {0,0,180}
carrot.collimated                   = true
carrot.element_params               =
                                    {
                                        "HUD_PWR"
                                    }
carrot.controllers                  =
                                    {
                                        {"opacity_using_parameter",0,1}
                                    }
carrot.use_mipfilter                = true
carrot.additive_alpha               = true
carrot.h_clip_relation              = h_clip_relations.COMPARE
carrot.level                        = DEFAULT_NOCLIP_LEVEL
carrot.parent_element               = bank_clip.name
Add(carrot)

-- DEBUGGING
--[[ numbers                         = CreateElement"ceStringPoly"
numbers.material                = "hud_font_base"
numbers.init_pos                = {0,0.15,0}
numbers.alignment               = "CenterCenter"
numbers.stringdefs              = {0.017,0.017,0,0}
numbers.formats                 = {"%.1f"}
numbers.element_params          =
                                {
                                    "BANK",
                                    "HUD_PWR"
                                }
numbers.controllers             =
                                {
                                    {"text_using_parameter",0},
                                    {"opacity_using_parameter",1,1}
                                }
numbers.collimated              = true
numbers.use_mipfilter           = true
numbers.additive_alpha          = true
numbers.isvisible               = true
numbers.h_clip_relation         = h_clip_relations.COMPARE
numbers.level                   = DEFAULT_NOCLIP_LEVEL
numbers.parent_element          = bank_clip.name
Add(numbers) ]]

--------------------------------------------------
--------------------------------------------------
-------------------- WATERLINE -------------------
--------------------------------------------------
--------------------------------------------------

local WL_SIZE = vert_gen(500,500)

waterline                           = CreateElement"ceTexPoly"
waterline.vertices                  = WL_SIZE
waterline.indices                   = INDICES
waterline.tex_coords                = tex_coord_gen(0,0,512,512,512,512)
waterline.material                  = WL_NORM
waterline.name                      = create_guid_string()
waterline.init_pos                  = {0,-4,7}
waterline.init_rot                  = {0,0,0}
waterline.collimated                = true
waterline.element_params            =
                                    {
                                        "HUD_PWR",
                                        "WL_NORM",
                                        "HUD_X",
                                        "HUD_Y"
                                    }
waterline.controllers               =
                                    {
                                        {"opacity_using_parameter",0,1},
                                        {"opacity_using_parameter",1,1},
                                        {"move_left_right_using_parameter",2,fd_move_multi_yaw},
                                        {"move_up_down_using_parameter",3,fd_move_multi}
                                    }
waterline.use_mipfilter             = true
waterline.additive_alpha            = true
waterline.h_clip_relation           = h_clip_relations.COMPARE
waterline.level                     = DEFAULT_NOCLIP_LEVEL
waterline.parent_element            = base_clip.name
Add(waterline)

waterline                           = CreateElement"ceTexPoly"
waterline.vertices                  = WL_SIZE
waterline.indices                   = INDICES
waterline.tex_coords                = tex_coord_gen(0,0,512,512,512,512)
waterline.material                  = WL_GEAR
waterline.name                      = create_guid_string()
waterline.init_pos                  = {0,-4,7}
waterline.init_rot                  = {0,0,0}
waterline.collimated                = true
waterline.element_params            =
                                    {
                                        "HUD_PWR",
                                        "WL_GEAR",
                                        "HUD_X",
                                        "HUD_Y"
                                    }
waterline.controllers               =
                                    {
                                        {"opacity_using_parameter",0,1},
                                        {"opacity_using_parameter",1,1},
                                        {"move_left_right_using_parameter",2,fd_move_multi_yaw},
                                        {"move_up_down_using_parameter",3,fd_move_multi}
                                    }
waterline.use_mipfilter             = true
waterline.additive_alpha            = true
waterline.h_clip_relation           = h_clip_relations.COMPARE
waterline.level                     = DEFAULT_NOCLIP_LEVEL
waterline.parent_element            = base_clip.name
Add(waterline)

waterline                           = CreateElement"ceTexPoly"
waterline.vertices                  = WL_SIZE
waterline.indices                   = INDICES
waterline.tex_coords                = tex_coord_gen(0,0,512,512,512,512)
waterline.material                  = WL_BRAKE
waterline.name                      = create_guid_string()
waterline.init_pos                  = {0,-4,7}
waterline.init_rot                  = {0,0,0}
waterline.collimated                = true
waterline.element_params            =
                                    {
                                        "HUD_PWR",
                                        "WL_BRAKE",
                                        "HUD_X",
                                        "HUD_Y"
                                    }
waterline.controllers               =
                                    {
                                        {"opacity_using_parameter",0,1},
                                        {"opacity_using_parameter",1,1},
                                        {"move_left_right_using_parameter",2,fd_move_multi_yaw},
                                        {"move_up_down_using_parameter",3,fd_move_multi}
                                    }
waterline.use_mipfilter             = true
waterline.additive_alpha            = true
waterline.h_clip_relation           = h_clip_relations.COMPARE
waterline.level                     = DEFAULT_NOCLIP_LEVEL
waterline.parent_element            = base_clip.name
Add(waterline)

waterline                           = CreateElement"ceTexPoly"
waterline.vertices                  = WL_SIZE
waterline.indices                   = INDICES
waterline.tex_coords                = tex_coord_gen(0,0,512,512,512,512)
waterline.material                  = WL_GEAR_BRAKE
waterline.name                      = create_guid_string()
waterline.init_pos                  = {0,-4,7}
waterline.init_rot                  = {0,0,0}
waterline.collimated                = true
waterline.element_params            =
                                    {
                                        "HUD_PWR",
                                        "WL_GEAR_BRAKE",
                                        "HUD_X",
                                        "HUD_Y"
                                    }
waterline.controllers               =
                                    {
                                        {"opacity_using_parameter",0,1},
                                        {"opacity_using_parameter",1,1},
                                        {"move_left_right_using_parameter",2,fd_move_multi_yaw},
                                        {"move_up_down_using_parameter",3,fd_move_multi}
                                    }
waterline.use_mipfilter             = true
waterline.additive_alpha            = true
waterline.h_clip_relation           = h_clip_relations.COMPARE
waterline.level                     = DEFAULT_NOCLIP_LEVEL
waterline.parent_element            = base_clip.name
Add(waterline)