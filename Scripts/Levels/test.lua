-- include useful files
u_execDependencyScript("library_extbase", "extbase", "syyrion", "utils.lua")

u_execDependencyScript("library_extbase", "extbase", "syyrion", "common.lua")
u_execDependencyScript("library_extbase", "extbase", "syyrion", "commonpatterns.lua")
u_execScript("quantumpatterns.lua")

-- this function adds a pattern to the timeline based on a key

--qIdealBarrageSpiral(position, times, {dirChange}), direction, step, gap, spacing) // CAN JUST PUT NUMBER IN DIRCHANGE, or single value table
--qConnectingSpiral(times, delayMult, position, direction, width, gap, spacing)

--qSpiral(pos, scale, times, size, width, "dirmode")(step times size width "dir")(spacing)
--qSpiral(pos, scale, times, size, width, "dirmode"){step}(spacing)

function addPattern(mKey)
	--if mKey == 0 then qSpiral(rpos(), 0, 10, 6, 3){1}(1.25)
	--if mKey == 0 then qSpiral(rpos(), 1, 5, 6, 3){1,2}(1.25)
	--if mKey == 0 then qIdealBarrageSpiral(rpos(), 24, 6, rdir(), 1, 3, 2)
    --end
end

-- shuffle the keys, and then call them to add all the patterns
-- shuffling is better than randomizing - it guarantees all the patterns will be called
keys = { 0 }
shuffle(keys)
index = 0

-- onInit is an hardcoded function that is called when the level is first loaded
function onInit()
    l_setSpeedMult(2.5)
    l_setSpeedInc(0)
    l_setRotationSpeed(0.04)
    l_setRotationSpeedMax(0.4)
    l_setRotationSpeedInc(0)
    l_setDelayMult(1)
    l_setDelayInc(0.0)
    l_setFastSpin(0.0)
    l_setSides(12)
    l_setSidesMin(12)
    l_setSidesMax(12)
    l_setIncTime(15)
	
	l_setRadiusMin(72)
	l_setPulseMin(72)
	l_setPulseMax(100)
	l_setPulseSpeed(5)
	l_setPulseSpeedR(5)
	
	l_setBeatPulseMax(0)
    --l_setBeatPulseMax(14)
    --l_setBeatPulseDelayMax(21.95) -- BPM is 164, 3600/164 is 21.95
    --l_setBeatPulseSpeedMult(0.45) -- Slows down the center going back to normal
end

-- onLoad is an hardcoded function that is called when the level is started/restarted
function onLoad()
	e_waitUntilS(0)
	e_eval([[e_messageAddImportantSilent("WELCOME TO THIS SPIRAL LIBRARY\n\nCHECK README FOR DOCUMENTATION\n\nPLASTIC RATIO 0.98-1.03 SHOWS SOME SPIRAL EXAMPLES\n\nCREDIT TO SYYRION, MANIAC, VIPRE, ZX, THE SUN XIX\nFOR CODING HELP AND LEVEL FEEDBACK", 10000)]])
	e_stopTimeS(10000)
end

-- onStep is an hardcoded function that is called when the level timeline is empty
-- onStep should contain your pattern spawning logic
function onStep()

	addPattern(keys[index])
	index = index + 1


	if index - 1 == #keys then
		index = 1
		shuffle(keys)
	end
	

end

-- onIncrement is an hardcoded function that is called when the level difficulty is incremented
function onIncrement()
end

-- onUnload is an hardcoded function that is called when the level is closed/restarted
function onUnload()
end

-- onInput is a hardcoded function invoked when the player executes input
function onInput(mFrameTime, mMovement, mFocus, mSwap)
end

-- onUpdate is an hardcoded function that is called every frame
function onUpdate(mFrameTime)
end

-- onPreDeath is an hardcoded function that is called when the player is killed, even
-- in tutorial mode
function onPreDeath()
end
