
import SwiftUI
import Combine

extension Color {
    static func from(state gridState: CellState) -> Color{
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
        case .minusFive:
            //212, 77, 64
            return .init(.sRGB, red: 25/255, green: 78/255, blue: 139/255)
        case .minusSix:            
            return .init(.sRGB, red: 14/255, green: 51/255, blue: 95/255)
        case .minusSeven:
            return .init(.sRGB, red: 6/255, green: 30/255, blue: 58/255)
        }
    }
}

public struct GridView<T: Grid>: View {
    @ObservedObject var grid: T
    
    public init(grid: T, tickSpeed: TimeInterval = 1.0){
        self.grid = grid
        self.timer = Timer.publish(every: tickSpeed, on: .main, in: .common).autoconnect()
    }
    
    let timer: Publishers.Autoconnect<Timer.TimerPublisher>
    
    public var body: some View {
        HStack(spacing: 0) {
            ForEach(0..<grid.width, id: \.self) { x in
                VStack(spacing: 0){
                    ForEach(0..<self.grid.height, id: \.self) { y in 
                        Rectangle().fill(Color.from(state: self.grid[x, y])).animation(.linear(duration: 1))
                    }
                }
            }
        }.background(Color.black).drawingGroup()
            .onReceive(timer) {_ in 
                self.grid.iterate()
        }
    }
}
