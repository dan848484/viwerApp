//
//  Settings.swift
//  AppleNews
//
//  Created by  MacBookAir on 2020/04/29.
//  Copyright © 2020 dan. All rights reserved.
//

import SwiftUI
import CoreData

struct Settings: View {
    @Environment(\.managedObjectContext) var context //ManegedObjectContext
    @State var inputedURL = ""
    @State var inputedName = ""
    
    @FetchRequest(
        entity: Sites.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Sites.name, ascending: false)],
        predicate: NSPredicate(format: "name == %@", NSNumber(value: false))
    ) var sites: FetchedResults<Sites>
    
    
    var body: some View {
        VStack{
            HStack{
                TextField("URL here", text: $inputedURL)//URL入力テキストフィールド
                TextField("Website name here", text: $inputedName)//サイト名入力テキストフィールド
                Button(action:{
                    self.addSite()
                }){
                    Text("Add")
                        .fontWeight(.bold)
                }
                .padding()
                .foregroundColor(Color.white)
                .background(Color.red)
                .clipShape(Capsule())
                
            }
            
//            if(sites.count != 0){
//                List{
//                    
//                    ForEach(sites) { site in
//                        row(site: site)
//                        
//                    }
//                }
//            }
            
        }
        
    }
        
        
        
        func addSite(){
//            let newSite = Sites(context: context)
//            newSite.id = UUID()
//            newSite.name = inputedName
//            newSite.url = inputedURL
//
            
            let discription = NSEntityDescription.entity(forEntityName: "Sites", in: context)!
            let newSite = Sites(entity: discription, insertInto: context)
            context.insert(newSite)
            newSite.id = UUID()
            newSite.name = inputedName
            newSite.url = inputedURL
            
            do {
                try context.save()
            } catch {
                print("Failed to save new note")
            }
            do{
                try context.save()
            }catch {
                print(error)
            }
        }
        
    }
    

    
    struct row :  View {
        let site:Sites
        var body: some View{
            HStack{
                Text(site.name ?? "no name given")//サイト名
                Text(site.url ?? "no url given")//サイトURL
                    .font(.system(size: 10))
                    .foregroundColor(Color.gray)
                Spacer()
                
                Button(action:{
                    //サイト登録消去処理
                }){
                    Text("Delete")
                        .foregroundColor(Color.red)
                }
            }
        }
    }
    
    
    
    struct Settings_Previews: PreviewProvider {
        static var previews: some View {
            Settings()
        }
}
