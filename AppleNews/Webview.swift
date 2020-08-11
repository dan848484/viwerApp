//
//  Webviewj.swift
//  AppleNews
//
//  Created by  MacBookAir on 2020/03/21.
//  Copyright © 2020 dan. All rights reserved.
//

import SwiftUI
import WebKit

struct Webview: UIViewRepresentable {

        var url:URL
        
        func makeUIView(context: Context) -> WKWebView{
            return WKWebView(frame:.zero)
        }
        
        func updateUIView(_ uiView: WKWebView, context: Context) {
            let req = URLRequest(url: url)
            uiView.load(req)
            
        }
    
}

struct Webviewj_Previews: PreviewProvider {
    static var previews: some View {
        Webview(url: URL(string: "https://apple.com")!)
    }
}
