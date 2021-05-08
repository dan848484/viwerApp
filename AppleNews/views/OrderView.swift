//
//  OrderView.swift
//  AppleNews
//
//  Created by MacBookAir on 2021/04/27.
//  Copyright © 2021 dan. All rights reserved.
//

import SwiftUI

struct OrderView: View {
    
    @Binding var sites:[Sites]
    @Binding var isShown:Bool
    
    init(sites:Binding<[Sites]>,isShown:Binding<Bool>){
        self._sites = sites
        self._isShown = isShown
        
    }
    
    private func rowReplace(from: IndexSet, to: Int){
        self.sites.move(fromOffsets: from, toOffset: to)
    }
    
    var body: some View {
        NavigationView{
            List{
                ForEach(self.sites){ site in
                    Text(site.name!)
                }.onMove(perform: self.rowReplace)
                
            }.navigationTitle("Orders")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(content: {
                Button("Done"){
                    self.isShown = false
                }
            })
            
        }
    }
    
    
}

struct OrderView_Previews: PreviewProvider {
    
    static func getSites() -> [Sites]{
        var array:[Sites] = []
        for _ in 0 ..< 5{
            let newSite = Sites()
            newSite.name = "Hello"
            newSite.backgrround = 0
            newSite.id = UUID()
            newSite.order = 0
            newSite.url = "https://www.apple.com/jp/"
            array.append(newSite)
        }
        
        return array
    }
    
    static var previews: some View {
        OrderView(sites: Binding.constant(
            OrderView_Previews.getSites()
        ), isShown: Binding<Bool>.constant(true))
    }
}
