dofile(LockOn_Options.common_script_path.."elements_defs.lua")

IND_TEX_PATH = LockOn_Options.script_path.."../IndicationTextures/HUD/"

SetScale(FOV)

ASPECT_HEIGHT = GetAspect()

DEFAULT_LEVEL = 4
DEFAULT_NOCLIP_LEVEL = DEFAULT_LEVEL - 1

HUD_COLOR = {0,255,75,255}

FILTER_MAT = MakeMaterial(IND_TEX_PATH.."HUD_FILTER.tga", {255,255,255,75})
MASK = MakeMaterial(IND_TEX_PATH.."HUD_MASK.tga", {0,0,0,255})
LINE_POS = MakeMaterial(IND_TEX_PATH.."HUD_PL_POS.tga",HUD_COLOR)
LINE_NEG = MakeMaterial(IND_TEX_PATH.."HUD_PL_NEG.tga",HUD_COLOR)
CIRCLE_MAT = MakeMaterial(IND_TEX_PATH.."HUD_ALT_CIRCLE.tga", HUD_COLOR)
WL_NORM = MakeMaterial(IND_TEX_PATH.."HUD_WL.tga",HUD_COLOR)
WL_GEAR = MakeMaterial(IND_TEX_PATH.."HUD_WL_GEAR.tga",HUD_COLOR)
WL_BRAKE = MakeMaterial(IND_TEX_PATH.."HUD_WL_BRAKE.tga",HUD_COLOR)
WL_GEAR_BRAKE = MakeMaterial(IND_TEX_PATH.."HUD_WL_GEAR_BRAKE.tga",HUD_COLOR)
HUD_MATERIAL = MakeMaterial(IND_TEX_PATH.."HUD_IND_TEX.dds",HUD_COLOR)
TRACK_POINTER = MakeMaterial(IND_TEX_PATH.."HUD_TRACK_POINTER.tga",HUD_COLOR)
HORIZ_LINE = MakeMaterial(IND_TEX_PATH.."HUD_HORIZ_LINE.tga",HUD_COLOR)
BANK_SCALE = MakeMaterial(IND_TEX_PATH.."HUD_BANK_SCALE.tga",HUD_COLOR)
BANK_SCALE_EXT = MakeMaterial(IND_TEX_PATH.."HUD_BANK_SCALE_EXTENDED.tga",HUD_COLOR)
BANK_CARROT = MakeMaterial(IND_TEX_PATH.."HUD_BANK_CARROT.tga",HUD_COLOR)
VERT_VELOCITY = MakeMaterial(IND_TEX_PATH.."HUD_VVI.tage",HUD_COLOR)
PULL_UP = MakeMaterial(IND_TEX_PATH.."HUD_PULL_UP.tga",HUD_COLOR)

default_x = 512
default_y = 512

function vert_gen(width, height)
    return {{(0 - width) / 2 / default_x , (0 + height) / 2 / default_y},
    {(0 + width) / 2 / default_x , (0 + height) / 2 / default_y},
    {(0 + width) / 2 / default_x , (0 - height) / 2 / default_y},
    {(0 - width) / 2 / default_x , (0 - height) / 2 / default_y},}
end

function duo_vert_gen(width, total_height, not_include_height)
    return {
        {(0 - width) / 2 / default_x , (0 + total_height) / 2 / default_y},
        {(0 + width) / 2 / default_x , (0 + total_height) / 2 / default_y},
        {(0 + width) / 2 / default_x , (0 + not_include_height) / 2 / default_y},
        {(0 - width) / 2 / default_x , (0 + not_include_height) / 2 / default_y},
        {(0 + width) / 2 / default_x , (0 - not_include_height) / 2 / default_y},
        {(0 - width) / 2 / default_x , (0 - not_include_height) / 2 / default_y},
        {(0 + width) / 2 / default_x , (0 - total_height) / 2 / default_y},
        {(0 - width) / 2 / default_x , (0 - total_height) / 2 / default_y},
    }
end

function tex_coord_gen(x_dis,y_dis,width,height,size_X,size_Y)
    return {{x_dis / size_X , y_dis / size_Y},
			{(x_dis + width) / size_X , y_dis / size_Y},
			{(x_dis + width) / size_X , (y_dis + height) / size_Y},
			{x_dis / size_X , (y_dis + height) / size_Y},}
end

function mirror_tex_coord_gen(x_dis,y_dis,width,height,size_X,size_Y)
    return {{(x_dis + width) / size_X , y_dis / size_Y},
			{x_dis / size_X , y_dis / size_Y},
			{x_dis / size_X , (y_dis + height) / size_Y},
			{(x_dis + width) / size_X , (y_dis + height) / size_Y},}
end

function calculateCircle(object, radius, init_x, init_y, point_num)
	local verts = {}
    multiplier = math.rad(360.0/point_num)
    verts[1] = {init_x / default_x, init_y / default_y}
	for i = 2, point_num do
	  verts[i] = {(init_x + radius * math.cos(i * multiplier)) / default_x, (init_y + radius * math.sin(i * multiplier)) / default_y}
    end
    
    local indices = {}
	for i = 0, point_num - 3 do
	  indices[i * 3 + 1] = 0
	  indices[i * 3 + 2] = i + 1
	  indices[i * 3 + 3] = i + 2
    end
    indices[(point_num - 2) * 3 + 1] = 0
    indices[(point_num - 2) * 3 + 2] = 1
    indices[(point_num - 2) * 3 + 3] = point_num - 1
	object.vertices = verts
	object.indices  = indices
end
