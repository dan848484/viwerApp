//
//  SitesConfig.swift
//  AppleNews
//
//  Created by MacBookAir on 2020/09/21.
//  Copyright © 2020 dan. All rights reserved.
//

import Foundation


struct Yahoo: Codable {
    let items:[Item]
    
    struct Item:Codable {
        let title: String
        let link:String
    }
}
