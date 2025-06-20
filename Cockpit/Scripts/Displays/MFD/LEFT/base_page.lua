dofile(LockOn_Options.script_path.."Displays/MFD/Device/definitions.lua")

SHOW_MASKS = true

local INDICES = {0,1,2,0,2,3}

local half_width = GetScale()
local half_height = GetAspect() * half_width

local aspect = GetAspect()

left_base_clip                           = CreateElement"ceMeshPoly"
left_base_clip.name                      = "left_base_clip"
left_base_clip.primitivetype             = "triangles"
left_base_clip.vertices                  = vert_gen(750,750)
left_base_clip.indices                   = INDICES
left_base_clip.init_pos                  = {0,0,-0.008}
left_base_clip.init_rot                  = {0,0,4.8}
left_base_clip.material                  = MakeMaterial(nil,{2,2,4,255})
left_base_clip.element_params            =
                                    {
                                        "LMFD_PWR"
                                    }
left_base_clip.controllers               =
                                    {
                                        {"opacity_using_parameter",0,1}
                                    }
left_base_clip.h_clip_relation           = h_clip_relations.REWRITE_LEVEL
left_base_clip.level                     = DEFAULT_NOCLIP_LEVEL
left_base_clip.isdraw                    = true
left_base_clip.change_opacity            = true
left_base_clip.isvisible                 = SHOW_MASKS
Add(left_base_clip)

hud_roll                            = CreateElement "ceSimple"
hud_roll.name                       = "hud_roll"
hud_roll.init_pos                   = {0,0,0}
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
hud_roll.parent_element             = left_base_clip.name
Add(hud_roll)

hud_pitch                           = CreateElement "ceSimple"
hud_pitch.name                      = "hud_pitch"
hud_pitch.init_pos                  = {0.01,0,0}
hud_pitch.element_params            =
                                    {
                                        "PITCH"
                                    }
hud_pitch.controllers               =
                                    {
                                        {"move_up_down_using_parameter",0,0.15}
                                    }
hud_pitch.collimated                = true
hud_pitch.use_mipfilter             = true
hud_pitch.additive_alpha            = true
hud_pitch.h_clip_relation           = h_clip_relations.COMPARE
hud_pitch.level                     = DEFAULT_NOCLIP_LEVEL
hud_pitch.parent_element            = hud_roll.name
Add(hud_pitch)

---------------------------------------------------
---------------------------------------------------
-------------------- HUD PAGE ---------------------
---------------------------------------------------
---------------------------------------------------

pitch_ladder                        = CreateElement"ceTexPoly"
pitch_ladder.name                   = create_guid_string()
pitch_ladder.vertices               = vert_gen(1000,5000)
pitch_ladder.tex_coords             = tex_coord_gen(0,0,800,2000,800,2000)
pitch_ladder.indices                = INDICES
pitch_ladder.init_pos               = {0,0,0}
pitch_ladder.init_rot               = {0,0,0}
pitch_ladder.material               = MakeMaterial(LockOn_Options.script_path.."../IndicationTextures/MFD/HUD_Horizon.bmp",{255,255,255,255})
pitch_ladder.element_params         =
                                    {
                                        "LMFD_PWR"
                                    }
pitch_ladder.controllers            =
                                    {
                                        {"opacity_using_parameter",0,1}
                                    }
pitch_ladder.h_clip_relation        = h_clip_relations.COMPARE
pitch_ladder.level                  = DEFAULT_NOCLIP_LEVEL
pitch_ladder.collimated             = true
pitch_ladder.use_mipfilter          = true
pitch_ladder.additive_alpha         = true
pitch_ladder.parent_element         = hud_pitch.name
Add(pitch_ladder)

mask                                = CreateElement"ceTexPoly"
mask.name                           = create_guid_string()
mask.vertices                       = vert_gen(1024,1024)
mask.tex_coords                     = tex_coord_gen(0,0,4096,4096,4096,4096)
mask.indices                        = INDICES
mask.init_pos                       = {0,0,-0.008}
mask.init_rot                       = {0,0,0}
mask.material                       = MakeMaterial(LockOn_Options.script_path.."../IndicationTextures/MFD/HUD_MASK.tga",{2,2,4,255})
mask.element_params                 =
                                    {
                                        "LMFD_PWR"
                                    }
mask.controllers                    =
                                    {
                                        {"opacity_using_parameter",0,1}
                                    }
mask.h_clip_relation                = h_clip_relations.COMPARE
mask.level                          = DEFAULT_NOCLIP_LEVEL
mask.collimated                     = true
mask.use_mipfilter                  = true
mask.additive_alpha                 = false
mask.parent_element                 = left_base_clip.name
Add(mask)

page_bg                             = CreateElement"ceTexPoly"
page_bg.name                        = create_guid_string()
page_bg.vertices                    = vert_gen(1024,1024)
page_bg.tex_coords                  = tex_coord_gen(0,0,512,512,512,512)
page_bg.indices                     = INDICES
page_bg.init_pos                    = {0,0,0}
page_bg.init_rot                    = {0,0,0}
page_bg.material                    = MakeMaterial(LockOn_Options.script_path.."../IndicationTextures/MFD/HUD_PAGE.tga",{255,255,255,255})
page_bg.element_params              =
                                    {
                                        "LMFD_PWR"
                                    }
page_bg.controllers                 =
                                    {
                                        {"opacity_using_parameter",0,1}
                                    }
page_bg.h_clip_relation             = h_clip_relations.COMPARE
page_bg.level                       = DEFAULT_NOCLIP_LEVEL
page_bg.collimated                  = true
page_bg.use_mipfilter               = true
page_bg.additive_alpha              = true
page_bg.parent_element              = left_base_clip.name
Add(page_bg)

filter                              = CreateElement"ceTexPoly"
filter.name                         = create_guid_string()
filter.vertices                     = vert_gen(4096,4096)
filter.tex_coords                   = tex_coord_gen(0,0,4096,4096,4096,4096)
filter.indices                      = INDICES
filter.init_pos                     = {0,0,-0.008}
filter.init_rot                     = {0,0,0}
filter.material                     = FILTER_MAT
filter.element_params               =
                                    {
                                        "LMFD_PWR"
                                    }
filter.controllers                  =
                                    {
                                        {"opacity_using_parameter",0,1}
                                    }
filter.h_clip_relation              = h_clip_relations.COMPARE
filter.level                        = DEFAULT_NOCLIP_LEVEL
filter.collimated                   = true
filter.use_mipfilter                = true
filter.additive_alpha               = true
filter.parent_element               = left_base_clip.name
Add(filter)