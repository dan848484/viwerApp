//
//  PageViewer.swift
//  AppleNews
//
//  Created by MacBookAir on 2021/05/04.
//  Copyright © 2021 dan. All rights reserved.
//

import SwiftUI

struct PageViewer: View {
    
    @Binding private var webview:WebViewer
    @ObservedObject var prev: PrevButtonPosition
    private let maxHeight:CGFloat = 267.96000000000004

    init(prev: PrevButtonPosition, webview:Binding<WebViewer>){
        self.prev = prev
        self._webview = webview
    }
    
    private func back() {
        self.webview.viewer.goBack()
        self.webview.blockLoading()
    }
    
    
    var body: some View {
        ZStack{
            GeometryReader{ geometry in
            self.webview
                .shadow(radius: 1.0)
                .background(Color(UIColor(hex: "F2F2F2")))
                .zIndex(3.0)
                
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
                    }.position(x: geometry.size.width * 0.8, y: geometry.size.height - self.maxHeight * 1.1)
                        .offset(y: self.prev.position)
                        
                    
                }
                .frame(width: geometry.size.width, height: geometry.size.height)
                .zIndex(4)
                .animation(.interactiveSpring())
            }
        }
    }
}

