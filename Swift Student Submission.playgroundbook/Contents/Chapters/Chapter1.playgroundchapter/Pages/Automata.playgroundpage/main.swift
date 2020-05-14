//#-hidden-code
import PlaygroundSupport
import SwiftUI
//#-end-hidden-code
/*:
 # What is a cell?
 Think of a cell as a single pixel on one of those road signs: no fancy colors, just 'on' or 'off'.
 That's what a cell is: a square that's either on or off. (Well, we say 'alive' or 'dead', but same thing, really.)
 */

let grid = StaticGrid(width: 5, height: 5)!
PlaygroundPage.current.setLiveView(GridView(grid: grid))