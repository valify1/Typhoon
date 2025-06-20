start_custom_command   = 10000
local __count_custom = start_custom_command-1
local function __custom_counter()
	__count_custom = __count_custom + 1
	return __count_custom
end

count = 10000
device_commands =
{
	pilotDraw = __custom_counter(),
	parkBrake = __custom_counter(),
	seatArm = __custom_counter(),
	seatEject = __custom_counter(),
}

LIGHTS = 
{
	Nav = __custom_counter(),
	AntiCol = __custom_counter(),
	LandTaxi = __custom_counter(),
	Form = __custom_counter(),
	Strobe = __custom_counter(),
}

FCS =
{
	Reset = __custom_counter(),
}

MISC =
{
	Covers = __custom_counter(),
	Ladder = __custom_counter(),
}

FUEL = 
{
	BoostL = __custom_counter(),
	BoostR = __custom_counter(),
	EngCoverL = __custom_counter(),
	EngSwitchL = __custom_counter(),
	EngCoverR = __custom_counter(),
	EngSwitchR = __custom_counter(),

}

ELECTRICAL = 
{
	Batt = __custom_counter(),
	GenL = __custom_counter(),
	GenR = __custom_counter(),
	RadAlt = __custom_counter(),
	APU = 1071,
}

HUD =
{
	Brightness = __custom_counter(),
	Balance = __custom_counter(),
	Contrast = __custom_counter(),
	Depth = __custom_counter(),
}

LMFD =
{
	Power = __custom_counter(),
	Brightness = __custom_counter(),
	Balance = __custom_counter(),
	OSB1 = __custom_counter(),
	OSB2 = __custom_counter(),
	OSB3 = __custom_counter(),
	OSB4 = __custom_counter(),
	OSB5 = __custom_counter(),
	OSB6 = __custom_counter(),
	OSB7 = __custom_counter(),
	OSB8 = __custom_counter(),
	OSB9 = __custom_counter(),
	OSB10 = __custom_counter(),
	OSB11 = __custom_counter(),
	OSB12 = __custom_counter(),
	OSB13 = __custom_counter(),
	OSB14 = __custom_counter(),
	OSB15 = __custom_counter(),
	OSB16 = __custom_counter(),
	OSB17 = __custom_counter(),
}

CMFD =
{
	Power = __custom_counter(),
	Brightness = __custom_counter(),
	Balance = __custom_counter(),
	OSB1 = __custom_counter(),
	OSB2 = __custom_counter(),
	OSB3 = __custom_counter(),
	OSB4 = __custom_counter(),
	OSB5 = __custom_counter(),
	OSB6 = __custom_counter(),
	OSB7 = __custom_counter(),
	OSB8 = __custom_counter(),
	OSB9 = __custom_counter(),
	OSB10 = __custom_counter(),
	OSB11 = __custom_counter(),
	OSB12 = __custom_counter(),
	OSB13 = __custom_counter(),
	OSB14 = __custom_counter(),
	OSB15 = __custom_counter(),
	OSB16 = __custom_counter(),
	OSB17 = __custom_counter(),
}

RMFD =
{
	Power = __custom_counter(),
	Brightness = __custom_counter(),
	Balance = __custom_counter(),
	OSB1 = __custom_counter(),
	OSB2 = __custom_counter(),
	OSB3 = __custom_counter(),
	OSB4 = __custom_counter(),
	OSB5 = __custom_counter(),
	OSB6 = __custom_counter(),
	OSB7 = __custom_counter(),
	OSB8 = __custom_counter(),
	OSB9 = __custom_counter(),
	OSB10 = __custom_counter(),
	OSB11 = __custom_counter(),
	OSB12 = __custom_counter(),
	OSB13 = __custom_counter(),
	OSB14 = __custom_counter(),
	OSB15 = __custom_counter(),
	OSB16 = __custom_counter(),
	OSB17 = __custom_counter(),
}