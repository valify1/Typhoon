Presets = 
{
	FGR4 =
	{
		{
			Type = "overwingVapor",
			ShadingFX = "ParticleSystem2/overwingVapor.fx",
			UpdateFX  = "ParticleSystem2/overwingVaporComp.fx",
			Technique = "techOverwingVapor",

			Texture = "overwingVapor.dds",
			TextureDetailNoise = "puffNoise.png",
			LODdistance = 1500,

			SpawnLocationsFile = "FGR4_vapor.owv",

			ParticlesCount = 400,
			ParticleSize = 3.7,
			ScaleOverAgeFactor = 1.8, -- scale = ParticleSize * (1 + (normalized age) * ScaleOverAgeFactor)
			
			VaporLengthMax = 12.0, -- meters
			
			AlbedoSRGB = 0.86,
			
			OpacityMax = 0.5,
			OpacityOverPower = {-- vapor power -> normalized opacity. In this case opacity = sqrt(vapor power)
				{0.0,	0.0},
				{0.125,	0.35355339059327376220042218105242},
				{0.25,	0.5},
				{0.5,	0.70710678118654752440084436210485},
				{1.0,	1.0},
			},
		}
	}
}
