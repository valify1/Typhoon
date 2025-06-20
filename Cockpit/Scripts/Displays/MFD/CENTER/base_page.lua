dofile(LockOn_Options.script_path.."Displays/MFD/Device/definitions.lua")

SHOW_MASKS = true

local INDICES = {0,1,2,0,2,3}

local half_width = GetScale()
local half_height = GetAspect() * half_width

local aspect = GetAspect()

center_base_clip                           = CreateElement"ceMeshPoly"
center_base_clip.name                      = "center_base_clip"
center_base_clip.primitivetype             = "triangles"
center_base_clip.vertices                  = vert_gen(750,750)
center_base_clip.indices                   = INDICES
center_base_clip.init_pos                  = {-0.01,0,-0.008}
center_base_clip.init_rot                  = {0,0,7.269}
center_base_clip.material                  = MakeMaterial(nil,{2,2,4,255})
center_base_clip.element_params            =
                                    {
                                        "CMFD_PWR"
                                    }
center_base_clip.controllers               =
                                    {
                                        {"opacity_using_parameter",0,1}
                                    }
center_base_clip.h_clip_relation           = h_clip_relations.REWRITE_LEVEL
center_base_clip.level                     = DEFAULT_NOCLIP_LEVEL +1
center_base_clip.isdraw                    = true
center_base_clip.change_opacity            = true
center_base_clip.isvisible                 = SHOW_MASKS
Add(center_base_clip)

---------------------------------------------------
---------------------------------------------------
-------------------- MAP PAGE ---------------------
---------------------------------------------------
---------------------------------------------------

map                             = CreateElement"ceTexPoly"
map.name                        = create_guid_string()
map.vertices                    = vert_gen(2048,2048)
map.tex_coords                  = tex_coord_gen(0,0,4096,4096,4096,4096)
map.indices                     = INDICES
map.init_pos                    = {0,-0.25,0}
map.init_rot                    = {0,0,0}
map.material                    = MakeMaterial(LockOn_Options.script_path.."../IndicationTextures/MFD/MFD_MAP_TEMP.tga",{255,255,255,100})
map.element_params              =
                                    {
                                        "CMFD_PWR",
                                        "HDG"
                                    }
map.controllers                 =
                                    {
                                        {"opacity_using_parameter",0,1},
                                        {"rotate_using_parameter",1,-math.rad(360)/360}
                                    }
map.h_clip_relation             = h_clip_relations.COMPARE
map.level                       = DEFAULT_NOCLIP_LEVEL +1
map.collimated                  = true
map.use_mipfilter               = true
map.additive_alpha              = true
map.parent_element              = center_base_clip.name
Add(map)

page_bg                             = CreateElement"ceTexPoly"
page_bg.name                        = create_guid_string()
page_bg.vertices                    = vert_gen(900,900)
page_bg.tex_coords                  = tex_coord_gen(0,0,512,512,512,512)
page_bg.indices                     = INDICES
page_bg.init_pos                    = {0,0,0}
page_bg.init_rot                    = {0,0,0}
page_bg.material                    = MakeMaterial(LockOn_Options.script_path.."../IndicationTextures/MFD/MFD_GRID.tga",{0,0,255,255})
page_bg.element_params              =
                                    {
                                        "CMFD_PWR"
                                    }
page_bg.controllers                 =
                                    {
                                        {"opacity_using_parameter",0,1}
                                    }
page_bg.h_clip_relation             = h_clip_relations.COMPARE
page_bg.level                       = DEFAULT_NOCLIP_LEVEL +1
page_bg.collimated                  = true
page_bg.use_mipfilter               = true
page_bg.additive_alpha              = true
page_bg.parent_element              = center_base_clip.name
Add(page_bg)

pa_plane                             = CreateElement"ceTexPoly"
pa_plane.name                        = create_guid_string()
pa_plane.vertices                    = vert_gen(1024,256)
pa_plane.tex_coords                  = tex_coord_gen(0,0,512,128,512,128)
pa_plane.indices                     = INDICES
pa_plane.init_pos                    = {0,-0.1,0}
pa_plane.init_rot                    = {0,0,0}
pa_plane.material                    = MakeMaterial(LockOn_Options.script_path.."../IndicationTextures/MFD/MFD_PA_PLANE.tga",{255,255,255,255})
pa_plane.element_params              =
                                    {
                                        "CMFD_PWR"
                                    }
pa_plane.controllers                 =
                                    {
                                        {"opacity_using_parameter",0,1}
                                    }
pa_plane.h_clip_relation             = h_clip_relations.COMPARE
pa_plane.level                       = DEFAULT_NOCLIP_LEVEL +1
pa_plane.collimated                  = true
pa_plane.use_mipfilter               = true
pa_plane.additive_alpha              = true
pa_plane.parent_element              = center_base_clip.name
Add(pa_plane)

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
                                        "CMFD_PWR"
                                    }
filter.controllers                  =
                                    {
                                        {"opacity_using_parameter",0,1}
                                    }
filter.h_clip_relation              = h_clip_relations.COMPARE
filter.level                        = DEFAULT_NOCLIP_LEVEL +1
filter.collimated                   = true
filter.use_mipfilter                = true
filter.additive_alpha               = true
filter.parent_element               = center_base_clip.name
Add(filter)