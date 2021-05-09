//
//  Utilities.swift
//  AppleNews
//
//  Created by MacBookAir on 2021/05/09.
//  Copyright © 2021 dan. All rights reserved.
//

import Foundation

func organizeSites(_ sites:[Sites]) -> [Sites]{
    var organized:[Sites] = []
    
    for site in sites{
        if(organized.count == 0){
            organized.append(site)
        }else if(site.order > organized[organized.count-1].order){
            organized.append(site)
        }else if(site.order < organized[0].order){
            organized.insert(site, at: 0)
        }else{
            for i  in 0 ..< organized.count {
                if(site.order > organized[i].order){
                    organized.insert(site, at: i+1)
                    break
                }
            }
        }
    }
    
    return organized
}
