func weightedCoinFlip() -> Bool {
    let coinFlip = Int(arc4random_uniform(6))
    switch coinFlip {
        case 0...4:
        return false
        default:
        return true
    }
}

public class RandomGrid: IteratingGrid {
    required public override init?(width: Int, height: Int){
        if (width <= 0 || height <= 0){
            return nil
        }
        super.init(width: width, height: height)
        for x in 0..<width{
            for y in 0..<height {
                self[x, y] = weightedCoinFlip() ? .alive : .dead
            }
        }
    }
}
