//
//  LoadBlocker.swift
//  AppleNews
//
//  Created by MacBookAir on 2021/04/25.
//  Copyright © 2021 dan. All rights reserved.
//

import Foundation


class LoadBloker:ObservableObject{
    @Published var isBloked:Bool
    
    init(){
        self.isBloked = true
    }
}
