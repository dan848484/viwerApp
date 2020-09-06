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
    @Environment(\.presentationMode) var presentation
    @State var inputedURL = ""
    @State var inputedName = ""
    @State var inputedColorNum = 0//仮のやつ
    @State var title = "New Site"//タイトルにつける文字列
    enum modeType{
        case ADD
        case INIT
        case EDIT
    }
    
    
    @ObservedObject var initViewOn:InitialViewMode = InitialViewMode()
    @State var editedObject:Sites!//編集するサイトのNSManagedObject
    var mode:modeType = .ADD //デフォルトのモードはADD
    
    //色を選択したときに出てくる枠線とか影とかの透明度を管理する配列
    @State var selectOnOpacity:[Double] = [1,
                                           0,
                                           0,
                                           0,
                                           0,
                                           0,
                                           0]
    
    @FetchRequest(
        entity: Sites.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Sites.name, ascending: true)]
    ) var sites: FetchedResults<Sites>
    
    init(_ initOn:InitialViewMode){
        self.mode = .INIT
        self.initViewOn = initOn
    }
    
    init(_ site:NSManagedObject){ // サイトの編集する時のinit
        self._editedObject = State(initialValue: (site as! Sites))
        self.mode = .EDIT
        self._inputedName = State(initialValue:  (site as! Sites).name!)
        self._inputedURL = State(initialValue: (site as! Sites).url!)
        //        self._inputedColorNum = State(initialValue: Int((site as! Sites).backgrround))
        //        self.selectOnOpacity[0] = 0
        //        self.selectOnOpacity[self.inputedColorNum] = 1
        self._title = State(initialValue: "Edit") // タイトルをEditにする。1
    }
    
    init(){
        self.mode = .ADD
    }
    
    var body: some View {
        NavigationView{
            VStack{
                
                Group{
                    List{
                        
                        Section(header: Text("Site Name")){
                            TextField("Website name here", text: $inputedName)//サイト名入力テキストフィールド
                        }
                        .padding(.top,5)
                        .padding(.bottom,5)
                        
                        Section(header: Text("URL")){
                            
                            TextField("URL here", text: $inputedURL)//URL入力テキストフィールド
                        }
                        .padding(.top,5)
                        .padding(.bottom,5)
                        
                        Section(header: Text("Icon Colors")){
                            ScrollView(.horizontal){
                                HStack{
                                    ForEach(0..<Icon.combination.count) { num in
                                        
                                        ZStack{
                                            Text("")
                                                .frame(width:108, height:108)
                                                .background(GradientMaker.backGroundColor(colorNum: num))
                                                .clipShape(Circle())
                                                .padding()
                                                .zIndex(2.0)
                                                .gesture(TapGesture(count: 1).onEnded({
                                                    
                                                    for i in 0..<self.selectOnOpacity.count {
                                                        if self.selectOnOpacity[i] == 1{
                                                            self.selectOnOpacity[i] = 0
                                                        }
                                                    }
                                                    
                                                    self.inputedColorNum = num
                                                    
                                                    self.selectOnOpacity[num] = 1.0
                                                }))
                                            
                                            Circle()
                                                .stroke(Color.white, lineWidth: 2)
                                                .frame(width:110,height: 110)
                                                .foregroundColor(Color.clear)
                                                .shadow(radius: 3)
                                                .opacity(self.$selectOnOpacity.wrappedValue[num])
                                        }
                                        
                                    }
                                }
                            }
                        }
                        Button(action:{
                            
                            if(self.inputedName == "" || self.inputedURL == ""){
                                return
                                
                            }
                            
                            print("initViewの値：\(self.initViewOn.initialMode)")
                            self.addSite()
                            if(self.mode == .INIT){
                                self.initViewOn.initialMode = false
                                
                            }else if(self.mode == .ADD || self.mode == .EDIT){
                                
                                if (self.mode == .EDIT){
                                    //サイトの編集モードの時にボタンを押した時の処理
                                    print(self.editedObject!)
                                    
                                    let newName = self.inputedName
                                    let newURL = self.inputedURL
                                    let newIcon = self.inputedColorNum
                                    
                                    let siteID = self.editedObject.id! as NSUUID
                                    
                                    let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Sites")
                                    fetchRequest.predicate = NSPredicate(format: "id == %@", siteID as CVarArg)
                                    
                                    fetchRequest.fetchLimit = 1
                                    
                                    do{
                                        let test = try self.context.fetch(fetchRequest)
                                        let target =  test[0] as! Sites
                                        target.name = newName
                                        target.url = newURL
                                        target.backgrround = Int64(newIcon)
                                        print("編集したサイトのIconナンバー：\(newIcon)")
                                        try self.context.save()
                                        //
                                        //                                self.context.refreshAllObjects()
                                        let fetchRequest:NSFetchRequest<Sites> = NSFetchRequest(entityName: "Sites")
                                        let fetchData = try self.context.fetch(fetchRequest)
                                        
                                        for i in 0..<fetchData.count{
                                            if(fetchData[i].url! as String == newURL){
                                                //なぜか２つサイトが登録されるので、入力したのと同じURLがあったらその時点で（1個目で）削除して、breakして抜けた、
                                                self.context.delete(self.editedObject)
                                                break
                                            }
                                        }
                                        
                                        
                                        
                                    }catch{
                                        print(error)
                                    }
                                    
                                    
                                }
                                
                                
                                self.presentation.wrappedValue.dismiss()
                            }
                            
                        }){
                            Text("Add")
                                .fontWeight(.bold)
                                .frame(width: 302,height: 52)
                                .foregroundColor(Color.white)
                                .background(Color(UIColor.systemBlue))
                                .clipShape(Capsule())
                                .shadow(radius: 3)
                            
                        }
                    }
                    
                    
                }.navigationBarTitle(self.title)
                
            }
        }.onAppear(){
            //listの追加の下線を消す
            UITableView.appearance().tableFooterView = UIView()
            
            //large titleの色変更
            UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor : UIColor(hex: "56627C")]
            
            
            
        }
        
        
        
        
        
    }
    
    
    
    func addSite(){
        let newSite = Sites(context: context)
        newSite.id = UUID()
        newSite.name = inputedName
        newSite.url = inputedURL
        newSite.backgrround = Int64(Double(Int(inputedColorNum) )) // Int → Double　→ Int64に変換。色番号の初期値は1
        
        
        
        do {
            try context.save()
        } catch {
            print("Failed to save new site")
            print(error)
        }
        
    }
    
    
    mutating func changeMode(_ mode:modeType){
        self.mode = mode
    }
}


struct Settings_Previews: PreviewProvider {
    static var previews: some View {
        Settings(InitialViewMode())
    }
}
