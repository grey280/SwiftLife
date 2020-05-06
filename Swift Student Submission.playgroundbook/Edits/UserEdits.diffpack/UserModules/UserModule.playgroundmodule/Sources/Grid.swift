import SwiftUI

enum GridState{
    case dead, alive, minusOne, minusTwo, minusThree, minusFour
}

func weightedCoinFlip() -> Bool {
    let coinFlip = Int(arc4random_uniform(6))
    switch coinFlip {
        case 0...4:
        return false
        default:
        return true
    }
}

//  extension GridState{
//      static func weightedRandom() -> GridState {
//          let coinFlip =  Int(arc4random_uniform(6) + 1)
//          switch coinFlip {
//              case 0...5:
//              return .dead
//              default:
//              return .alive
//          }
//      }
//  }

public class Grid: ObservableObject {
    private var state: [[GridState]]
    var wrap: Bool
    
    public init?(width: Int, height: Int){
        if (width <= 0 || height <= 0){
            return nil
        }
        state = [[GridState]](repeating: [GridState](repeating: .dead, count: height), count: width)
        
        for x in 0..<width{
            for y in 0..<height {
                state[x][y] = weightedCoinFlip() ? .alive : .dead
            }
        }
//          cells = [[Bool]](repeating: [Bool](repeating: false, count: y), count: x)
        
        wrap = false
    }
    
    /// The width of the grid
    var width: Int{
        state.count
    }
    /// The height of the grid
    var height: Int{
        width > 0 ? state[0].count : 0
    }
    
    /// Iterate the grid using the standard rules of cellular automata/Conway's Game of Life
    func iterate(){
        var newCells = state // array of value type is a value type, with copy-on-write
        for x in 0..<newCells.count{
            for y in 0..<newCells[x].count{
                newCells[x][y] = iteratedCellState(x: x, y: y)
            }
        }
        objectWillChange.send()
        state = newCells
    }
    
    /// Get the value of the cell at the given coordinates.
    ///
    /// - Parameters:
    ///   - x: x-coordinate to use. Zero-based.
    ///   - y: y-coordinate to use. Zero-based.
    /// - Returns: whether or not the cell at the given coordinates is 'alive'
    func cell(x: Int, y: Int) -> GridState{
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
    
    private func decreaseState(_ from: GridState) -> GridState {
        switch from {
            case .alive:
            return .minusOne
            case .minusOne:
            return .minusTwo
            case .minusTwo:
            return .minusThree
            case .minusThree:
            return .minusFour
            case .minusFour:
            return .minusFour // so we never fully fade out after having been alive - leaves nice trails, ideally
            case .dead:
            return .dead
        }
    }
    
    private func iteratedCellState(x: Int, y: Int) -> GridState {
        var neighborLiveCount = 0
        let currentState = cell(x: x, y: y)
        
        if cell(x: x-1, y: y-1) == .alive{
            neighborLiveCount += 1
        }
        if cell(x: x, y: y-1) == .alive{
            neighborLiveCount += 1
        }
        if cell(x: x+1, y: y-1) == .alive{
            neighborLiveCount += 1
        }
        if cell(x: x-1, y: y) == .alive{
            neighborLiveCount += 1
        }
        if cell(x: x+1, y: y) == .alive{
            neighborLiveCount += 1
        }
        if cell(x: x-1, y: y+1) == .alive{
            neighborLiveCount += 1
        }
        if cell(x: x, y: y+1) == .alive{
            neighborLiveCount += 1
        }
        if cell(x: x+1, y: y+1) == .alive{
            neighborLiveCount += 1
        }
        
        switch neighborLiveCount {
        case 0,1: // If they have fewer than two neighbors, they die of starvation
            return decreaseState(currentState)
        case 2: // If they have two neighbors and are alive, they stay alive
            return currentState
        case 3: // If they have three neighbors, they either stay alive or one is 'born' there.
            return .alive
        default: // If they have more than three neighbors, they die of overpopulation
            return decreaseState(currentState)
        }
    }
}
