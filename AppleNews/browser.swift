//
//  browser.swift
//  AppleNews
//
//  Created by  MacBookAir on 2020/08/11.
//  Copyright © 2020 dan. All rights reserved.
//

import Foundation

class Browser: ObservableObject{
    
    @Published var webview:WebViewer
    
    init(){
        self.webview = WebViewer(url: "https://www.google.com/")
        self.webview.allowSwipeSwith()
    }
    
    func back(){
        self.webview.back()
    }
    
    
}
