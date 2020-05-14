import SwiftUI

public class StaticGrid: ObservableObject, Grid {
    public subscript(x: Int, y: Int) -> CellState {
        get {
            if (x>width - 1 || x<0 || y>height - 1 || y<0){
                return .dead
            }
            return state[x][y]
        }
    }
    
    /// The width of the grid
    public var width: Int{
        state.count
    }
    /// The height of the grid
    public var height: Int{
        width > 0 ? state[0].count : 0
    }
    
    private var state: [[CellState]]
    
    required public init?(width: Int, height: Int){
        if (width <= 0 || height <= 0){
            return nil
        }
        state = [[CellState]](repeating: [CellState](repeating: .dead, count: 5), count: 5)
        state[1][2] = .alive
        state[2][1] = .alive
        state[2][2] = .alive
        state[2][3] = .alive
        state[3][2] = .alive
    }
    
    public func iterate() {
        // does nothing. it's static!
    }
}
