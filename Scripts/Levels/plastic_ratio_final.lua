-- include useful files
u_execDependencyScript("library_extbase", "extbase", "syyrion", "utils.lua")
u_execDependencyScript("library_extbase", "extbase", "syyrion", "common.lua")
u_execDependencyScript("library_extbase", "extbase", "syyrion", "commonpatterns.lua")
u_execScript("quantumpatterns.lua")

DIFFICULTY = simplifyFloat(u_getDifficultyMult(), 2)

--makes 1-6
diff = (DIFFICULTY*100 + 2) -99

-- shuffle the keys, and then call them to add all the patterns
-- shuffling is better than randomizing - it guarantees all the patterns will be called
index = 0

function sideCounts()
	l_setSides(useSide[u_rndIntUpper(#useSide)])
end

-- onInit is an hardcoded function that is called when the level is first loaded
function onInit()
	if DIFFICULTY == 0.98 then
		keys = {0, 1, 2, 3}
		useSide = {5, 6}

		l_setSpeedMult(1.5)
		l_setSpeedInc(0.05) --0.05

		l_setRotationSpeed(0.1)
		l_setRotationSpeedMax(0.45)
		l_setRotationSpeedInc(0.05) --0.025
		
		s_setStyle("pl_098v2")
		l_setDarkenUnevenBackgroundChunk(false)

		function addPattern(mKey)
		--PATTERN SET: SIMPLE, SAME DIRECTION, OVERDELAYED OR WIDE GAPS
			--qConnectingSpiral(times, delayMult, position, direction, width, gap, spacing)
			--qSpiral(pos, scale, times, size, width, dirmode)(step times size width dir)(spacing)
			--qSpiral(pos, scale, times, size, width, dirmode){step}(spacing)
			--qIdealBarrageSpiral(position, times, {dirChange}), direction, step, gap, spacing)
			
			if mKey == 0 and sides() % 2 == 0 then qSpiral(rpos(), 3, winding(2), 3, 1, "cw"){1}(3) -- CW 1 double spiral
			elseif mKey == 1 then qSpiral(rpos(), 2, winding(3), sides(), 1, "cw"){1}(3) -- CW 1 single spiral
			elseif mKey == 2 then qSpiral(rpos(), 3, winding(4), sides(), sides() - 3, "cw"){1}(3) -- CW {2,3} single spiral
			elseif mKey == 3 then qIdealBarrageSpiral(rpos(), 20, 20, 0, 1, sides() - 2, 3) -- CW 1,{3,4} barrage
			end
		end
	elseif DIFFICULTY == 0.99 then
		keys = {0, 1, 2, 3, 4, 5, 6, 7}
		useSide = {3, 4, 5, 6}

		l_setSpeedMult(1.6) --1.75
		l_setSpeedInc(0.05)

		l_setRotationSpeed(0.2)
		l_setRotationSpeedMax(0.6)
		l_setRotationSpeedInc(0.05)
		
		s_setStyle("pl_099v2")
		l_setDarkenUnevenBackgroundChunk(false)

		function addPattern(mKey)
		--PATTERN SET: IDEAL, EASY PATTERNS, GREATER SIDE VARIETY, RANDOM DIRECTIONS AND PATTERN LENGTH
			--qConnectingSpiral(times, delayMult, position, direction, width, gap, spacing)
			--qSpiral(pos, scale, times, size, width, dirmode)(step times size width dir)(spacing)
			--qSpiral(pos, scale, times, size, width, dirmode){step}(spacing)
			--qIdealBarrageSpiral(position, times, {dirChange}), direction, step, gap, spacing)
			
			if mKey == 1 and sides() >= 5 then qSpiral(rpos(), 1, winding(2, 2.5), sides(), sides() -2){1}(2) --3,4w 2g single spiral
			elseif mKey == 2 and sides() <= 4 then qSpiral(rpos(), 1, winding(2.5, 3), sides(), 1){1}(2) -- 1w single spiral
			elseif mKey == 3 then qIdealBarrageSpiral(rpos(), u_rndInt(10, 16), 20, rdir(), 1, 2, 2) -- 2g 1s barrage
			elseif mKey == 4 and sides() == 4 then qIdealBarrageSpiral(rpos(), u_rndInt(10, 16), 20, rdir(), 2, 1, 2) -- 2g 1s barrage
			elseif mKey == 5 and sides() == 6 then qSpiral(rpos(), 1, 6, 3, 1){1}(2) -- 2w 1g double spiral
			elseif mKey == 6 and sides() == 3 then qConnectingSpiral(winding(2.5), 1, rpos(), rdir(), 1, sides() -1, 2) -- 1w single c-spiral
			elseif mKey == 7 and sides() == 5 then qIdealBarrageSpiral(rpos(), u_rndInt(6, 12), 20, rdir(), 2, 1, 2) -- 1g 2s barrage
			end
		end
	elseif DIFFICULTY == 1 then
		keys = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 11, 12, 13, 14}
		useSide = {4, 6, 8}

		l_setSpeedMult(1.7)
		l_setSpeedInc(0.05)

		l_setRotationSpeed(0.3)
		l_setRotationSpeedMax(0.75)
		l_setRotationSpeedInc(0.05)
		
		s_setStyle("pl_100")
		s_setBGRotationOffset(180/l_getSides())

		function addPattern(mKey)
		--PATTERN SET: SMALLER GAPS, MORE UNUSUAL BUT NOT HARD PATTERNS
			--qConnectingSpiral(times, delayMult, position, direction, width, gap, spacing)
			--qSpiral(pos, scale, times, size, width, dirmode)(step times size width dir)(spacing)
			--qSpiral(pos, scale, times, size, width, dirmode){step}(spacing)
			--qIdealBarrageSpiral(position, times, {dirChange}), direction, step, gap, spacing)
			
			if mKey == 0 and sides() == 6 then qSpiral(rpos(), 1, 10, 3, 2){1}(1.75) -- 2w 1g double spiral
			elseif mKey == 1 and sides() ~= 4 then qSpiral(rpos(), 1, winding(2), sides()/2, 1){1}(1.75) -- 1w 2,3g double spiral
			elseif mKey == 2 and sides() == 6 then qSpiral(rpos(), 1, 6, 2, 1){1}(1.75) -- 1w 1g corner spiral
			elseif mKey == 3 and sides() == 8 then qSpiral(rpos(), 1, 6, 4, 2){2}(1.75) -- 2w 2g 2s corner spiral
			elseif mKey == 4 and sides() ~= 8 then qSpiral(rpos(), 1, winding(2), sides(), sides() -2){1}(1.75) -- 2w single spiral
			elseif mKey == 5 and sides() == 8 then qSpiral(rpos(), 1, winding(2), 4, 2){1}(1.75) -- 2w 2g 1s double spiral
			elseif mKey == 6 and sides() ~= 8 then qIdealBarrageSpiral(rpos(), u_rndInt(10, 16), 20, rdir(), 1, 1, 1.75) -- 1g 1s barrage
			elseif mKey == 7 and sides() == 6 then qIdealBarrageSpiral(rpos(), u_rndInt(6, 10), 20, rdir(), 2, 1, 1.75) -- 1g 2s barrage
			elseif mKey == 8 and sides() == 8 then qIdealBarrageSpiral(rpos(), u_rndInt(8, 12), 20, rdir(), 2, 2, 1.75) -- 2g 2s barrage
			elseif mKey == 9 and sides() == 4 then qConnectingSpiral(10, 1, rpos(), rdir(), 1, sides() -1, 1.75) -- 1w single c-spiral
			elseif mKey == 10 and sides() == 6 then qSpiral(rpos(), 1, 6, 3, 1, "alt"){1}{1}(1.75) -- 2w 1g double spiral/x2r
			elseif mKey == 11 and sides() == 8 then qSpiral(rpos(), 1, 6, 4, 2){1,2}(1.75) -- 2w 1g 1,2s corner spiral
			elseif mKey == 12 and sides() == 8 then qSpiral(rpos(), 0.75, 4, 4, 1){1}{1}{1}{1}(1.75) -- 1w 3g double spiral/x3 **ACTUALLY IDEAL DELAY
			elseif mKey == 13 and sides() == 8 then qIdealBarrageSpiral(rpos(), u_rndInt(4, 8), 20, rdir(), 3, 2, 1.75) -- 3g 2s barrage
			elseif mKey == 14 and sides() == 4 then qSpiral(rpos(), 1, 4, 4, 2, "alt"){1}{1}(1.75) -- 2w single spiral/x2r
			end
		end
	elseif DIFFICULTY == 1.01 then
		keys = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12}
		useSide = {6, 7, 8}

		l_setSpeedMult(1.8)
		l_setSpeedInc(0.05)	

		l_setRotationSpeed(0.4)
		l_setRotationSpeedMax(0.9)
		l_setRotationSpeedInc(0.05)
		
		s_setStyle("pl_101")
		l_setDarkenUnevenBackgroundChunk(false)

		function addPattern(mKey)		
			--PATTERN SET: SMALL GAPS, SIMPLE DIRECTION CHANGES
			--qConnectingSpiral(times, delayMult, position, direction, width, gap, spacing)
			--qSpiral(pos, scale, times, size, width, dirmode)(step times size width dir)(spacing)
			--qSpiral(pos, scale, times, size, width, dirmode){step}(spacing)
			--qIdealBarrageSpiral(position, times, {dirChange}), direction, step, gap, spacing)
			
			if mKey == 0 then qSpiral(rpos(), 1, winding(1.5), sides(), sides() -2){1}(1.5) -- 2g single spiral
			elseif mKey == 1 and sides() == 8 then qSpiral(rpos(), 1, 8, 4, 2){1}(1.5) -- 2w 2g double spiral
			elseif mKey == 2 and sides() ~= 7 then qSpiral(rpos(), 1, 6, 2, 1){1}(1.5) -- 1w 1g corner spiral
			elseif mKey == 3 and sides() ~= 8 then qIdealBarrageSpiral(rpos(), 12, 6, rdir(), 2, 1, 1.5) -- 1g 2s 6d barrage
			elseif mKey == 4 and sides() >= 7 then qIdealBarrageSpiral(rpos(), 10, {4, 7}, rdir(), 2, 2, 1.5) -- 2g 2s r barrage
			elseif mKey == 5 and sides() == 8 then qIdealBarrageSpiral(rpos(), 8, 3, rdir(), 3, 2, 1.5) -- 2g 3s 3d barrage
			elseif mKey == 6 and sides() >= 7 then qIdealBarrageSpiral(rpos(), 10, 10, rdir(), 1, 2, 1.5) -- 2g 1s barrage
			elseif mKey == 7 and sides() == 6 then qIdealBarrageSpiral(rpos(), 8, 4, rdir(), 1, 1, 1.5) -- 1g 1s 4d barrage
			elseif mKey == 8 and sides() == 6 then qConnectingSpiral(6, 1, rpos(), rdir(), 1, 2, 1.5) -- 1w 2g double c-spiral
			elseif mKey == 9 and sides() == 8 then qSpiral(rpos(), 1, 6, 4, 2, "alt"){1}{1}{1}(1.5) -- 2w 2g double spiral/x3r
			elseif mKey == 10 and sides() == 6 then qSpiral(rpos(), 1, 6, 3, 1, "alt"){1}{1}{1}(1.5) -- 1w 2g double spiral/x3r
			end
			
		end
		elseif DIFFICULTY == 1.02 then
		keys = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16}
		useSide = {6, 9, 12}

		l_setSpeedMult(1.9)
		l_setSpeedInc(0.05)	

		l_setRotationSpeed(0.5)
		l_setRotationSpeedMax(1.05)
		l_setRotationSpeedInc(0.05)
		
		s_setStyle("pl_102")
		l_setDarkenUnevenBackgroundChunk(false)
		--1.375 delays

		function addPattern(mKey)		
			--PATTERN SET: DIFFICULT, ESPECIALLY HARD PATTERNS FOR 6, LARGER GAPS FOR 12.
			--qConnectingSpiral(times, delayMult, position, direction, width, gap, spacing)
			--qSpiral(pos, scale, times, size, width, dirmode)(step times size width dir)(spacing)
			--qSpiral(pos, scale, times, size, width, dirmode){step}(spacing)
			--qIdealBarrageSpiral(position, times, {dirChange}), direction, step, gap, spacing)
			
			if mKey == 0 and sides() == 6 then qSpiral(rpos(), 1, 3, 3, 1, "alt"){1}{1}{1}{1}(1.375) -- 1w 2g double spiral/x4r
			elseif mKey == 1 and sides() == 6 then qSpiral(rpos(), 1, 6, 3, 1, "alt"){1}({1}, 6, 3, 2)({1}, 6, 3, 1)(1.375)
			elseif mKey == 2 and sides() == 12 then qSpiral(rpos(), 1, 8, 6, 3, "alt"){1}{1}(1.375) -- 3w 3g double spiral/x2r
			elseif mKey == 3 and sides() == 12 then qSpiral(rpos(), 1, 8, 4, 2, "alt"){1}(1.375) -- 2w 2g triple spiral
			elseif mKey == 4 and sides() == 12 then qSpiral(rpos(), 1, 8, 3, 1, "alt"){1}(1.375) -- 1w 2g quadruple spiral
			elseif mKey == 5 and sides() == 12 then qSpiral(rpos(), 1, 8, 4, 2, "alt"){2}(1.375) -- 2w 2g 2s triple corner spiral
			elseif mKey == 6 and sides() == 9 then qSpiral(rpos(), 1, 12, 3, 1){1}(1.375) -- 1w 2g triple spiral
			elseif mKey == 7 and sides() ~= 12 then qSpiral(rpos(), 1, 8, 3, 2){1}(1.375) -- 2w 1g double/triple corner spiral
			elseif mKey == 8 and sides() == 6 then qIdealBarrageSpiral(rpos(), rInt(4,8), 4, rdir(), 1, 1, 1.375) -- 1g 1s 4d barrage
			elseif mKey == 9 and sides() == 6 then qIdealBarrageSpiral(rpos(), rInt(4,8), {2,4}, rdir(), 2, 1, 1.375) -- 1g 2s r barrage
			elseif mKey == 10 and sides() == 9 then qIdealBarrageSpiral(rpos(), 9, 3, rdir(), 3, 2, 1.375) -- 2g 3s 3d barrage
			elseif mKey == 11 and sides() == 9 then qIdealBarrageSpiral(rpos(), 12, 3, rdir(), 2, 2, 1.375) -- 2g 2s 3d barrage
			elseif mKey == 12 and sides() == 9 then qIdealBarrageSpiral(rpos(), 12, 12, rdir(), 1, 1, 1.375) -- 1g 1s barrage
			elseif mKey == 13 and sides() == 12 then qIdealBarrageSpiral(rpos(), 18, 9, rdir(), 1, 2, 1.375) -- 2g 1s 9d barrage
			elseif mKey == 14 and sides() == 12 then qIdealBarrageSpiral(rpos(), 12, 6, rdir(), 2, 2, 1.375) -- 2g 2s 6d barrage
			elseif mKey == 15 and sides() == 12 then qIdealBarrageSpiral(rpos(), 9, 3, rdir(), 3, 2, 1.375) -- 2g 3s 3d barrage
			elseif mKey == 16 and sides() == 12 then qIdealBarrageSpiral(rpos(), 24, 6, rdir(), 1, 3, 1.375) -- 3g 1s 6d barrage
			
			end
			
		end
	elseif DIFFICULTY == 1.03 then
		keys = {0, 1, 2, 3, 4, 5, 6, 7}
		useSide = {8, 9, 10} 

		l_setSpeedMult(2) --2.5
		l_setSpeedInc(0.05)

		l_setRotationSpeed(0.6)
		l_setRotationSpeedMax(1.2)
		l_setRotationSpeedInc(0.05)
		
		s_setStyle("pl_103v2")
		l_setDarkenUnevenBackgroundChunk(false)

		function addPattern(mKey)
			--PATTERN SET: V. DIFFICULT. TINY GAPS. SURPRISINGLY TO ME, PATTERNS CAN GET EVEN HARDER THAN THESE...
			--qConnectingSpiral(times, delayMult, position, direction, width, gap, spacing)
			--qSpiral(pos, scale, times, size, width, dirmode)(step times size width dir)(spacing)
			--qSpiral(pos, scale, times, size, width, dirmode){step}(spacing)
			--qIdealBarrageSpiral(position, times, {dirChange}), direction, step, gap, spacing)
			
			if mKey == 0 and sides() == 9 then qSpiral(rpos(), 1, 6, 3, 2){1}(1.25) -- 2w 1g corner spiral
			elseif mKey == 1 and sides() ~= 9 then qSpiral(rpos(), 1, 6, 2, 1){1}(1.25) -- 1w 1g corner spiral
			elseif mKey == 2 and sides() == 8 then qSpiral(rpos(), 1, 4, 4, 2, "alt"){1}{1}{1}(1.25) -- 2w 2g double spiral/x3r
			elseif mKey == 3 then qIdealBarrageSpiral(rpos(), 12, {3, 5}, rdir(), 2, 2, 1.25) -- 2g 2s r barrage
			elseif mKey == 4 then qIdealBarrageSpiral(rpos(), u_rndInt(8, 12), 6, rdir(), 2, 1, 1.25) -- 1g 2s 6d barrage
			elseif mKey == 5 then qIdealBarrageSpiral(rpos(), u_rndInt(8, 12), 12, rdir(), 1, 1, 1.25) -- 1g 1s barrage
			elseif mKey == 6 and sides() == 10 then qSpiral(rpos(), 1, 4, 5, 3, "alt"){2}{2}{2}(1.25) -- 3w 2g corner spiral/x3r
			elseif mKey == 7 and sides() == 9 then qSpiral(rpos(), 1, 6, 3, 1, "alt"){1}{1}{1}(1.25) -- 1w 2g triple spiral/x3r
			end
		end
	end

	l_setDelayMult(1)
	l_setDelayInc(0.0)
	l_setFastSpin(0.0)

	l_setIncTime(10)

	l_setRadiusMin(72)
	l_setPulseMin(72)
	l_setPulseMax(72)

	l_setBeatPulseMax(0)

	l_enableRndSideChanges(false)
	a_syncMusicToDM(false)
	
	a = 1 --see onIncrement()

	startSpeed = l_getSpeedMult()
	startSize = l_getRadiusMin()
end

music = diff == 1 and "Nu Slumber" or 
diff == 2 and "what we did in the desert" or
diff == 3 and "ghost" or
diff == 4 and "Pull The Trigger" or
diff == 5 and "With All Its Complexities" or
diff == 6 and "Storm in aeternum"

artist = diff == 1 and "Kaizo Slumber" or 
diff == 2 and "eightiesheadachetape" or
diff == 3 and "DJ Kuroneko" or
diff == 4 and "Bkode" or
diff == 5 and "Namii" or
diff == 6 and "freshtildesu"

-- onLoad is an hardcoded function that is called when the level is started/restarted
function onLoad()
	
	if DIFFICULTY == 0.98 then
		a_setMusic("pl_098")
		a_setMusicSegment("pl_098", u_rndInt(0,2))
		e_messageAdd("\n\nDIFFICULTY \n\n0.98 -- CHILL", 120)
	elseif DIFFICULTY == 0.99 then
		a_setMusic("pl_099")
		a_setMusicSegment("pl_099", u_rndInt(0,2))
		e_messageAdd("\n\nDIFFICULTY \n\n0.99 -- CASUAL", 120)
	elseif DIFFICULTY == 1.00 then
		a_setMusic("pl_100")
		a_setMusicSegment("pl_100", u_rndInt(0,4))
		e_messageAdd("\n\nDIFFICULTY \n\n1.00 -- NORMAL", 120)
	elseif DIFFICULTY == 1.01 then
		a_setMusic("pl_101")
		a_setMusicSegment("pl_101", u_rndInt(0,1))
		e_messageAdd("\n\nDIFFICULTY \n\n1.01 -- TOUGH", 120)
	elseif DIFFICULTY == 1.02 then
		a_setMusic("pl_102")
		a_setMusicSegment("pl_102", u_rndInt(0,1))
		e_messageAdd("\n\nDIFFICULTY \n\n1.02 -- CRUEL", 120)
	elseif DIFFICULTY == 1.03 then
		a_setMusic("pl_103")
		a_setMusicSegment("pl_103", u_rndInt(0,1))
		e_messageAdd("\n\n\t\tDIFFICULTY \n\n\t\t1.03 -- NIGHTMARE \n\n <<BLAME MANIAC FOR THIS ONE>>", 120)
	end
	
	shuffle2(keys)
	shuffle2(useSide)
	l_setSides(useSide[a])
	
	l_addTracked("music","Music")
	l_addTracked("artist","Artist")
	
	e_waitUntilS(10*(6+diff))
	e_eval([[e_messageAddImportantSilent("MAX ROTATION", 120)]])
end

-- onStep is an hardcoded function that is called when the level timeline is empty
-- onStep should contain your pattern spawning logic
b = 0
function onStep()
	addPattern(keys[index])
	index = index + 1

	if index - 1 == #keys then
		index = 1
		shuffle2(keys)
	end
	
	--need to do this because in onload the side change happens after the offset
	if b == 0 and DIFFICULTY == 1.00 then
		s_setBGRotationOffset(180/l_getSides())
	end
	
	b = b + 1
end

-- onIncrement is an hardcoded function that is called when the level difficulty is incremented
function onIncrement()
	
	a = a + 1
	if a > #useSide then
		a = 1
		shuffle2(useSide)
	end
	l_setSides(useSide[a])

	if DIFFICULTY == 1.00 then
		s_setBGRotationOffset(180/l_getSides())
	end

end

-- onUnload is an hardcoded function that is called when the level is closed/restarted
function onUnload()
end

--local INPUT_BOOL = true
-- onInput is a hardcoded function invoked when the player executes input

currentBGangle = 0
rotationSpeedBG = 0
function onInput(mFrameTime, mMovement, mFocus, mSwap)

	if DIFFICULTY == 1.02 then
		if mMovement ~= 0 then
			rotationSpeedBG = l_getRotationSpeed() --mMovement
			currentBGangle = currentBGangle + (rotationSpeedBG + l_getRotationSpeed()) * 10 * mFrameTime
			s_setBGRotationOffset(currentBGangle)
		else
			rotationSpeedBG = 0
			currentBGangle = currentBGangle + (rotationSpeedBG + l_getRotationSpeed()) * 10 * mFrameTime
			s_setBGRotationOffset(currentBGangle)
		end
	end
end

-- onUpdate is an hardcoded function that is called every frame
k = 0
--currentBGangle = 0
--rotationSpeedBG = 0
function onUpdate(mFrameTime)
	if DIFFICULTY == 1.01 then
		k = k + 1
		if k % 10 == 0 then
			s_setBGRotationOffset(360*u_rndInt(0,l_getSides())/l_getSides())
		end
	end
end

-- onPreDeath is an hardcoded function that is called when the player is killed, even
-- in tutorial mode
function onPreDeath()
end

