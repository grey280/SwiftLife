
import SwiftUI

extension Color {
    static func from(state gridState: GridState) -> Color{
        switch gridState{
            case .dead:
            return .black
            case .alive:
            return .white
            case .minusOne:
            return .init(.sRGB, red: 64/255, green: 188/255, blue: 216/255) // 40BCD8
            case .minusTwo:
            return .init(.sRGB, red: 57/255, green: 169/255, blue: 219/255)
            // 39a9db
            case .minusThree:
            return .init(.sRGB, red: 0/255, green: 129/255, blue: 175/255)
            // 0081af
        case .minusFour:
            return .init(.sRGB, red: 38/255, green: 96/255, blue: 164/255)
            // 2660A4
        }
    }
}

public struct GridView: View {
    @ObservedObject var grid: Grid
    
    public init(grid: Grid){
        self.grid = grid
    }
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    public var body: some View {
        HStack(spacing: 0) {
            ForEach(0..<grid.width, id: \.self) { x in
                VStack(spacing: 0){
                    ForEach(0..<self.grid.height, id: \.self) { y in 
                        Rectangle().fill(Color.from(state: self.grid.cell(x: x, y: y))).animation(.linear(duration: 1))
                    }
                }
            }
        }.background(Color.black).drawingGroup()
        .onReceive(timer) {_ in 
            self.grid.iterate()
        }
    }
}
