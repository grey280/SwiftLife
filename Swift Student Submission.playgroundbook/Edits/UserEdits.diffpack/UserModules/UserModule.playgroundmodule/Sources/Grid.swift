import SwiftUI

public enum CellState{
    case dead, alive, minusOne, minusTwo, minusThree, minusFour
    
    public func decrease() -> CellState {
        switch self {
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
}

public protocol Grid: class, ObservableObject {
    init?(width: Int, height: Int)
    
    var width: Int { get }
    var height: Int { get }
    func iterate()
    
    subscript(_ x: Int, _ y: Int) -> CellState { get }
}
