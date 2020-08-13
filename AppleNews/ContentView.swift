
import SwiftUI
import CoreData
import WebKit


struct ContentView: View {
    
    @ObservedObject var initViewOn:InitialViewMode
    @ObservedObject var prev: PrevButtonPosition
    
    @State var hoge:Bool = false

    @State var on:Bool = false
    
    @State var showingSite:NSManagedObject?
    @State var showingSite_name = ""//表示しているサイトの名前
    
    @State var webview:WebViewer = WebViewer(url: "https://www.google.com/")
    @State var iconBackground = LinearGradient(gradient: Gradient(colors: [Color.white, Color.black]), startPoint: UnitPoint.init(x: 0, y: 0), endPoint: UnitPoint.init(x:1,y:1))
    var modalMaxHeight: CGFloat = 267.96000000000004
    @State var bottomSheetShown = true
    
    @State var settingModal:Bool = false
    @State var EdittingModal:Bool = false
    @State var showSheet:Bool = false //ペンシルアイコンを押した時のシート
    @Environment(\.managedObjectContext) var context
    
    
    @FetchRequest(
        entity: Sites.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Sites.name, ascending: true)]
    ) var sites: FetchedResults<Sites>

    
    func back() {
        self.webview.viewer.goBack()
    }
    
    var body: some View {
        
        ZStack{
        
            if self.initViewOn.initialMode == false {
                VStack{
                    ZStack{
                            self.webview
                                .shadow(radius: 1.0)
                                .background(Color(UIColor(hex: "F2F2F2")))
                    }.zIndex(3.0)
                    
                    
                    
                }.background(Color(UIColor(hex: "F2F2F2")))
           
                
                GeometryReader{ geometry in

                    VStack{//ブラウザの戻るボタン
                        Button(action:{
                            self.back()
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
                        }.position(x: geometry.size.width * 0.8, y: geometry.size.height - self.modalMaxHeight * 1.2)
                            .offset(y: self.prev.position)
                        
                        
                    }
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .animation(.interactiveSpring())
                    
                    //モーダル
                    BottomSheetView(isOpen: self.$bottomSheetShown,
                                    maxHeight: CGFloat(self.modalMaxHeight),
                                    prev: self.prev
                    ){
                        
                        Group{
                            HStack(){
                                Group{
                                    Group{
                                        
                                        ZStack{
                                            Circle()
                                                .frame(width: 42, height: 42)
                                                .foregroundColor(Color.white)
                                            
                                            Text("")
                                                .frame(width:40,height: 40)
                                                .background(self.iconBackground)
                                                .clipShape(Circle())
                                        }
                                        
                                        Text(self.showingSite_name)
                                            .font(.largeTitle)
                                            .fontWeight(.bold)
                                            .frame(maxWidth: 172, alignment: .leading)
                                    }
                                    .offset(x:30, y: 10)
                                    
                                    
                                    Spacer()
                                    Button(action:{
                                        self.showSheet = true
                                    }){
                                        Image(systemName: "pencil.circle")
                                            .resizable()
                                            .frame(width:32, height:32)
                                    }
                                    .actionSheet(isPresented: self.$showSheet, content: {
                                        ActionSheet(title: Text("Edit"),
                                                    message: Text("choose options"),
                                                    buttons: [
                                                        .default(Text("Edit"), action: {
                                                            self.EdittingModal = true
                                                            //                                                 Settings(self.showingSite!).environment(\.managedObjectContext, self.context)
                                                        }),
                                                        .destructive(Text("Remove"), action:{
                                                            self.context.delete(self.showingSite!)
                                                            
                                                        }),
                                                        .cancel(Text("Cancel"))
                                        ])
                                        
                                        
                                    })  .sheet(isPresented: self.$EdittingModal){
                                        Settings(self.showingSite!).environment(\.managedObjectContext, self.context)
                                    }
                                    .offset(x:-40,y: 4)
                                    
                                    
                                }
                                
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height:100)
                        .background(Color(UIColor.systemBackground))
                        
                        
                        
                        ScrollView(.horizontal,showsIndicators: false){
                            HStack{
                                
                                Button(action:{
                                    self.settingModal = true
                                }){
                                    Circle()
                                        .foregroundColor(Color(UIColor.systemBlue))
                                        .frame(width:72, height: 72)
                                        .padding(.horizontal, 30)
                                        .overlay(Image(systemName: "plus").resizable().foregroundColor(Color.white).frame(width:25,height:25))
                                        .clipShape(Circle())
                                }
                                .sheet(isPresented: self.$settingModal, content: {
                                    //environmentでcontextを受け渡さないと、"is not connected"的なエラーが出る。
                                    Settings().environment(\.managedObjectContext, self.context)
                                })
                                ForEach(self.sites){ site in
                                    Icon(site)
                                        .padding(.horizontal, 8)
                                        .gesture(TapGesture(count: 1)
                                            .onEnded(){
                                                 self.webview   .url = site.url ?? "http://www.kuronekoyamato.co.jp/ytc/404error.html"
                                                self.showingSite_name =  site.name!
                                                self.iconBackground = GradientMaker.backGroundColor(colorNum: Int(site.backgrround))
                                                self.showingSite = site
                                        }).onAppear(){
                                            //                                    print("サイトのURL：\(site.url!)")
                                    }
                                }
                            }
                        }
                        .padding(.bottom,40)
                        .padding(.top,20)
                        .background(Color(UIColor.secondarySystemBackground))
                        .edgesIgnoringSafeArea(.bottom)
                        
                        
                        
                    }
                }
                .edgesIgnoringSafeArea(.all)
            
            }else{
                Settings(self.initViewOn).environment(\.managedObjectContext, self.context)
            }
        }
        .onAppear{
            
            
//             self.webview .allowSwipeSwith()//スワイプでページ切り替えを許可する
            if self.sites.count != 0 {
                 self.webview   .url = self.sites[0].url ?? "https://www.google.com/"
                self.showingSite_name = self.sites[0].name ?? "error"
                self.iconBackground = GradientMaker.backGroundColor(colorNum: Int(self.sites[0].backgrround))
                self.showingSite = self.sites[0]
                
            }else{
                print("登録されているサイトはないです。")
                self.initViewOn.initialMode = true
            }
            
        }
        
    }
    
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(initViewOn: InitialViewMode(),prev: PrevButtonPosition())
    }
}
