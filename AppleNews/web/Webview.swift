//
//  Webviewj.swift
//  AppleNews
//
//  Created by  MacBookAir on 2020/03/21.
//  Copyright © 2020 dan. All rights reserved.
//

import SwiftUI
import WebKit
//
//class Detector: ObservableObject {
//    @Published var observation:NSKeyValueObservation?
//}


struct WebViewer: UIViewRepresentable {
    
    var url:String
    let viewer = WKWebView()
    
    
    
    func makeUIView(context: Context) -> WKWebView{
        return self.viewer
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        
        uiView.load(URLRequest(url: URL(string: self.url)!))
    }
    
//        func back(){
//            if self.viwer.canGoBack {
//                print("go back")
//                self.viwer.goBack()
//
//            }else{
//                print("Couldn't go back")
//            }
//        }
//
//        func allowSwipeSwith(){
//            self.viwer.allowsBackForwardNavigationGestures = true
//        }
//
//        func forbidSwipeSwith(){
//            self.viwer.allowsBackForwardNavigationGestures = false
//        }
    
}




struct Webviewj_Previews: PreviewProvider {
    
    
    static var previews: some View {
        WebViewer(url: "https://www.google.com/")
    }
}
