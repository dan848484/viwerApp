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
    @ObservedObject var prevButton: PrevButtonPosition
    
    let maxHeight: CGFloat
    let minHeight: CGFloat
    let content:Content
    let closure = {}()
    
    init(isOpen: Binding<Bool>, maxHeight: CGFloat,prev :PrevButtonPosition , @ViewBuilder content: () -> Content){
        self.minHeight = maxHeight * Constants.minHeightRatio
        self.maxHeight = maxHeight
        self.content = content()
        self._isOpen = isOpen
        self.prevButton = prev
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
                    
                    if self.translation < 0 && self.isOpen{
                        //開いてる時かつ、上にスクロールしようとした時
                        self.prevButton.position = 0
                        return
                    }else if self.translation > 0 && !self.isOpen {
                         //閉じている時に下にスクロールしようとした時。（というか、画面下以上に下げようとした時）
                        self.prevButton.position = self.maxHeight - self.minHeight
                        return
                    }else if -self.translation > self.maxHeight - self.minHeight && !self.isOpen{
                       //しまっている時かつ、上にスクロールした時に、max-minよりもスクロールした場合
                        self.prevButton.position = 0
                        return
                    }

                    if self.isOpen{
                            self.prevButton.position = self.translation
                    }else{//閉じた状態から上にスクロールする時はこうしないと、おかしくなる
                        self.prevButton.position = self.sinkedAmout +  self.translation
                    }
                    
                    
                }.onEnded { value in
                    let swipeDistance = self.maxHeight * Constants.swipeRatio
                    
                    guard abs(value.translation.height) > swipeDistance else{
                        return
                    }
                    
                    self.isOpen = value.translation.height < 0//上方向のスワイプだった時
                    
                    if self.isOpen {
                        //オープン状態では最終的に戻るボタンは元々の位置
                        self.prevButton.position = 0
                    }else{
                        //しまっている状態では最終的にはモーダルが沈んだ分だけ
                        self.prevButton.position = self.maxHeight - self.minHeight
                    }
                    
//                    print(self.translation)
                    
                }
            )
        }
    }
    
    
}

