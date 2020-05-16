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
func weightedCoinFlip() -> Bool {
	//#-editable-code
    let coinFlip = Int(arc4random_uniform(6))
    switch coinFlip {
        case 0...4:
        return false
        default:
        return true
    }
    //#-end-editable-code
}

public class RandomGrid: IteratingGrid {
    required public override init?(width: Int, height: Int){
        if (width <= 0 || height <= 0){
            return nil
        }
        super.init(width: width, height: height)
        //#-editable-code
        for x in 0..<width{
            for y in 0..<height {
                self[x, y] = weightedCoinFlip() ? .alive : .dead
            }
        }
        //#-end-editable-code
    }
}

let grid = RandomGrid(width: /*#-editable-code*/45/*#-end-editable-code*/, height: /*#-editable-code*/45/*#-end-editable-code*/)!
let gridView = GridView(grid: grid, tickSpeed: /*#-editable-code*/0.5/*#-end-editable-code*/)
//#-hidden-code
PlaygroundPage.current.setLiveView(gridView)
//#-end-hidden-code