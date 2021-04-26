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
    private var bloker:LoadBloker?
    let viewer = WKWebView()
    
    init(url:String, blocker:LoadBloker){
        self.url = url
        self.bloker = blocker
    }
    
    init(url:String){
        self.url = url
    }
    
    mutating func setBloker(blocker:LoadBloker){
        self.bloker = blocker
    }
    
    mutating func blockLoading(){
        self.bloker?.isBloked = true
    }
    
    mutating func unblockLoading(){
        self.bloker?.isBloked = false
    }
    
    func makeUIView(context: Context) -> WKWebView{
        return self.viewer
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        
        if let blocking = self.bloker{
            
            if(!blocking.isBloked){
                uiView.load(URLRequest(url: URL(string: self.url)!))
                self.bloker?.isBloked  = true
            }else{
                print("WKWebView: loading is blocked")
            }
        }else{
            return
        }
        
        
        
    }
    
    
}




struct Webviewj_Previews: PreviewProvider {
    
    
    static var previews: some View {
        WebViewer(url: "https://www.google.com/",blocker: LoadBloker())
    }
}
