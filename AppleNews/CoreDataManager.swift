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
    private var context:NSManagedObjectContext
    
    static let dummySiteName:String = "DummySite"
    static let dummySiteURL:String = "DUMMYSITE_BOOKMARKER"
    
    init(){
        print("    ")
        print("---------------------------------")
        print("---Initialized CoreDataManager---")
        print("---------------------------------")
        print("    ")
        self.context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext        
    }
    
    func deleteDummySites(){
        let items:[Sites] = self.getData()
              for i in 0 ..< items.count{
                  let item = items[i]
                if(item.name! == CoredataManager.dummySiteName && item.url! == CoredataManager.dummySiteURL){
                      self.deleteSite(site: item)
                  }
              }
    }
    
    
    func deleteSite(site: Sites){
        self.context.delete(site)
        print("deleted site : \(site.name!)")
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
        
        self.saveDummySite()
        
        
        do{
            try self.context.save()
            print("updated site: \(site.name!)")
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
            print("new site: \(site.name!)")
        }catch{
            print("failed to save : \(error)")
        }
    }
    
    private func saveDummySite(){
        let site = Sites(context: self.context)
        site.name = CoredataManager.dummySiteName
        site.url = CoredataManager.dummySiteURL
        site.backgrround = Int64(0)
        site.order = Int64(0)
        site.id = UUID()
        do{
            try self.context.save()
            
        }catch{
            print("failed to save temporal site : \(error)")
        }
    }
    
    func getData() -> [Sites]{
        do{
            print("    ")
            print("---------------------------")
            print("--Got data from CoreData---")
            print("---------------------------")
            print("    ")
            
            var items:[Sites] = try self.context.fetch(Sites.fetchRequest())
            
            return items
        }catch{
            print("failed to get data from CoreData: \(error)")
        }
        return []
    }
    
    
}
