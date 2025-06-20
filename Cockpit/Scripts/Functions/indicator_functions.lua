-- ****************************************************
-- ****************************************************
-- F-16 SFM LUA scripts for FSTB by Beaker
-- ****************************************************
-- ****************************************************

function AddGrid(dx,dy,rows,cols)
	local rows          = rows or 1
	local cols          = cols or 1
	
	local sz_x          = cols * dx
	local sz_y          = rows * dy
	
	local verts       = {{0,0},
						 {sz_x,0},
						 {sz_x,sz_y},
						 {0,sz_y}}
	local indices     = {0,1,2,2,3,0}
	
	for j = 1,cols do
		verts[#verts + 1] =  {dx*j ,   0}	indices[#indices + 1] = #verts - 1	
		verts[#verts + 1] =  {dx*j ,sz_y}	indices[#indices + 1] = #verts - 1
	end
	
	for i = 1,rows do
		verts[#verts + 1] =  {0   ,dy*i}	indices[#indices + 1] = #verts - 1	
		verts[#verts + 1] =  {sz_x,dy*i}	indices[#indices + 1] = #verts - 1
	end

	grid			    = CreateElement "ceMeshPoly"
	grid.name 		    = create_guid_string()
	grid.material	    = MARK_MATERIAL
	grid.primitivetype  = "lines"	
	grid.vertices       = verts
	grid.indices	    = indices
	grid.collimated		= true
	grid.init_pos		= {-0.5 * sz_x , -0.5 * sz_y}
	Add(grid)
	return grid
end
-- AddGrid(500/20,500/20,20,20)
-- AddGrid(500/20,500/20,20,20)
-- AddGrid(500/40,500/40,40,40)

function addBorder(Name, UL, LR, Width, Parent, Pos, Controllers, params)
	local Border = {}
	for i = 1, 4 do
		Border[i]                  = CreateElement "ceMeshPoly"
		Border[i].name             = Name .. "_" .. i
		Border[i].primitivetype    = "triangles"
		if i == 1 then
			Border[i].vertices         = {{UL[1],UL[2]},{LR[1],UL[2]},{LR[1],UL[2]+Width},{UL[1],UL[2]+Width}} 
		elseif i == 2 then
			Border[i].vertices         = {{LR[1]-Width,UL[2]},{LR[1],UL[2]},{LR[1],LR[2]},{LR[1]-Width,LR[2]}} 
		elseif i == 3 then
			Border[i].vertices         = {{UL[1],LR[2]-Width},{LR[1],LR[2]-Width},{LR[1],LR[2]},{UL[1],LR[2]}} 
		elseif i == 4 then
			Border[i].vertices         = {{UL[1],UL[2]},{UL[1]+Width,UL[2]},{UL[1]+Width,LR[2]},{UL[1],LR[2]}} 
		end
		--verts {{-x,-y},{-x,y},{x,y},{x,-y}} -- LL,UL,UR,LR
		Border[i].indices          = {0,1,2,2,3,0}
		Border[i].material         = BASE_MATERIAL
		Border[i].h_clip_relation  = h_clip_relations.COMPARE
		Border[i].level            = HUD_DEFAULT_LEVEL
		Border[i].additive_alpha	= true
		Border[i].collimated		= true
		Border[i].controllers = {{"opacity_using_parameter",0,1,0}}
		Border[i].element_params = {"HUD_BRT"}
		if i == 1 then
			Border[i].parent_element = Parent
			Border[i].init_pos       = Pos
			if Controllers ~= nil then
				Border[i].controllers    = Controllers
			end
			if params ~= nil then
				Border[i].element_params = params
			end
		else
			Border[i].parent_element = Border[1].name
			Border[i].isdraw		 = true
		end
		
		Border[i].isvisible        = true
	    Add(Border[i])
	end

	
	return Border[4]
end

function AddTexElement(name, vertices, params, controllers, init_pos, init_rot, parent, level, texcoords, material)
local 	element				= CreateElement "ceTexPoly"
	element.indices			= {0,1,2,2,3,0}
	element.material		= material
	element.tex_coords = texcoords --{{0.49,0.927},{0.51,0.927},{0.51,0.947},{0.49,0.947}}
	element.name			= name
	element.vertices		= vertices
	if params ~= nil then
		element.element_params = params
	end
	--element.tex_params 		= tex_params 
	
	if controllers ~= nil then
		-- local strippedcontrollers = string.sub(controllers,2,string.len(controllers)-1)
		-- controllers[2] = controllers[2] or {"opacity_using_parameter",0,1,0}
		element.controllers	= controllers
	end
	
	element.init_pos		= init_pos
	element.init_rot		= init_rot

	element.isdraw			= false	
	if parent ~= nil then
		element.parent_element	= parent
		element.isdraw			= true
	end
	
	element.h_clip_relation	= h_clip_relations.COMPARE
	
	if level ~= nil then
		element.level	= level
	else
		element.level	= HUD_DEFAULT_LEVEL
	end
	
	element.additive_alpha	= true
	element.collimated		= true

	
	element.use_mipfilter	= true
		
	Add(element)

	return element

end

function AddTexElement_Mask(name, vertices, params, controllers, init_pos, init_rot, parent, level, texcoords, material)
	local masked = AddTexElement(name, vertices, params, controllers, init_pos, init_rot, parent, level, texcoords, material)
	masked.level = HUD_DEFAULT_LEVEL
	masked.h_clip_relation = 4
	--masked.isvisible = false
	return masked
end

function AddTextElement(name, material, init_pos, align, size, controllers, formats, parent, level)
local txt			= CreateElement "ceStringPoly"
	txt.name		= name
	txt.material	= material
	txt.init_pos	= init_pos
	txt.alignment	= align
	txt.stringdefs	= size
	txt.parent_element   = "huddummy"
	
	txt.additive_alpha	= true
	txt.collimated		= true
	
	txt.isdraw			= true
	if controllers ~= nil then
		txt.controllers		= controllers
	end
	
	if controllers ~= nil then
		txt.formats		= formats
	end
	
	if parent ~= nil then
		txt.parent_element	= parent
		txt.isdraw		= true
	end
	
	txt.h_clip_relation	= h_clip_relations.COMPARE
	if level ~= nil then
		txt.level = level
	else
		txt.level = HUD_DEFAULT_LEVEL
	end
	txt.use_mipfilter = true
		
	Add(txt)
	
	return txt
end

function AddTextElement_Val(name, material, init_pos, align, size, value, controllers, formats, parent, level, params)
	local txt = AddTextElement(name, material, init_pos, align, size, controllers, formats, parent, level)
	txt.value = value
	txt.element_params = params
	return txt
end

function AddTextElement_Param(name, material, init_pos, align, size, params, controllers, formats, parent, level)
	local txt = AddTextElement(name, material, init_pos, align, size, controllers, formats, parent, level)
	txt.element_params = params
	return txt
end


function AddDummy(name, collimated, parent, controllers, parameters, level)
	local dummy = CreateElement "ceSimple"
	dummy.name = name
	dummy.collimated = collimated
	dummy.element_params = parameters
	dummy.parent_element = parent
	dummy.controllers = controllers
	
	if level then
		dummy.level = level
	else
		dummy.level = HUD_DEFAULT_LEVEL
	end
	
	Add(dummy)
	return dummy
end



function textcoords(xscale,yscale,xpos,ypos) --percent values. xpos/ypos are signed percent regard to center.
	local xsize = xscale*(hudspan/2)
	local ysize = yscale*(hudspan/2)
	return {xpos*xsize,ypos*ysize}
end

function frompercent(value,scale)
	local scale = scale or 1
	local xsize = scale*hudspan/2
	return value*xsize
end

function roundto(number,place)
	number = math.floor(number)
	return number-(number%place)
end




local shape_rotation = 0
shape_rotation = math.tan(shape_rotation/57.3) * 1000 -- to mils -- NOTE: this does nothing currently, returns 0
local full_radius =  108 -- is this the radius of "HUD/net view field"? Units (pixels or angular units)?
local grid_shift  = -35 -- explain shift?
local grid_radius =  full_radius + grid_shift
local grid_origin	         = CreateElement "ceSimple"
grid_origin.name 		     = create_guid_string() -- no such function in this script. Not in definitions.lua either. Could be in elements_defs.lua
grid_origin.collimated 		 = true
AddElement(grid_origin)
local grid	    = CreateElement "ceTexPoly" --this could be the text area on HUD
grid.name 		= create_guid_string() -- this must be external function call.
grid.vertices   = {{-grid_radius, grid_radius},
				   { grid_radius, grid_radius},
				   { grid_radius,-grid_radius},
				   {-grid_radius,-grid_radius}}
grid.indices	= {0,1,2,2,3,0}
grid.tex_coords = {{0,0},{1,0},{1,1},{0,1}}
grid.material   = GRID_	   
grid.init_pos   = {0,grid_shift + shape_rotation} 
grid.collimated = true
grid.parent_element = grid_origin.name
-- AddElement(grid)


function AddDummy(name, collimated, parent, controllers, parameters, level)
	local dummy = CreateElement "ceSimple"
	dummy.name = name
	dummy.collimated = collimated
	dummy.element_params = parameters
	dummy.parent_element = parent
	dummy.controllers = controllers
	
	if level then
		dummy.level = level
	else
		dummy.level = HUD_DEFAULT_LEVEL
	end
	
	Add(dummy)
	return dummy
end