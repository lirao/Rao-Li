# mobile-ios-game
For Mobile Game Development Class

## Game Design
### Objective
~~A string of bubbles snake down the screen in a fixed pattern. The objective is to clear the bubbles in the string, until the entire string is cleared.(Zuma clone)~~

Above design abandoned because physics and curve action is too hard to implement. Bezier actions??? Trying to push objects along a curve at constant speed?? Insane! 

No physics game idea:  
Love Sim + Match 3 P&D style   
You are a slime  
You have another slime  
The other slime is angry with you  
Play match-3 (Puzzle Dragon style?) to make it happier  
Affection gauge = score  
Food gauge too low = death    

### Gameplay Mechanics
Match 3 tiles in a 6x6 grid by sliding a finger. You can rack up combos by drawing lines, Puzzle & Dragon style.

Sliding movement consumes food gauge. If it hits 0, game over.

Block of 3 or more clear and have an effect based on "level"




### Level Design
Each "level" is a different pair of (gender neutral) slimes. Each pair has different effects in diff orbs, e.g. otaku slime like the sword/cosplay orbs, heal slime like the heal orbs (metal slimes eat sword)
 
Example levels (different moe pairings)  
blue slime and green slime (the most generic)  
water slime and fire slime 自古红蓝  
heal slime and metal slime 温暖治愈+三无  
tsundere slime and megane slime  


## Technical
### Scenes
* Main Menu (needs continue button to avoid level select when possible)
* Level Select
* Level
* Gameplay

### Controls/Input
* 6x6 grid that fill the bottom part of the screen
* Slide finger to move a single orb around. 
	* upon collision with another orb, the blob will swap places with the another orb
	* Movement action does not end until finger leave the screen, so long combos are possible.
	* Orb clearing and collapse is only done after finger leave screen 

### Classes/CCBs
* Scenes
  * Main Menu
  * Level Select
  * Level/Grid
  * Gameplay
* Nodes/Sprites
  * Entity (abstract superclass)
    * Orb
  * WorldObject (abstract superclass)
    * SlimeA
    * SlimeB
    * HealthBar
    * AffectionBar
    * IAP items


## MVP Milestones
### Week 1 (2/18 - 2/24/2015) _finishing the playable build_
* Implement the match 3 (following online example)
  * Scoring code and panel

### Week 2 (2/25 - 3/3/2015) - _finishing a better playable build_
* Implement 

### Week 3 (3/3 - 3/10/2014)
* Finish and polish rewind implementation


### Week 4 (7/28 - 8/1/2014) - _finishing core gameplay_


### Week 5 (8/4 - 8/8/2014)

### Week 6 (8/11 - 8/15/2014) - _finishing the polish_
