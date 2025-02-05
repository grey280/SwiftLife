//#-hidden-code
import PlaygroundSupport
import SwiftUI
//#-end-hidden-code
/*:
Now we're going to play around a bit. Let's feed in a cool pattern, instead of just letting it randomize.

We're going to use Wolfram's [Rule 110](https://mathworld.wolfram.com/Rule110.html). It's a *different* kind of cellular automata; go ahead and tinker with the code below, or just watch it run.
*/

public class WolframGrid: IteratingGrid {
	required public override init?(width: Int, height: Int){
		if (width <= 0 || height <= 0){
			return nil
		}
		super.init(width: width, height: height)
		//#-editable-code
		// the Woflram Rule needs at least one cell alive to get started
		self[width-6, height-1] = .alive 
		//#-end-editable-code
	}

	override public func iteratedCellState(x: Int, y: Int) -> CellState {
		//#-editable-code
		if (y < height - 10){
			// above this row, go back to normal Cellular Automata
			return super.iteratedCellState(x: x, y: y)
		}
		if (y == height - 1){
			// in the very bottom rule, we do all the Wolfram calculations
			switch (self[x-1, y], self[x, y], self[x+1, y]){
				case (.alive, .alive, .alive):
				return self[x, y].decrease()
				case (.alive, .alive, _):
				return .alive
				case (.alive, _, .alive):
				return .alive
				case (.alive, _, _):
				return self[x, y].decrease()
				case (_, .alive, .alive):
				return .alive
				case (_, .alive, _):
				return .alive
				case (_, _, .alive):
				return .alive
				default:
				return self[x,y].decrease()
			}
		}
		// in between Cellular Automata-land and Wolfram-land, we just move the row up each time
		return self[x, y+1]
		//#-end-editable-code
	}
}

let grid = WolframGrid(width: /*#-editable-code*/65/*#-end-editable-code*/, height: /*#-editable-code*/65/*#-end-editable-code*/)!
let gridView = GridView(grid: grid, tickSpeed: /*#-editable-code*/0.5/*#-end-editable-code*/)
//#-hidden-code
PlaygroundPage.current.setLiveView(gridView)
//#-end-hidden-code