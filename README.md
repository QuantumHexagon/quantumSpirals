- [Introduction](#introduction)
- [Ideal Barrage Spiral](#ideal-barrage-spiral)
  - [**Examples**](#examples)
- [Connecting Spiral](#connecting-spiral)
  - [**Examples**](#examples-1)
- [Spiral](#spiral)
  - [**BUT THERE’S MORE**](#but-theres-more)
  - [**BUT WAIT THERE IS MORE**](#but-wait-there-is-more)
  - [**BONUS MEME: NEW PATTERN TYPE**](#bonus-meme-new-pattern-type)
  - [**EXAMPLES**](#examples-2)
  - [**Limitations**](#limitations)
- [Miscellaneous Function](#miscellaneous-function)
- [FAQ](#faq)
- [Acknowledgements](#acknowledgements)

# Introduction

This is a user-friendly guide for total noobs on how to use these spiral patterns. It consists of 3 patterns designed around the principle of holding through them, instead of the current situation of sometimes needing to tap through barrage spirals or wall hugging when holding through spirals.

# Ideal Barrage Spiral

`qIdealBarrageSpiral(position, times, dirChange, direction, step, gap, spacing)`

This function creates a barrage spiral that is spaced perfectly to the standard movement speed of the player. It has 7 input variables:

- `position`
  This is the starting side on which the *gap* appears. If you put `nil` it will automatically generate a random side. You may also enter functions such as [`rpos()`](#miscellaneous-function) which I have defined in the file, or any similar function. Wall positions go from 0 to the number of sides - 1.

- `times`
  The number of barrages to generate.

- `dirChange`

  This controls direction changes in the barrage spiral. You may type a number here such as 4 which means every 4 walls it will change direction. You may also input a table {a,b} which will then provide a random integer in that range. (The first number is inclusive, the second is exclusive, so {2,5} means 2, 3, and 4 but not 5.) It also works if you have just one number in the table: {4} works just as well.
  > **Note:** To disable direction changes, make `dirChange` greater than times.

- `direction`


  This will determine whether the pattern goes clockwise or anticlockwise. CLOCKWISE = 0, ANTICLOCKWISE = 1. The function [`rdir()`](#miscellaneous-function) can be used to randomize the direction. 
  > **Note:** Directions are 0 and 1 in these patterns, compared to 1 and -1 like Vee’s directions.

- `step`

  This determines the side distance between wall gaps. If you enter a number bigger than half way around the shape, it converts it into a smaller number in the opposite direction: Enter a step of 4 on a hexagon clockwise and it will appear 2 steps anticlockwise.

- `gap`

  This changes the size of the gap, which appear in the direction that is set.

- `spacing`

  This is a multiplier for how far away the next pattern will be after this. A spacing of 1 means you have just enough time to reach the opposite side, higher numbers are kinder. 
  > **Note:** A spacing less that 1 will generally make the pattern tighter than is possible. (There are situations where it may be possible.)

## **Examples**

These should help if you’re still a little unsure:

>`qIdealBarrageSpiral(position, times, dirChange, direction, step, gap, spacing)`

- `qIdealBarrageSpiral(rpos(), 10, 10, rdir(), 1, 1, 2)`

  Starting at a random position, spawn 10 walls in a random, constant direction with a single side gap and 1 side step for each successive wall. Twice the time needed to reach the reach the opposite side (so quite comfortable).

- `qIdealBarrageSpiral(3, 6, 6, 1, 2, 2, 1.5)`

  With the first gap at position 3, spawn 6 walls in a clockwise direction with a 2 side gap in each wall and step of 2 between each successive wall, and 1.5x the time needed to reach the reach the opposite side.

- `qIdealBarrageSpiral(rpos(), 12, 6, 0, 1, 2, 1.5)`

  Random start position, spawn 12 walls with a direction change 6 walls in, in an anticlockwise direction, gap size of 1, step of 2 and 1.5x pattern spacing.

- `qIdealBarrageSpiral(rpos(), rInt(8,12), {3, 5}, rdir(), 1, 2, 1.25)`

  Random start position, spawn a random number between 8 and 12 walls, direction change a random number between 3 and 5, random direction and gap size of 1, step of 2 and 1.25x pattern spacing. 

- `qIdealBarrageSpiral(rpos(), rInt(8,16), {3, 5}, rdir(), rInt(1,3), rInt(1,3), rInt(1,2))`

  Even I don't know what this does...


# Connecting Spiral

`qConnectingSpiral(times, delayMult, position, direction, width, gap, spacing)`

This is a weird idea I had that I spun off into its own thing. It smoothly connects the sides of the walls of a spiral to each-other. **It is only partially working**. Both the delays are slightly broken and the walls currently unintentionally kill you if you touch them (which is a problem with skewed walls in general). There are also 7 input variables, defined largely as above but also:

- `times, position, direction, gap, spacing`

    All the same as the previous descriptions.

- `delayMult`

    This is set so that 0 = theoretical minimum (ultra tight) and 1 = ideal (aligns with movement of player). It has not been properly calculated to account for the skewed walls and numbers close to 0 will kill you. 

- `width`

    This is the wall width in sides of each "strand" of spiral. Due to the way the walls are constructed, currently only widths of 1 are supported.

> **Note:** Make sure the sum of width and gap adds to a number that divides into the side count!

## **Examples**

>`qConnectingSpiral(times, delayMult, position, direction, width, gap, spacing)`

> **Important:** Only width = 1 works as intended.


- `qConnectingSpiral(10, 1, rpos(), rdir(), 1, 2, 2)`  
  (on a hexagon)

  Ten walls with delay = 1 (aka ideal delay), with random initial direction and position, spiral width being 1 side and the the next two sides being a gap.  

  Since width + gap = 3, there are two copies of this spiral on a hexagon, making this a double spiral. It has a pattern spacing of twice the critical value.  
  
  This pattern will also generate correctly on any side count divisible by 3, increasing the number of strands by 1 each multiple of 3.

- `qConnectingSpiral(winding(2.5), 1, rpos(), rdir(), 1, sides() -1, 2)`
  (any side count)

  You’ll notice two things here, a winding function instead of times and a sides function in the gap variable.  

  The [winding function](#miscellaneous-function) is another way to define how many walls you want, by asking how many times do you want to wrap around the shape. 

  In this case, the strand makes 2.5 revolutions (there will be more walls spawned as you increase the side count). Its a bit buggy and I don’t even use it all the time but I thought I’d throw it in this example because it can be useful.  

  The sides function is simply a shorter l_getSides(). Adding a sides function into a spiral means it can work on multiple side counts without needing to make a specific pattern for each.  

  This pattern spawns 2.5 windings of a single strand (width = 1, gap = sides()-1 so width + gap = sides() and so one copy fits around the polygon) on any side count.

# Spiral

`qSpiral(pos, scale, times, size, width) {step} (spacing)`

This is by far the most complex of the patterns. My original code was convoluted and broken, so Syyrion is responsible for this more advanced code based on what I was trying to do, he did it for the memes and it should not be considered "good coding". There are 8 parameters.


> _Don't do this. Don't write a function like this. This is syntax abuse and a poor effort in avoiding OOP._  
>-Syyrion
 
> **Note:** The parameter names differ from previous patterns

- `pos`  
  This functions the same as the position variable in the previous functions.

- `scale`  
  This works not unlike ‘delayMult’, but there are some important differences. It has been mathematically calculated so that a scale of 1 always aligns with the movement speed of the player - you can’t die while holding if you manage to successfully enter a pattern, so no more broken spirals. A delay of 0 is equal to the theoretically minimum possible delay of walls; the only way to survive this is to wall hug the entrance, you will then scrape the inner edge of the last wall. entering a number between 0 and 1 will go somewhere in the middle. IMPORTANT DIFFERENCE: if you enter a number bigger than 1, it instead of continuing the scaling, it instead acts as a multiplier on the ideal value 1. This makes spiral delay easier to harmonise between patterns.

- `times`  
  This works exactly the same as times does in other function with 1 important change. IMPORTANT DIFFERENCE: when "step" (see below) is set to a number above 1, it instead counts the number of whole steps.

- `size`  
  This is the side width of the repeating section of walls; the sum total of the side-width of the walls and the side-width of the gap before you repeat. For example, if you have a size of 3, you will get two copies around a hexagon.

- `width`  
  This is the side-width of the wall section only. If you have an octagon with a size = 4, a width of 1 will give you skinny walls of 1 side width, with a big gap of (4 - 1) = 3. If you were to set width to 2 while keeping size at 4, you will instead get thicker walls of width 2, and a smaller gap of (4 - 2) = 2. For obvious reasons, width needs to be less than the total size, if it is 1 less than size it is a special case which will be covered further down.

- `step`  
  if you look carefully, you will see that step is enclosed by curly brackets { } instead of normal ones ( ). This is because this is a table, meaning you can add multiple numbers here. Step controls the shift in sides before spawning the next copy of the spiral. a step of {1,2} means the first wall after the initial wall is 1 step shifted as with most spirals, but the wall after that is shifted by 2 sides. Once it reaches the end of the table it loops until all walls are done. Make sure your step combination combines with size/width well, it is easy to make an impossible pattern or one has sides you can stand in unharmed! General guideline is: don’t make any number in step greater than the width size. This feature is only useful on higher side counts.

- `spacing`  
  same as in previous patterns, it is a multiplier of the minimum time to get to the opposite side of the shape (the furthest away the next opening could be).

## **BUT THERE’S MORE**

you can stack qSpirals together. This is done instead of directly adding direction changes mid spiral for a few reasons, one being the ability to attach different spirals together.

`qSpiral(pos, scale, times, size, width) {step} (spacing)`

turns into

`qSpiral(pos, scale, times, size, width) {step} ({step}, times, size, width) (spacing)`

This second set of brackets defines a new spiral connected to the last one. Position is automatically calculated so isn’t necessary, and scale doesn’t look nice nor seems like it’d be used to stack spirals so it was removed as well. These second values override the values of the previous one in the next spiral. YOU CAN OMIT INPUTS IF THEY ARE AT THE END - for example, if you only want to change the times variable, you still need to input step, but you can leave size and width off the end. At the very least, you must put step there if you want another spiral to spawn:

`qSpiral(pos, scale, times, size, width) {step} {step} (spacing)`,

You can keep adding more extra terms if you want with a spacing on the end:

`qSpiral(pos, scale, times, size, width) {step} ({step}, times) ({step}, times, size, width) {step} (spacing)`

and so on.

## **BUT WAIT THERE IS MORE**

You might have noticed that there isn’t a variable that determines the direction it goes yet. This is because it’s a bit more complicated than in previous functions AND is optional, it can be omitted off the end and it will default to "none". In other words, if you just omit it, it will randomly pick a direction and stick with it.

`qSpiral(pos, scale, times, size, width, dirmode) ({step}, times, size, width, dir) (spacing)`

The direction mode can only be specified at the start of the spiral. The parameter `dir` in subsequent spirals will override the direction mode behavior and force a certain direction. (`false` for clockwise, `true` for anticlockwise, `nil` for normal behavior.)

|Mode|Starting direction|Behavior
|-|-|-
|`"alt"`|Random|Always change direction on next iteration.
|`"rand"`|Random|Randomly change direction on next iteration.
|`"none"` or `nil`|Random|Do not change direction on next iteration.
|`"cw"`| Clockwise|Do not change direction on next iteration.
|`"ccw"`| Anticlockwise|Do not change direction on next iteration.

> Alternating looks the nicest in my opinion.

## **BONUS MEME: NEW PATTERN TYPE**

- Corner Spirals

If you have a max step size equal to your gap size (size - width), you will end up with a spiral where you must pass through the corners of the walls. This is only possible because it’s been calculated mathematically, as if you were to construct a pattern like this normally it would kill you without a considerable amount of fine tuning. These can only work when the scale is set to exactly 1, so whatever you have entered as the scale gets converted to 1 in this situation.

## **EXAMPLES**

>`qSpiral(pos, scale, times, size, width) {step} (spacing)`

- `qSpiral(rpos(), 3, 12, 3, 1) {1} (3) --(on a hexagon)`

    starting at a random position, spawn (at 3x ideal delay) 12 walls, a side size of 3 (6 sides/3 sides for pattern = 2 copies of pattern), with the wall side thickness being 1 side. The direction tag is omitted so the default of a random direction is applied. The step is 1, and the pattern spacing is 3.

- `qSpiral(4, 1, 10, 5, 3, "cw") {1} (2) --(on a pentagon)`

    Starts with a gap at position 4, has ideal delay, 10 walls with a 1 copy of the side size and 3 of them being walls, direction clockwise, step is 1 and has pattern spacing of 2.

- `qSpiral(rpos(), 0.5, winding(2), sides(), sides() -2) {1} (1.5) --(on any side count)`

    The delay is 0.5 which means it will kill you if the enter the pattern too late. The winding function (see connecting spiral example 2) is useful here to ensure there are enough walls on higher side counts (if there aren’t enough walls the delay calc can’t work properly when less than 1)  

    The size = the side count so there will only ever be one copy, with the width indicating there will always be 2 free sides with the rest being walls.

- `qSpiral(rpos(), 1, 6, 2, 1) {1} (1) --(any even side count 6+)`

    This is a corner spiral; it spawns a wall then a gap, then shifts by 1 step. Looks like a checkerboard pattern. Remember that this will only work with zero pulse (skew can still work, you’ll get restricted to 1 direction only though)

- `qSpiral(rpos(), 1, 5, 6, 3) {1, 2} (1) --(12 sides)`

    Higher side count example of using variable steps, on even larger side counts there is more freedom to mess around.

- `qSpiral(rpos(), 1, 5, 30, 10) {1, 1, 6} (1) --(60 sides)`

    Very high side count example. Looks pretty cool right?

- `qSpiral(rpos(), 1, 4, 4, 2, "alt") {1} {1} (1) --(on a square)`

    Notice there are two steps here, so there are two spirals combined here. Since there is no extra detail they are of the same type and the "alt" addition shows that between them will be a direction change.

- `qSpiral(rpos(), 1, 6, 3, 1, "alt") {1} ({1}, 6, 3, 2) ({1}, 6, 3, 1) (1) --(on a hexagon)`

    This might look a bit scary but you just need to break it down. The first step is generating a 2 copies of a 3 size 1 width spiral, the second step increases the width to 2 and the final step brings it back to 1.


**Limitations**
---

- When combining spirals in the same direction, they don’t take into account the previous delays, meaning you have to calculate the wall offset by yourself. The practical result is that doing delays less than 0 is not recommended when combining as there will be no guaranteee that it is possible. I therefore recommend to keep things ideal when combining spirals. Things still don't fully work however: The below example is ideal, despite being 0.75 delay, because after 4 walls the new spiral is located in the same position as the last wall, essentially stretching the path. I think, but am not 100% sure that by multiplying your delay by (times-1) / times fixes the issue.

`qSpiral(rpos(), 0.75, 4, 4, 1) {1} {1} {1} (2) --(on an octagon)`

- You might see that some spirals have little points on their edges, that is due to the complicated way extra thickness was added to certain walls to cover up the tiny gaps between walls (it looks really ugly without doing this). Unfortunately the rules add unnecessary thickness to some places, but this doesn’t affect gameplay. 

- Corner spirals have one case where they will kill you. On a square, you get so close to the walls it triggers the collision detection and will kill you. Interestingly, you can survive in debug mode!

`qSpiral(rpos(), 1, 4, 2, 1) {1} (2) --(on a square)`

- While I’ve tried to ensure it doesn’t happen, there are some occasions that otherwise passable patterns don’t work because extra thickness was added in the wrong place. If you can design a set of conditions that works better, let me know!


# Miscellaneous Function

- `rpos()`  
  Shorthand for `getRandomSide()`. 
- `rdir()`  
  Returns 0 or 1.
- `rInt(a, b)`  
  Shorthand for `u_rndInt(a, b)`.
- `winding(n)`  
  Converts a number of full revolutions to repititions for certain patterns.

# FAQ

 **ALL OF YOUR PLASTIC RATIO DIFFICULTIES HAVE NO PULSE, SKEW ETC. WHY? DOES IT STILL WORK?**


Yes and no.

The main reason I didn’t have them in the spiral showcase levels, is because they limit design space. I go into the reasons below:

- **WALL SKEW**

    Initially I wanted to extend the current calculations to allow for skew walls. It certainly can be done, but it requires 8 different cases (2 directions * 2 positive-skew types * 2 negative-skew types). With the current code it just inflates things a lot, so I didn’t feel it was worthwhile. It might be more manageable to do this if this was converted to Object Oriented Programming. If you’d like to help out, I can provide you with the calculation concepts that I discussed at some length with Syyrion.

    As long as the skew doesn’t obstruct the progress of the player, there should be no effect on gameplay. If there is, it will become impossible at some scale. If you are prepared to code a bit, making sure the skew is in the direction of travel of the player through the pattern is a way to have larger skews without issue.

- **WALL ANGLE**

    If you set wall angle to make the wall smaller there will be no issue, if you make it bigger there will be no issue as long as its not far enough to hit the player. Making wall angle in the opposite direction to the player movement direction gives you more freedom, as long as you are prepared to micromanage skew according to direction of the spiral.

- **LEVEL PULSE (PULSE & BEATPULSE)**

    While beatpulse is easily understood as an increase in size of the central polygon, normal pulse is something that some are confused about. It is a simple effect created by doing two things:
    1. Increasing the size of the central polygon
    2. Zooming out the field of view proportionately so that visually, the central polygon is the same size. This makes the walls, polygon outline etc look thinner.

    How does this affect gameplay? If your player is being pushed outwards, you have the chance of hitting walls early during a pulse. In patterns where there are narrow gaps for you to pass, it will kill you.

**Question 2.**

Yes.

<!--
Sadly this feature never panned out.

    If you open up with game with console (you can find this in the game files next to the normal exe) and run a level with a qSpiral pattern, you’ll see a message pop up in the console as "SCALE LIMIT"

    This looks at the critical amount of space needed for you to be able to survive in the current pulse, letting you know that you can’t go below, say, 0.5 without causing problems.

    Corner spirals are viable ONLY if there is no pulse, since they are only passable with scale = 1. This will show as the scale limit being 1.
-->

# Acknowledgements

When I first started this project I didn’t even know how to code a function in lua. The fact I’ve managed to do as much as I’ve had is thanks in no small part to Syyrion. I knew what I wanted to do, I could do the mathematics behind it, but actually implementing it is a different question entirely. Even now, it is not great code (it works, but…). If you want to help make this even better, and perhaps more importantly make it more generalised with object oriented programming, I will be happy to provide any assistance I can! (which may not be much admittedly)

In particular, Maniac and Vipre have been important for the playtesting plastic ratio part of things, letting me know when what I did was a terrible idea (which was often) - They also helped me decide on the music selection. zX and The Sun XIX provided a minor supporting role for bits and pieces.

- Syyrion

- Maniac

- Vipre

- zX

- The Sun XIX