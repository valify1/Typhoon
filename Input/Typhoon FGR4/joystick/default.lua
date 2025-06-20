--local res = external_profile("Config/Input/Aircrafts/base_joystick_binding.lua")
local cockpit = folder.."../../../Cockpit/Scripts/"
dofile(cockpit.."devices.lua")

return {

forceFeedback = {
trimmer = 1.0,
shake = 0.5,
swapAxes = false,
invertX = false,
invertY = false,
},

keyCommands = {	
	--Flight Control
	{down = iCommandPlaneTrimCancel, name = 'Trim: Reset All', category = 'Flight Control'},
	{pressed = 8997, up = iCommandPlaneTrimStop,  name = 'Trim: Nose Down', category = 'Flight Control'},
	{pressed = 8998, up = iCommandPlaneTrimStop,  name = 'Trim: Nose Up', category = 'Flight Control'},
	{pressed = 8999, name = 'FLCS Gain ON/OFF', category = 'Flight Control'},
	{pressed = iCommandPlaneTrimLeft, up = iCommandPlaneTrimStop, name = _('Trim: Left Wing Down'), category = _('Flight Control')},
	{pressed = iCommandPlaneTrimRight, up = iCommandPlaneTrimStop, name = _('Trim: Right Wing Down'), category = _('Flight Control')},
	{pressed = iCommandPlaneTrimLeftRudder, up = iCommandPlaneTrimStop, name = _('Trim: Rudder Left'), category = _('Flight Control')},
	{pressed = iCommandPlaneTrimRightRudder, up = iCommandPlaneTrimStop, name = _('Trim: Rudder Right'), category = _('Flight Control')},
	--{down = 10016, name = 'FSTB NWS Toggle', category = 'Flight Control'},
	{down = iCommandPlaneLeftRudderStart,	up = iCommandPlaneLeftRudderStop,	name = _('Aircraft Rudder Left'),	category = _('Flight Control')},
	{down = iCommandPlaneRightRudderStart,	up = iCommandPlaneRightRudderStop,	name = _('Aircraft Rudder Right'),	category = _('Flight Control')},

	-- Systems
	{down = iCommandPlaneAirBrake, name = _('Airbrake'), category = _('Systems')},
	{pressed = iCommandPlaneAirBrakeOn, name = _('Airbrake On'), category = _('Systems')},
	{pressed = iCommandPlaneAirBrakeOff, name = _('Airbrake Off'), category = _('Systems')},
	{down = iCommandPlaneCockpitIllumination, name = _('Illumination Cockpit'), category = _('Systems')},
	{down = iCommandPlaneLightsOnOff, name = _('Navigation lights'), category = _('Systems')},
	{down = iCommandPlaneHeadLightOnOff, name = _('Gear Light Near/Far/Off'), category = _('Systems')},
	{down = iCommandPlaneGear, name = _('Landing Gear Up/Down'), category = _('Systems')},
	{down = iCommandPlaneGearUp, name = _('Landing Gear Up'), category = _('Systems')},
	{down = iCommandPlaneGearDown, name = _('Landing Gear Down'), category = _('Systems')},
	{down = iCommandPlaneWheelBrakeOn, up = iCommandPlaneWheelBrakeOff, name = _('Wheel Brake On'), category = _('Systems')},
	{down = iCommandPlaneFonar, name = _('Canopy Open/Close'), category = _('Systems')},
	--{down = iCommandPlaneParachute, name = _('Dragging Chute'), category = _('Systems')},
	{down = iCommandPlaneResetMasterWarning, name = _('Audible Warning Reset'), category = _('Systems')},
	{down = iCommandPlaneJettisonWeapons,up = iCommandPlaneJettisonWeaponsUp, name = _('Weapons Jettison'), category = _('Systems')},
	{down = iCommandPlaneEject, name = _('Eject (3 times)'), category = _('Systems')},
	{down = iCommandEnginesStart, name = _('Engines Start'), category = _('Systems')},
	{down = iCommandEnginesStop, name = _('Engines Stop'), category = _('Systems')},
	--{down = iCommandLeftEngineStart, name = _('Engine Left Start'), category = _('Systems')},
	--{down = iCommandLeftEngineStop, name = _('Engine Left Stop'), category = _('Systems')},
	--{down = iCommandRightEngineStart, name = _('Engine Right Start'), category = _('Systems')},
	--{down = iCommandRightEngineStop, name = _('Engine Right Stop'), category = _('Systems')},
	{down = iCommandPlaneFuelOn, up = iCommandPlaneFuelOff, name = _('Fuel Dump'), category = _('Systems')},

	{combos = {{key = 'JOY_BTN_POV1_L'}},		pressed = iCommandViewLeftSlow,			up = iCommandViewStopSlow,	name = _('View Left slow'),			category = _('View')},
	{combos = {{key = 'JOY_BTN_POV1_R'}},		pressed = iCommandViewRightSlow,		up = iCommandViewStopSlow,	name = _('View Right slow'),		category = _('View')},
	{combos = {{key = 'JOY_BTN_POV1_U'}},		pressed = iCommandViewUpSlow,			up = iCommandViewStopSlow,	name = _('View Up slow'),			category = _('View')},
	{combos = {{key = 'JOY_BTN_POV1_D'}},		pressed = iCommandViewDownSlow,			up = iCommandViewStopSlow,	name = _('View Down slow'),			category = _('View')},
	{combos = {{key = 'JOY_BTN_POV1_UR'}},		pressed = iCommandViewUpRightSlow,		up = iCommandViewStopSlow,	name = _('View Up Right slow'),		category = _('View')},
	{combos = {{key = 'JOY_BTN_POV1_DR'}},		pressed = iCommandViewDownRightSlow,	up = iCommandViewStopSlow,	name = _('View Down Right slow'),	category = _('View')},
	{combos = {{key = 'JOY_BTN_POV1_DL'}},		pressed = iCommandViewDownLeftSlow,		up = iCommandViewStopSlow,	name = _('View Down Left slow'),	category = _('View')},
	{combos = {{key = 'JOY_BTN_POV1_UL'}},		pressed = iCommandViewUpLeftSlow,		up = iCommandViewStopSlow,	name = _('View Up Left slow'),		category = _('View')},

	{pressed = iCommandViewForwardSlow,		up = iCommandViewForwardSlowStop,		name = _('Zoom in slow'),										category = _('View')},
	{pressed = iCommandViewBackSlow,		up = iCommandViewBackSlowStop,			name = _('Zoom out slow'),										category = _('View')},
	{down = iCommandViewAngleDefault,												name = _('Zoom normal'),										category = _('View')},
	{pressed = iCommandViewExternalZoomIn,	up = iCommandViewExternalZoomInStop,	name = _('Zoom external in'),									category = _('View')},
	{pressed = iCommandViewExternalZoomOut,	up = iCommandViewExternalZoomOutStop,	name = _('Zoom external out'),									category = _('View')},
	{down = iCommandViewExternalZoomDefault,										name = _('Zoom external normal'),								category = _('View')},
	{down = iCommandViewCenter,											        name = ('View Center'),                                    					category = ('View')},	
	{down = iCommandViewSaveAngles,													name = _('Save Cockpit Angles'),			category = _('View Cockpit')},
	{pressed = iCommandViewUp,				up = iCommandViewStop,					name = _('View up'),						category = _('View Cockpit')},
	{pressed = iCommandViewDown,			up = iCommandViewStop,					name = _('View down'),						category = _('View Cockpit')},
	{pressed = iCommandViewLeft,			up = iCommandViewStop,					name = _('View left'),						category = _('View Cockpit')},
	{pressed = iCommandViewRight,			up = iCommandViewStop,					name = _('View right'),						category = _('View Cockpit')},
	{pressed = iCommandViewUpRight,			up = iCommandViewStop,					name = _('View up right'),					category = _('View Cockpit')},
	{pressed = iCommandViewDownRight,		up = iCommandViewStop,					name = _('View down right'),				category = _('View Cockpit')},
	{pressed = iCommandViewDownLeft,		up = iCommandViewStop,					name = _('View down left'),					category = _('View Cockpit')},
	{pressed = iCommandViewUpLeft,			up = iCommandViewStop,					name = _('View up left'),					category = _('View Cockpit')},
	{down = iCommandViewCameraLeftSlow,												name = _('Camera snap view left'),			category = _('View Cockpit')},
	{down = iCommandViewCameraRightSlow,											name = _('Camera snap view right'),			category = _('View Cockpit')},
	
	{down = iCommandPlaneAirRefuel, name = 'Refueling Door', category = 'Systems'},
	{down = iCommandPlaneJettisonFuelTanks, name = 'Jettison Fuel Tanks', category = 'Systems'},
},

axisCommands = {
{action = 9000, name = 'Pitch'},
{action = 9003, name = 'Rudder'},
{action = 9002, name = _('Roll')}, -- 2002
{action = iCommandPlaneThrustCommon, 		name = _('Thrust')},
{action = iCommandViewHorizontalAbs,		name = _('Absolute Camera Horizontal View')},
{action = iCommandViewVerticalAbs,			name = _('Absolute Camera Vertical View')},
{action = iCommandViewZoomAbs,				name = _('Zoom View')},
{action = iCommandViewRollAbs,				name = _('Absolute Roll Shift Camera View')},
{action = iCommandViewHorTransAbs,			name = _('Absolute Horizontal Shift Camera View')},
{action = iCommandViewVertTransAbs,			name = _('Absolute Vertical Shift Camera View')},
{action = iCommandViewLongitudeTransAbs,	name = _('Absolute Longitude Shift Camera View')},

{action = iCommandWheelBrake,		name = 'Wheel Brake'},
{action = iCommandLeftWheelBrake,	name = 'Wheel Brake Left'},
{action = iCommandRightWheelBrake,	name = 'Wheel Brake Right'},
},
}