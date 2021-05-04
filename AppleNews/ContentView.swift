
import SwiftUI
import CoreData
import WebKit


struct ContentView: View {
    @State var webview:WebViewer = WebViewer(url: "https://www.google.com/")
    @ObservedObject var initViewOn:InitialViewMode
    @ObservedObject var prev: PrevButtonPosition
    private var manager: CoredataManager
    @State var sites:[Sites] = []
    @ObservedObject var loadBroker:LoadBloker
    @State var todayMode:Bool = false
    @State var on:Bool = false

    init(initViewOn:InitialViewMode,prev:PrevButtonPosition,loadBlocker:LoadBloker, coredata:CoredataManager){
        self.initViewOn = initViewOn
        self.prev = prev
        self.loadBroker = loadBlocker
        self.manager = coredata
    }
    
    var body: some View {
        ZStack{
            if self.initViewOn.initialMode == false {
                PageViewer(prev: self.prev,webview: self.$webview)
                Controller(coredata: self.manager, prev: self.prev,sites: self.$sites,webview: self.$webview,loadBlocker: self.loadBroker, initViewOn:self.initViewOn)
                
            }else{
                Settings(self.initViewOn,coredata: self.manager, sites: self.$sites)
            }
        }
        .onDisappear{
            print("disappered!!")
            self.manager.deleteDummySites()
            
        }
    
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(initViewOn: InitialViewMode(),prev: PrevButtonPosition(), loadBlocker: LoadBloker(),coredata: CoredataManager())
    }
}
