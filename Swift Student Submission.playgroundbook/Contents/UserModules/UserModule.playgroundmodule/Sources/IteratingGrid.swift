import SwiftUI

public class IteratingGrid: ObservableObject, Grid {
    public subscript(x: Int, y: Int) -> CellState {
        get {
            if (x>width - 1 || x<0 || y>height - 1 || y<0){
                return .dead
            }
            return state[x][y]
        }
        set {
            if (x>width - 1 || x<0 || y>height - 1 || y<0){
                return 
            }
            state[x][y] = newValue
        }
    }

    private var state: [[CellState]]
    
    required public init?(width: Int, height: Int){
        if (width <= 0 || height <= 0){
            return nil
        }
        state = [[CellState]](repeating: [CellState](repeating: .dead, count: height), count: width)
    }
    
    /// The width of the grid
    public var width: Int{
        state.count
    }
    /// The height of the grid
    public var height: Int{
        width > 0 ? state[0].count : 0
    }
    
    /// Iterate the grid using the standard rules of cellular automata/Conway's Game of Life
    public func iterate(){
        var newCells = state // array of value type is a value type, with copy-on-write
        for x in 0..<newCells.count{
            for y in 0..<newCells[x].count{
                newCells[x][y] = iteratedCellState(x: x, y: y)
            }
        }
        objectWillChange.send()
        state = newCells
    }
    
    
    public func iteratedCellState(x: Int, y: Int) -> CellState {
        var neighborLiveCount = 0
        let currentState = self[x, y]
        
        if self[x-1, y-1] == .alive{
            neighborLiveCount += 1
        }
        if self[x, y-1] == .alive{
            neighborLiveCount += 1
        }
        if self[x+1, y-1] == .alive{
            neighborLiveCount += 1
        }
        if self[x-1, y] == .alive{
            neighborLiveCount += 1
        }
        if self[x+1, y] == .alive{
            neighborLiveCount += 1
        }
        if self[x-1, y+1] == .alive{
            neighborLiveCount += 1
        }
        if self[x, y+1] == .alive{
            neighborLiveCount += 1
        }
        if self[x+1, y+1] == .alive{
            neighborLiveCount += 1
        }
        
        switch neighborLiveCount {
        case 0,1: // If they have fewer than two neighbors, they die of starvation
            return currentState.decrease()
        case 2: // If they have two neighbors and are alive, they stay alive
            return currentState == .alive ? .alive : currentState.decrease()
        case 3: // If they have three neighbors, they either stay alive or one is 'born' there.
            return .alive
        default: // If they have more than three neighbors, they die of overpopulation
            return currentState.decrease()
        }
    }
}