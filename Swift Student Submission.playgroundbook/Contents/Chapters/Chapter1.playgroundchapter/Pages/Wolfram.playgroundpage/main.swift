//#-hidden-code
import PlaygroundSupport
import SwiftUI
//#-end-hidden-code
/*:
 Now we're going to play around a bit. Let's feed in a cool pattern, instead of just letting it randomize.

 We're going to use Wolfram's [Rule 110](https://mathworld.wolfram.com/Rule110.html). It's a *different* kind of cellular automata; go ahead and tinker with the code below, or just watch it run.
 */
//#-editable-code


public class WolframGrid: IteratingGrid {
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

let grid = WolframGrid(width: /*#-editable-code*/45/*#-end-editable-code*/, height: /*#-editable-code*/45/*#-end-editable-code*/)!
let gridView = GridView(grid: grid, tickSpeed: /*#-editable-code*/0.5/*#-end-editable-code*/)
//#-end-editable-code
//#-hidden-code
PlaygroundPage.current.setLiveView(gridView)
//#-end-hidden-code