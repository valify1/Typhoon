dofile("Tools.lua")



hostCkpt = ED_AudioAPI.createHost(ED_AudioAPI.ContextCockpit, "Cockpit")
hostExtern = ED_AudioAPI.createHost(ED_AudioAPI.ContextWorld, "External")



function onUpdate(params)
	updateHost(hostCkpt, params)
	updateHost(hostExtern, params)
end

local offset = 0.0


GSTStartExt = ED_AudioAPI.createSource(hostExtern, "Engines/APUIn2")
EngStartExt = ED_AudioAPI.createSource(hostExtern, "Engines/APUBegin2")

local i = 1
local j = 1

function onEvent_MainEngine(EngN1) --, EngN2, EngTGT, EngIsRunnin, EngJetStart)
	
	if i == 1 then
	ED_AudioAPI.playSourceOnce(EngStartExt)
	i = 0
	end
	ED_AudioAPI.setSourcePitch(EngStartExt, EngN1)
	ED_AudioAPI.isSourcePlaying(EngStartExt) 
	dbgPrint("src: " .. ED_AudioAPI.isSourcePlaying(EngStartExt) )

end


function onEvent_GST(GSTN1) --, GSTN2, GSTTGT, GSTIsRunnin, GSTJetStart)

	if i == j then
	ED_AudioAPI.playSourceOnce(EngStartExt)
	i = j
	end
	ED_AudioAPI.setSourcePitch(GSTStartExt, GSTN1)
	ED_AudioAPI.isSourcePlaying(GSTStartExt) 
	dbgPrint("src: " .. ED_AudioAPI.isSourcePlaying(GSTStartExt) )


end

