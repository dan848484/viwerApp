//
//  CoreDataManager.swift
//  AppleNews
//
//  Created by MacBookAir on 2021/04/27.
//  Copyright © 2021 dan. All rights reserved.
//

import Foundation
import CoreData

class CoredataManager{
    let persistentContainer: NSPersistentContainer
  
    
    init(){
        self.persistentContainer = NSPersistentContainer(name: "AppleNews")
        self.persistentContainer.loadPersistentStores(completionHandler: {(description, error) in
            if let error = error {
                fatalError("CoreData: could not get datas from CoreData")
            }
        })
        
        print("    ")
        print("---------------------------------")
        print("---Initialized CoreDataManager---")
        print("---------------------------------")
        print("    ")
        
        
    }
    
    func deleteSite(site: Sites){
        self.persistentContainer.viewContext.delete(site)
        do{
            try self.persistentContainer.viewContext.save()
        }catch{
            print("failed to delete site : \(error)")
        }
    }
    
    func saveData(name:String,url:String,background:Int,order:Int){
       
        let site = Sites(context: self.persistentContainer.viewContext)
        site.name = name
        site.url = url
        site.backgrround = Int64(background)
        site.order = Int64(order)
        site.id = UUID()
        do{
            try self.persistentContainer.viewContext.save()
        }catch{
            print("failed to save : \(error)")
        }
        
    }
    
    func getData() -> [Sites]{
        do{
            print("    ")
            print("------------------------------------")
            print("--Start to get data from CoreData---")
            print("------------------------------------")
            print("    ")
            
            return try self.persistentContainer.viewContext.fetch(Sites.fetchRequest())
        }catch{
            print("failed to get data from CoreData: \(error)")
        }
        return []
    }
}
