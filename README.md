# mobile-ios-game
For Mobile Game Development Class

## Game Design
### Objective
A string of bubbles snake down the screen in a fixed pattern. The objective is to clear the bubbles in the string, until the entire string is cleared. 

### Gameplay Mechanics
~~A vertical match-3 Zuma clone.~~ You shoot bubbles from the bottom of the screen to the string of bubbles, and if the hit spot ends up with a string of more than 3 bubbles of the same color, the portion with the same color will be cleared, and the part of the bubble string that's in the head will rewind, bouncing back slightly.

There are special bubbles that, when cleared, will give powerups, like extra time, rewind string, bombs, color changers, stripe, fish, ~~(yes I played too much candy crush)~~ etc.

### Level Design
A few pre-generated levels that feature a fixed pattern. The first few level will have limited color bubbles, and one or 2 power ups will be highlighted in each level.

## Technical
### Scenes
* Main Menu (needs continue button to avoid level select when possible)
* Level Select
* Level
* Gameplay

### Controls/Input
* Vertically held phone, tap based controls
  * Tap to shoot in direction

### Classes/CCBs
* Scenes
  * Main Menu
  * Level Select
  * Level
  * Gameplay
* Nodes/Sprites
  * Entity (abstract superclass)
    * Shooter
    * Line
  * WorldObject (abstract superclass)
    * Bubble
    * Effect
    * DeathPortal


## MVP Milestones
### Week 1 (2/18 - 2/24/2015) _finishing the playable build_
* Implement a single level
  * Moving bubble queue
    * Collision detection 
  * Bubble shooter 
    * tap to shoot
* Control scheme for player

### Week 2 (2/25 - 3/3/2015) - _finishing a better playable build_
* Implement 

### Week 3 (3/3 - 3/10/2014)
* Finish and polish rewind implementation


### Week 4 (7/28 - 8/1/2014) - _finishing core gameplay_


### Week 5 (8/4 - 8/8/2014)

### Week 6 (8/11 - 8/15/2014) - _finishing the polish_
