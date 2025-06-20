local res = external_profile("Config/Input/Aircrafts/common_keyboard_binding.lua")
join(res.keyCommands,{

{combos = {{key = 'P', reformers = {'LShift'}}}, down = 10001, name = 'Pilot Body TOGGLE', category = 'Cockpit'},
{combos = {{key = 'N', reformers = {'RAlt'}}},	down = iCommandViewLeftMirrorOn ,	up = iCommandViewLeftMirrorOff ,	name = _('Mirror Left On'),		category = _('View Cockpit') , features = {"Mirrors"}},
{combos = {{key = 'M', reformers = {'RAlt'}}},	down = iCommandViewRightMirrorOn,	up = iCommandViewRightMirrorOff,	name = _('Mirror Right On'),	category = _('View Cockpit') , features = {"Mirrors"}},
{combos = {{key = 'M' }},						down = iCommandToggleMirrors,											name = _('Toggle Mirrors'),		category = _('View Cockpit') , features = {"Mirrors"}},

--Flight Control
{combos = {{key = 'T', reformers = {'LAlt'}}}, down = iCommandPlaneTrimCancel, name = 'Trim: Reset All', category = 'Flight Control'},
{combos = {{key = '.', reformers = {'RCtrl'}}}, pressed = 8998, up = iCommandPlaneTrimStop, name = _('Trim: Nose Up'), category = _('Flight Control')},
{combos = {{key = ';', reformers = {'RCtrl'}}}, pressed = 8997, up = iCommandPlaneTrimStop, name = _('Trim: Nose Down'), category = _('Flight Control')},
{combos = {{key = ',', reformers = {'RCtrl'}}}, pressed = iCommandPlaneTrimLeft, up = iCommandPlaneTrimStop, name = _('Trim: Left Wing Down'), category = _('Flight Control')},
{combos = {{key = '/', reformers = {'RCtrl'}}}, pressed = iCommandPlaneTrimRight, up = iCommandPlaneTrimStop, name = _('Trim: Right Wing Down'), category = _('Flight Control')},
{combos = {{key = 'Z', reformers = {'RCtrl'}}}, pressed = iCommandPlaneTrimLeftRudder, up = iCommandPlaneTrimStop, name = _('Trim: Rudder Left'), category = _('Flight Control')},
{combos = {{key = 'X', reformers = {'RCtrl'}}}, pressed = iCommandPlaneTrimRightRudder, up = iCommandPlaneTrimStop, name = _('Trim: Rudder Right'), category = _('Flight Control')},
{combos = {{key = 'Z'}},		down = iCommandPlaneLeftRudderStart,	up = iCommandPlaneLeftRudderStop,	name = _('Aircraft Rudder Left'),	category = _('Flight Control')},
{combos = {{key = 'X'}},		down = iCommandPlaneRightRudderStart,	up = iCommandPlaneRightRudderStop,	name = _('Aircraft Rudder Right'),	category = _('Flight Control')},

-- Systems
{combos = {{key = 'Q', reformers = {'LAlt'}}}, down = 10016, name = 'FSTB NWS Toggle', category = 'Flight Control'},
{combos = {{key = 'R'}}, down = iCommandPlaneFuelOn, up = iCommandPlaneFuelOff, name = 'Fuel Dump', category = 'Systems'},
{combos = {{key = 'R', reformers = {'LAlt'}}}, down = iCommandPlaneJettisonFuelTanks, name = 'Jettison Fuel Tanks', category = 'Systems'},
{combos = {{key = 'B'}}, down = iCommandPlaneAirBrake, name = _('Airbrake'), category = _('Systems')},
{combos = {{key = 'B', reformers = {'LShift'}}}, down = iCommandPlaneAirBrakeOn, name = _('Airbrake On'), category = _('Systems')},
{combos = {{key = 'B', reformers = {'LCtrl'}}}, down = iCommandPlaneAirBrakeOff, name = _('Airbrake Off'), category = _('Systems')},
{combos = {{key = 'L'}}, down = iCommandPlaneCockpitIllumination, name = _('Illumination Cockpit'), category = _('Systems')},
{combos = {{key = 'L', reformers = {'RCtrl'}}}, down = iCommandPlaneLightsOnOff, name = _('Navigation lights'), category = _('Systems')},
{combos = {{key = 'L', reformers = {'RAlt'}}}, down = iCommandPlaneHeadLightOnOff, name = _('Gear Light Near/Far/Off'), category = _('Systems')},
{combos = {{key = 'G'}}, down = iCommandPlaneGear, name = _('Landing Gear Up/Down'), category = _('Systems')},
{combos = {{key = 'G', reformers = {'LCtrl'}}}, down = iCommandPlaneGearUp, name = _('Landing Gear Up'), category = _('Systems')},
{combos = {{key = 'G', reformers = {'LShift'}}}, down = iCommandPlaneGearDown, name = _('Landing Gear Down'), category = _('Systems')},
{combos = {{key = 'W'}}, down = iCommandPlaneWheelBrakeOn, up = iCommandPlaneWheelBrakeOff, name = _('Wheel Brake On'), category = _('Systems')},
{combos = {{key = 'C', reformers = {'LCtrl'}}}, down = iCommandPlaneFonar, name = _('Canopy Open/Close'), category = _('Systems')},
--{combos = {{key = 'P'}}, down = iCommandPlaneParachute, name = _('Dragging Chute'), category = _('Systems')},
{combos = {{key = 'N', reformers = {'RShift'}}}, down = iCommandPlaneResetMasterWarning, name = _('Audible Warning Reset'), category = _('Systems')},
{combos = {{key = 'W', reformers = {'LCtrl'}}}, down = iCommandPlaneJettisonWeapons,up = iCommandPlaneJettisonWeaponsUp, name = _('Weapons Jettison'), category = _('Systems')},
{combos = {{key = 'E', reformers = {'LCtrl'}}}, down = iCommandPlaneEject, name = _('Eject (3 times)'), category = _('Systems')},
{combos = {{key = 'Home', reformers = {'RShift'}}}, down = iCommandEnginesStart, name = _('Engines Start'), category = _('Systems')},
{combos = {{key = 'End', reformers = {'RShift'}}}, down = iCommandEnginesStop, name = _('Engines Stop'), category = _('Systems')},
})
return res