//
//  webManager.swift
//  AppleNews
//
//  Created by  MacBookAir on 2020/05/12.
//  Copyright © 2020 dan. All rights reserved.
//

import Foundation

class WebManager: ObservableObject{
    @Published var url:String = "https://apple.com"
    
    func load(url:String,viwer:Webview){
        self.url = url
        
//        viwer.url = URL(string: self.url)
    }
}
