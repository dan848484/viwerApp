//
//  Today.swift
//  AppleNews
//
//  Created by MacBookAir on 2020/09/24.
//  Copyright © 2020 dan. All rights reserved.
//

import SwiftUI

struct Today: View {
    var body: some View {
        NavigationView{
            Group{
                Text("hello world , ladies and gentlmen, boys and girl,welcome to tokyodisneyland")
            }.navigationBarTitle("Today")
        }
    }
}

struct Today_Previews: PreviewProvider {
    static var previews: some View {
        Today()
    }
}
