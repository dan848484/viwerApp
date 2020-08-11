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
    let backButtonContent:Void = {}()
    let closure = {}()
    
    init(isOpen: Binding<Bool>, maxHeight: CGFloat, backButtonContent: () -> Void, @ViewBuilder content: () -> Content){
        self.minHeight = maxHeight * Constants.minHeightRatio
        self.maxHeight = maxHeight
        self.content = content()
        self._isOpen = isOpen
        self.backButtonContent = backButtonContent()
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
            
            ZStack{
                Button(action:{
                    self.backButtonContent
                    
                }){
                    Circle()
                        .foregroundColor(Color(UIColor.secondarySystemBackground))
                        .frame(width:72, height: 72)
                        .shadow(radius: 7)
                        .overlay(Image(systemName: "chevron.left")
                            .resizable()
                            .foregroundColor(Color(UIColor.systemBlue))
                            .frame(width:21,height: 34)
                            .offset(x: -3)
                    )
                }.position(x: geometry.size.width * 0.8, y: geometry.size.height - self.maxHeight * 1.2)
                    .offset(y: max((self.sinkedAmout + self.translation),0))
                
                
            }.frame(width: geometry.size.width, height: geometry.size.height)
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
