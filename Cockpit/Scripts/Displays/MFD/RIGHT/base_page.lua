dofile(LockOn_Options.script_path.."Displays/MFD/Device/definitions.lua")

SHOW_MASKS = true

local INDICES = {0,1,2,0,2,3}

local half_width = GetScale()
local half_height = GetAspect() * half_width

local aspect = GetAspect()

right_base_clip                           = CreateElement"ceMeshPoly"
right_base_clip.name                      = "right_base_clip"
right_base_clip.primitivetype             = "triangles"
right_base_clip.vertices                  = vert_gen(750,750)
right_base_clip.indices                   = INDICES
right_base_clip.init_pos                  = {0,0,-0.008}
right_base_clip.init_rot                  = {0,0,4.8}
right_base_clip.material                  = MakeMaterial(nil,{2,2,4,255})
right_base_clip.element_params            =
                                        {
                                            "RMFD_PWR"
                                        }
right_base_clip.controllers               =
                                        {
                                            {"opacity_using_parameter",0,1}
                                        }
right_base_clip.h_clip_relation           = h_clip_relations.REWRITE_LEVEL
right_base_clip.level                     = DEFAULT_NOCLIP_LEVEL -1
right_base_clip.isdraw                    = true
right_base_clip.change_opacity            = true
right_base_clip.isvisible                 = SHOW_MASKS
Add(right_base_clip)

---------------------------------------------------
---------------------------------------------------
-------------------- ENG PAGE ---------------------
---------------------------------------------------
---------------------------------------------------

page_bg                             = CreateElement"ceTexPoly"
page_bg.name                        = create_guid_string()
page_bg.vertices                    = vert_gen(1024,1024)
page_bg.tex_coords                  = tex_coord_gen(0,0,512,512,512,512)
page_bg.indices                     = INDICES
page_bg.init_pos                    = {0,0,0}
page_bg.init_rot                    = {0,0,0}
page_bg.material                    = MakeMaterial(LockOn_Options.script_path.."../IndicationTextures/MFD/MFD_ENG_PAGE.tga",{255,255,255,255})
page_bg.element_params              =
                                    {
                                        "RMFD_PWR"
                                    }
page_bg.controllers                 =
                                    {
                                        {"opacity_using_parameter",0,1}
                                    }
page_bg.h_clip_relation             = h_clip_relations.COMPARE
page_bg.level                       = DEFAULT_NOCLIP_LEVEL -1
page_bg.collimated                  = true
page_bg.use_mipfilter               = true
page_bg.additive_alpha              = true
page_bg.parent_element              = right_base_clip.name
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
                                        "RMFD_PWR"
                                    }
filter.controllers                  =
                                    {
                                        {"opacity_using_parameter",0,1}
                                    }
filter.h_clip_relation              = h_clip_relations.COMPARE
filter.level                        = DEFAULT_NOCLIP_LEVEL -1
filter.collimated                   = true
filter.use_mipfilter                = true
filter.additive_alpha               = true
filter.parent_element               = right_base_clip.name
Add(filter)