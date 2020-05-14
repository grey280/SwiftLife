//#-hidden-code
import PlaygroundSupport
import SwiftUI
//#-end-hidden-code
/*:
 # What do cells do?
 They're a very simple imitation of life. Left alone, they get lonely and die. (It's very sad!)

 But when they're with others, things get more interesting.

 If they've got two or three neighbors, they're happy, and stay alive!

 If there are three living cells near an empty space, a new cell is born there. (For cells, it's The Birds, The Bees, and The Bats.)

 If a cell has more than three neighbors, though, that's too many, and they can't get any food, and starve.


 
 All of this happens on a very specific time scale, a 'tick'.
 
 You can watch it happen - this `RandomGrid` picks random spots for cells to appear at the start.
 */
let grid = RandomGrid(width: 45, height: 45)!
PlaygroundPage.current.setLiveView(GridView(grid: grid, tickSpeed: 0.5))