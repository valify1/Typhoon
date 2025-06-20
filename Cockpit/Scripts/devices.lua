local count = 0
local function counter()
	count = count + 1
	return count
end
-------DEVICE ID----------
devices = {}
devices["COCKPIT"]					= counter()
devices["ELECTRICAL"]				= counter()
devices["MFD"]						= counter()
devices["HUD"]						= counter()
devices["FLCS"]						= counter()
devices["FLTCTRLS"]					= counter()
devices["LIGHTS"]					= counter()
devices["INTERCOM"]					= counter()
devices["RADIO"]					= counter()
devices["NVG"]						= counter()
