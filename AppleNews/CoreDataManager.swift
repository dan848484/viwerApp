//
//  CoreDataManager.swift
//  AppleNews
//
//  Created by MacBookAir on 2021/04/27.
//  Copyright © 2021 dan. All rights reserved.
//

import Foundation
import CoreData
import SwiftUI

class CoredataManager{
    var context:NSManagedObjectContext
    
    
    init(){
        print("    ")
        print("---------------------------------")
        print("---Initialized CoreDataManager---")
        print("---------------------------------")
        print("    ")
        self.context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }
    
    
    func deleteSite(site: Sites){
        self.context.delete(site)
        print("deleted site : \(site.name)")
        do{
            try self.context.save()
        }catch{
            print("failed to delete site : \(error)")
        }
    }
    
    func update(site:Sites,name:String,url:String,background:Int,order:Int){
        site.name = name
        site.url = url
        site.backgrround = Int64(background)
        site.order = Int64(order)
        
        
        do{
            try self.context.save()
            print("updated site: \(site.name)")
        }catch{
            print("failed to update : \(error)")
        }
    }
    
    func saveData(name:String,url:String,background:Int,order:Int){
       
        let site = Sites(context: self.context)
        site.name = name
        site.url = url
        site.backgrround = Int64(background)
        site.order = Int64(order)
        site.id = UUID()
        do{
            try self.context.save()
            print("new site: \(site.name)")
        }catch{
            print("failed to save : \(error)")
        }
        
    }
    
    func getData() -> [Sites]{
        do{
            print("    ")
            print("---------------------------")
            print("--Got data from CoreData---")
            print("---------------------------")
            print("    ")
            
            return try self.context.fetch(Sites.fetchRequest())
        }catch{
            print("failed to get data from CoreData: \(error)")
        }
        return []
    }
}
