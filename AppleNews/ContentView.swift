
import SwiftUI
import CoreData
import WebKit


struct ContentView: View {
    @State var webview:WebViewer = WebViewer(url: "https://www.google.com/")
    @EnvironmentObject var initViewOn: InitialViewMode
    @ObservedObject var prev: PrevButtonPosition
    @EnvironmentObject private var manager: CoredataManager
    @State var sites:[Sites] = []
    @ObservedObject var loadBroker:LoadBloker
    @State var todayMode:Bool = false
    @State var on:Bool = false
    
    init(prev:PrevButtonPosition,loadBlocker:LoadBloker){
        self.prev = prev
        self.loadBroker = loadBlocker
    }
    
    var body: some View {
        ZStack{
            if self.initViewOn.initialMode == false {
                PageViewer(prev: self.prev,webview: self.$webview)
                Controller(prev: self.prev,sites: self.$sites,webview: self.$webview,loadBlocker: self.loadBroker)
            }else{
                Settings(sites: self.$sites, coredata: self.manager)
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
        ContentView(prev: PrevButtonPosition(), loadBlocker: LoadBloker()).environmentObject(CoredataManager())
    }
}
