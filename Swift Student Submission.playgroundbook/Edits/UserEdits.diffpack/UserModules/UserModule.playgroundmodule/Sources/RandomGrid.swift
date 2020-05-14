import SwiftUI

func weightedCoinFlip() -> Bool {
    let coinFlip = Int(arc4random_uniform(6))
    switch coinFlip {
        case 0...4:
        return false
        default:
        return true
    }
}

public class RandomGrid: ObservableObject, Grid {
    public subscript(x: Int, y: Int) -> CellState {
        get {
            var nX = x, nY = y
            if wrap{
                assertionFailure()
                if x>=width{
                    nX = 0
                }
                if x<0{
                    nX = width-1
                }
                if y>=height{
                    nY = 0
                }
                if y<0{
                    nY = height-1
                }
            }else{
                if (x>width - 1 || x<0 || y>height - 1 || y<0){
                    return .dead
                }
            }
            return state[nX][nY]
        }
    }

    private var state: [[CellState]]
    var wrap: Bool
    
    required public init?(width: Int, height: Int){
        if (width <= 0 || height <= 0){
            return nil
        }
        state = [[CellState]](repeating: [CellState](repeating: .dead, count: height), count: width)
        
        for x in 0..<width{
            for y in 0..<height {
                state[x][y] = weightedCoinFlip() ? .alive : .dead
            }
        }
//          cells = [[Bool]](repeating: [Bool](repeating: false, count: y), count: x)
        
        wrap = false
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
    
    
    private func iteratedCellState(x: Int, y: Int) -> CellState {
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
