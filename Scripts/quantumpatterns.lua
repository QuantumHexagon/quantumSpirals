-- * Run this dependency script since some constants and functions are duplicated here
-- u_execDependencyScript("library_extbase", "extbase", "syyrion", "common.lua")
u_execDependencyScript("library_extbase", "extbase", "syyrion", "utils.lua")

-- * Unnecessary. Provided in the common.lua script
-- THICKNESS = 40 --typical wall thickness

-- * These values are used quite often so I've put them into a single function and variable
-- Number of frame to make one full revolution
DELAYCONSTANT = 800 / 21

--its shorter
function rdir()
--my directions are 0,1 and vees are -1, 1.
	return u_rndInt(0, 1)
end

function rpos()
	return rInt(0, sides())
	--return getRandomSide()
end

function sides()
	return l_getSides()
end

-- "Shuffles" an array by swapping elements randomly across a table.
function shuffle2(t)
    for i = #t, 1, -1 do
        local j = u_rndIntUpper(i)
        t[i], t[j] = t[j], t[i]
    end
end

-- * delayMult defaults to 1 so passing nothing won't break anything
function getDelayAndSides(delayMult)
	delayMult = delayMult or 1
	local sides = l_getSides()
	return DELAYCONSTANT / sides * delayMult, sides
end

-- speedMult is a lie! actual speed of walls is below, along with true delay
-- 1.25 factor is due to vee's abitrary mods (specifically a factor of 5 and 0.25)
function trueSpeedMult()
	return l_getSpeedMult() * u_getDifficultyMult() ^ 0.65 * 1.25
end

-- just set delay to 0 to prevent the below interference. these patterns dont use it anyway.
function trueDelayMult()
	return l_getDelayMult() * u_getDifficultyMult() ^ 0.1
end

cWallEx = function (mSide, mExtra)
	local exLoopDir = 1
	if mExtra < 0 then exLoopDir = -1 end
	for i = 0, mExtra, exLoopDir do cWall(mSide + i) end
end


-- for ease of use
-- thickPulse = THICKNESS + l_getBeatPulseMax() + l_getRadiusMin() * (l_getPulseMax() / l_getPulseMin() - 1)
-- pulseContrib = l_getBeatPulseMax() + l_getRadiusMin() * (l_getPulseMax() / l_getPulseMin() - 1)
function pulseContribution()
	return l_getBeatPulseMax() + l_getRadiusMin() * (l_getPulseMax() / l_getPulseMin() - 1)
end

-- * Removed unnecesary parentheses
function thickPulse()
	return THICKNESS + pulseContribution()
end

--takes the base value and zooms out by factor.
function setZoom(factor, base1, base2, base3, base4)
	l_setRadiusMin((base1 or l_getRadiusMin()) / factor)
	l_setPulseMax((base2 or l_getPulseMax()) / factor)
	l_setPulseMin((base3 or l_getPulseMin()) / factor)
	l_setBeatPulseMax((base4 or l_getBeatPulseMax()) / factor)
end

-- * Reimplementation
function sideDistance(side1, side2)
	local offset = side1 - side2
	-- don't be an idiot and put sides count not in 0 to sides-1 range.
	return offset < 0 and math.min(offset + l_getSides(), -offset) or math.min(offset, l_getSides() - offset)
end

-- ! Depreciated
function gapDir(side1,side2)
	local interval = side1

	while not interval == side2 do
		interval = interval + 1
	end

	interval = interval - side1

	if interval == l_getSides()/2 then
		return 0 --opposite
	elseif interval == sideDistance(side1,side2) then
		return 1 --clockwise
	else
		return -1 --anticlockwise
	end
end

--this function allows you to set a winding amount rather than number of walls for qSpiral.
function winding(low, high)
	local sides = l_getSides()
	if low < 1 + (1/sides) then low = 1 + (1/sides) end
	if high == nil then high = low end
	
	return u_rndInt(math.floor(low * sides), math.floor(high * sides))
end

-- when you want random integers but dont want to type the number twice for constants. 
function rInt(low, high)
	if high == nil then
		return low
	else return u_rndInt(low,high)
	end
end

--IF YOU USE DELAYMULT, SET smoothLim TO 0. also, stay above 1. -> hardcore if you want lower.
-- * Formatting. Use an _ for a variable that isn't used. (You sometimes have to be careful if there are multiple _ variables)
function qDynamicRandomBarrage(times, smoothLim, delayMult)
	-- * You don't need to check whether the statement is equal to true. Just pass the return value directly
	if not smoothSailing(smoothLim) then return end
	local delay, sides = getDelayAndSides(delayMult)
	local side1 = getRandomSide()
	local side2 = side1 + u_rndInt(1, sides - 1)
	for _ = 0, times - 1 do
		cBarrage(side1)
		t_wait(delay * sideDistance(side1, side2))
		side1 = side2
		side2 = side2 + u_rndInt(1, sides - 1)
	end
	t_wait(delay * math.floor(sides / 2))
end

-- * Formatting. Use an _ for a variable that isn't used. (You sometimes have to be careful if there are multiple _ variables)
function qStaticRandomBarrage(times, delayMult)
	local delay, sides = getDelayAndSides(delayMult)
	local position = getRandomSide()
	for _ = 0, times - 1 do
		cBarrage(position)
		position = position + u_rndInt(1, sides - 1)
		t_wait(delay * math.floor(sides / 2))
	end
	t_wait(delay * math.floor(sides / 2))
end

function qHardcoreDynamicRandomBarrage(times,delayMult)
--delayMult goes between 0 and 1, 0 is tight and 1 is loose
	local DEL, sides = getDelayAndSides()
	local finalSideDelay = thickPulse() / 4 / trueSpeedMult()
	if DEL - finalSideDelay <= 0 then return end
	
	-- * Variable assigned immedietly
	local sideLim = sides % 2 == 0 and sides / 2 or (sides - 1) / 2
	local delay = 0
	local side1 = 0
	local side2 = getRandomSide()
	local direction = getRandomDir()
	local idealDelay = 0
	local minDelay = 0

	--sides are counted clockwise

	for _ = 0, times - 1 do
		side1 = side2
		direction = direction * -1
		side2 = side2 + u_rndInt(1, sideLim) * direction
		--side2 = side2 >= sides and side2 - sides or (side2 < 0 and side2 + sides or side2)
		side2 = side2 % sides

		cBarrage(side1)

		idealDelay = DEL * sideDistance(side1,side2)
		minDelay = DEL * (sideDistance(side1,side2) - 1)
		delay = minDelay + finalSideDelay + delayMult * (idealDelay - minDelay - finalSideDelay)

		t_wait(delay)
	end
	t_wait(DEL * math.floor(sides/2))
end

function qTunnel(times, delayMult, direction)
	local DEL, sides = getDelayAndSides()
	local trueMult = trueSpeedMult()
	local finalSideDelay = thickPulse() / (4 * trueMult)
	if DEL - finalSideDelay <= 0 then return end
	local delay = DEL * delayMult
	local position = getRandomSide()
	local toggle = -1 ^ direction
	--1 is right first, -1 is left first
	local idealDelay = 0
	local minDelay = 0

	--checks to see if pattern is possible
	for i = 0, times - 1 do
		if i ~= times - 1 then
			--1.05 multiplier added to overlap the walls.
			w_wall(position + sides - 1, 4 * trueMult * delay * 1.05)
		end

		cWallEx(position + toggle, (sides - 3) * toggle)

		toggle = toggle * -1

		idealDelay = DEL * (sides - 2)
		minDelay = DEL * (sides - 3)
		delay = minDelay + finalSideDelay + delayMult * (idealDelay - minDelay - finalSideDelay)
		t_wait(delay) --delay between walls
	end
	t_wait(DEL * math.floor(sides / 2)) --delay between patterns
end

function qConnectingSpiral(times, delayMult, position, direction, width, gap, spacing)
--only works right now with width = 1
--also delays are kinda busted. don't go too low.

	position = position or getRandomSide()
	direction = (-1) ^ direction or u_rndIntUpper(2)
	times = times - 1
	local idealDEL, sides = getDelayAndSides()
	-- * This needs further research     \/
	local minDEL = (times - gap)/(times - 1) * idealDEL * 1.01
	local resultDEL = lerp(minDEL, idealDEL, delayMult)
	
	local thickness = 4*trueSpeedMult() * resultDEL * (seamless and 1.1 or 1)
	local k = 0
	
	local createSpiral = function (p, i)
		t_eval(string.format([[l_setWallSkewLeft(%d)]], direction == 1 and thickness or 0))
		t_eval(string.format([[l_setWallSkewRight(%d)]], direction == 1 and 0 or thickness))
		w_wall(p + i, 0)
		t_eval(string.format([[l_setWallSkewLeft(%d)]], direction == 1 and 0 or -thickness))
		t_eval(string.format([[l_setWallSkewRight(%d)]], direction == 1 and -thickness or 0))
		w_wall(p + i, 0)
	end
	
	while k <= times do
		local p = k * direction + position
		for i = 0, sides - 1 do
			if i % (width + gap) < width then
				createSpiral(p, i)
			end
		end
		t_wait(resultDEL)
		k = k + 1
	end
	t_eval([[l_setWallSkewLeft(0)]])
	t_eval([[l_setWallSkewRight(0)]])
	t_wait(idealDEL * math.floor(sides/2) * spacing)
	return (k + position) % sides - direction
end

function qIdealBarrageSpiral(position, times, dirChange, direction, step, gap, spacing)
	local sides = l_getSides()
	local delay = 800/(21*sides)
	local remaining = times
	local position = position or getRandomSide()
	local dirChangeVar = (Filter.NUMBER(dirChange) and dirChange or rInt(dirChange[1], dirChange[2]))
	
	if step > math.floor(sides/2) then
		step = sides - step
		direction = direction + 1
	end

	if thicknessToFrames(THICKNESS) >= 0.9 * delay then 
		THICKNESS = framesToThickness(0.9 * delay)
	end

	while remaining >= dirChangeVar do

		for i = 0, dirChangeVar - 1 do
			position = position + step * ((-1) ^ direction)
			
			for j = 0, sides - 2 - (gap - 1) do
				cWall((position + j + 1) % sides)
			end
			
			t_wait(delay * step)
		end

		direction = direction + 1
		dirChangeVar = (Filter.NUMBER(dirChange) and dirChange or rInt(dirChange[1], dirChange[2]))
		remaining = remaining - dirChangeVar
	end


	for i = 0, remaining - 1 do
		position = position + step * ((-1) ^ direction)
		
		for j = 0, sides - 2 - (gap - 1) do
			cWall((position + j + 1) % sides)
		end
		
		t_wait(delay * step)			
	end
	

	t_wait(spacing*delay*(math.floor(sides/2)))
	THICKNESS = 40
end

local spiralmt = {
	__call = function (this, step, times, size, width, dir)
		-- 
		local mode = type(step)
		if mode == "number" then
			t_wait(FRAMES_PER_PLAYER_ROTATION * 0.5 * step)
			return
		end

		if type(times) == "number" and times > 0 and times % 1 == 0 then
			this.times = times
		end

		local validsize, validwidth = type(size) == "number" and size > 1 and size % 1 == 0, type(width) == "number" and width > 0 and width % 1 == 0

		if validsize then
			this.size = size
		end
		if validwidth then
			this.width = width
		end
		if (validsize or validwidth) and this.size <= this.width then
			error("Size must be greater than width.")
		end

		if dir == nil then
			this:dirmode()
		else
			this.dir = (dir and -1 or 1)
		end

		local steplen = #(mode == "table" and step or error("Argument #1 is not nil or a table."))
		local stepsum = 0
		for _, s in ipairs(step) do
			stepsum = stepsum + (type(s) == "number" and s >= 0 and s % 1 == 0 and s or error("Step values must be nonnegative integers.", 2))
		end
		if stepsum == 0 then
			error("Sum of step values must be greater than 0.", 2)
		end

		local del = getIdealDelayInFrames(this.sides) * (
			this.scale > 1
			and this.scale
			or (
				(1 - this.scale) * (stepsum * this.times - this.size + this.width - 1) / (this.times * steplen - 2)
				+
				this.scale * stepsum / steplen
			)
		)
		local th = framesToThickness(del)
		
		--[[
		DIDNT GET THIS TO WORK :(
		--need to work out for >1 delaymults!
		
		-- takes current delay difference from minimum
		local interval = del - ((stepsum * this.times - this.size + this.width - 1) / (this.times * steplen - 2))
		
		--compares interval to pulse
		if pulseContribution() > framesToThickness(interval) then
			print("ideal spiral not possible with this pulse")
			print(th)
			print("pulse: "..pulseContribution())
			print("interval: "..framesToThickness(interval))
		else
			local minPossible --calc minimum scale that is viable
			print("min scale: "..simplifyFloat(minimumPossible, 2))
		end
		--]]
		
		local unitpos = 0
		for j = 1, this.times do
			for i = 1, steplen do
				for subunitpos = 0, this.sides - 1 do
					local subunitmod = subunitpos % this.size
					if subunitmod < this.width then
						local addThick = (subunitmod < step[i] and (j ~= this.times or i ~= steplen) and 0 or 6)
						
						if subunitmod == 0 then
							addThick = 0
						else addThick = 6
						end
						
						if steplen == 1 and this.width == step[i] then
							addThick = 0
						end
						
						if this.width == 1 and this.size > 2 then
							addThick = 6
						end
						
						if j == this.times and dir == alt then
							addThick = 6
						end
						
						--these conditions were a pain in the ass to work out, still isn't perfect
						
						cWall((this.pos + unitpos + subunitpos * this.dir) % this.sides, th + addThick)
					end
				end
				t_wait(del)
				unitpos = unitpos + step[i] * this.dir
			end
		end
		this.pos = this.pos + unitpos - this.dir
		return this
	end
}

local directionmodes = {
	alt = function (this)
		this.dir = this.dir * -1
	end,
	rand = function(this)
		this.dir = getRandomDir()
	end,
	none = __NIL,
	cw = __NIL,
	ccw = __NIL
}

function qSpiral(pos, scale, times, size, width, dirmode)
	return setmetatable({
		sides = l_getSides(),
		pos = type(pos) == "number" and pos % 1 == 0 and pos or error("Position must be an integer.", 2),
		scale = type(scale) == "number" and scale >= 0 and scale or error("Scale must be between 0 and 1, inclusive.", 2),
		dirmode = directionmodes[dirmode or "none"] or error("Direction mode must be either nil, \"alt\", or \"rand\"."),
		dir = dirmode == "cw" and 1 or (dirmode == "ccw" and -1 or getRandomDir()),
		times = type(times) == "number" and times > 0 and times % 1 == 0 and times or error("Times must be a positive integer.", 2),
		size = type(size) == "number" and size > 1 and size % 1 == 0 and size or error("Size must be an integer greater than 1.", 2),
		width = type(width) == "number" and width > 0 and width % 1 == 0 and width or error("Width must be an integer greater than 0.", 2)
	}, spiralmt)
end