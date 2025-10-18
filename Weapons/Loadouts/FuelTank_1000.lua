
local jas_tank1100_name = 'Drop tank 1100 litre'


declare_loadout(
    {
        category    = CAT_FUEL_TANKS,
        displayName = _("Fuel Tank 1000 litres"),
        Picture     = "FuelTank_1000.png",        
        attribute   = {wsType_Air, wsType_Free_Fall, wsType_FuelTank, WSTYPE_PLACEHOLDER},
        CLSID       = "{FUEL_1KL_FGR4}",
        
        Weight_Empty = 95 ,
        Weight = 95 + 851.06,
        Cx_pil = 0.0014,
        shape_table_data =
        {
            {
                name = FuelTank_1000_name,
                file = "FuelTank_1000",
                life = 1,
                fire = { 0, 1},
                username = "FuelTank 1000",
                index = WSTYPE_PLACEHOLDER,
            },
        },
        Elements =
        {
            {
                ShapeName = "FuelTank_1000",
            },
        },
})

