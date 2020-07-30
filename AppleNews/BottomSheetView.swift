import SwiftUI

fileprivate enum Constants{
    static let radius: CGFloat = 25
    static let barHeight: CGFloat = 6
    static let barWidth: CGFloat = 60
    static let swipeRatio: CGFloat = 0.25
    static let minHeightRatio: CGFloat = 0.5
}


struct BottomSheetView<Content: View>: View  {
    @Binding var isOpen: Bool
    @GestureState private var translation: CGFloat = 0
    
    let maxHeight: CGFloat
    let minHeight: CGFloat
    let content:Content
    
    init(isOpen: Binding<Bool>, maxHeight: CGFloat, @ViewBuilder content: () -> Content){
        self.minHeight = maxHeight * Constants.minHeightRatio
        self.maxHeight = maxHeight
        self.content = content()
        self._isOpen = isOpen
        
    }
    
    private var sinkedAmout: CGFloat{
        return isOpen ? 0 : maxHeight - minHeight
    }
    
    private var bar: some View{
        RoundedRectangle(cornerRadius: Constants.radius)
            .fill(Color.secondary)
            .frame(width:Constants.barWidth, height: Constants.barHeight)
        
    }
    
    
    var body: some View{
        GeometryReader{ geometry in
            VStack(spacing: 0){
                self.bar.padding()
                self.content
            }
           .frame(width: geometry.size.width, height: self.maxHeight, alignment: .top)
            .background(Color(UIColor.systemBackground))
            .cornerRadius(Constants.radius)
        .shadow(radius: 20)
            .frame(height: geometry.size.height,alignment: .bottom)
            .offset(y: max((self.sinkedAmout + self.translation),0))
            .animation(.interactiveSpring())
            .gesture(
                DragGesture().updating(self.$translation) { value, state, _ in
                    state = value.translation.height
                }.onEnded { value in
                    let swipeDistance = self.maxHeight * Constants.swipeRatio
                    
                    guard abs(value.translation.height) > swipeDistance else{
                        return
                    }
                    
                    self.isOpen = value.translation.height < 0//上方向のスワイプだった時
                }
            )
        }
    }
    
    
}
