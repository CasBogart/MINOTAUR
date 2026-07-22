Game made for the SKG'26 Jam. No expectations of winning anything but it'll be fun lmao, this is mostly a timeline of my progress atm, might update later

12am 7/18/26
good morning i am both stupid and insane lets get this bagggg

1220am
sprite sheet for character done importing into godot now + making project. prob should have done that earlier

1230am
sprite sheet implemented, not yet animated, project set up + labyrinth code added and made a singleton, gonna pace for a bit yayyyyyyyy

2am
character animated and some labyrinth issues sorted out

330am
character spritesheet fixed, was a bit wonky before and would transition weird.

4am
maze collisions functional and applied automatically

6am
oughhhh im awake again, minotaur sprite created and working on navigation, flags and signalbus made singletons

1130am
i fell asleep again but made the player statemachine, should work now + added sprint mechanic
rudimentary pathfinding algo is working, need to do minotaur state machine as well

2pm
cant get exit to work automatically so im taking a break

230pm
nevermind i got it working, actually taking a break now

3pm
maze is now seeded, still need to make seeds time/date-related but that can be a different problem later

1130pm
I spent like an hour trying to figure out a main menu, didn't work so now I'm doing something different

12pm 7/19/26
i did fucking nothing last night lets get it

11pm
minotaur navigation working, has idle wander and pursue states, need to add in lantern functionality

130am 7/20/26
mouse has custom cursor, for the record i did want it animated and don't care about mixels at this point

245am
minotaur now has search area, will enter pursuit if player is too close and not behind a wall

9am
fell asleep again lmao, lantern now casts shadows

12pm
lantern doesn't cast shadows anymore, was cool but hurt my eyes
improvements to minotaur navigation system, can now enter pursuit if noticed by raycast 
(i could probably improve it, technically i don't think i need the collisionshape but whatever)

12am 7/22/26
oughhhhhhhhhh

1am
minofollow now actually actually done, should follow lantern for a while + minopursue normalized lmao
might need to check if lantern or player takes priority (might be important? but idrc also)

4am
minotaur has been modelled, needs rigged and given material but we're good for the moment
need to figure out ik in godot too
got rid of line at beginning of readme saying this took two days no the fuck it didn't

!!!!!!!!!!!!!TO-DO!!!!!!!!!!!!!!!!
- map + icons
(this should just be getting a copy of the tilemaplayer and putting it on a ui node or something)

- main menu, level select, settings, score ui, high scores
(just tedious)

- randomize minotaur spawn
(should already be a function in labyrinth to find a corner, so just modify that a bit)

- minotaur animation + ik
(this is gonna be rough but w/e)

- rest of 3d implementation
(player hand + lantern (might just be more pixel art tbh), 3d maze (again, pull from tilemap, keep floor texture same as 2d and basic tiling walls w fade from top))

- flags
(defined, not implemented, shouldn't be more that 20 min)

- vfx (normal, none, low contrast)

- music (normal, chase, normal3d, chase3d, menu?)
(im gonna be in fl studio cooking up straight bullshit)

- sfx (walking, running, minowalk, minorun, lanterninteract, buttoninteract, minotaur sounds?)

- web compatibility
(no idea)
