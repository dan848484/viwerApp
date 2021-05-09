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
    private var manager: CoredataManager
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
    @Binding var sites:[Sites]
    @EnvironmentObject var initViewOn: InitialViewMode
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
    
    init(_ site:NSManagedObject, sites: Binding<[Sites]>,coredata: CoredataManager){ // サイトの編集する時のinit
        self._editedObject = State(initialValue: (site as! Sites))
        self.mode = .EDIT
        self._inputedName = State(initialValue:  (site as! Sites).name!)
        self._inputedURL = State(initialValue: (site as! Sites).url!)
        self._title = State(initialValue: "Edit") // タイトルをEditにする。1
        self._sites = sites
        self.manager = coredata
        
    }
    
    init(sites: Binding<[Sites]>,coredata: CoredataManager){
        self._sites = sites
        self.manager = coredata
        if(self.manager.getData().count == 0 ){
            self.mode = .INIT
        }else{
            self.mode = .ADD
        }
    }
    

    
    
    var body: some View {
        GeometryReader{ geometry in
            NavigationView{
                
                VStack{
                    
                    Group{
                        
                        List{
                            
                            Section(header: Text("Site Name")){
                                TextField("Website name here", text: self.$inputedName)//サイト名入力テキストフィールド
                            }
                            .padding(.top,5)
                            .padding(.bottom,5)
                            
                            Section(header: Text("URL")){
                                TextField("URL here", text: self.$inputedURL)//URL入力テキストフィールド
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
                                    }.padding(.leading, 20)
                                    .padding(.trailing,40)
                                }
                                .frame(width: geometry.size.width)
                                .offset(x:-30)
                            }
                        }.listStyle(InsetGroupedListStyle())
                        self.getButton().offset(y:-40)
                    }.navigationBarTitle(self.title)
                }.background(Color(UIColor.secondarySystemBackground))
                .edgesIgnoringSafeArea(.all)
            }
        }
    }
    


    
    func getButton() -> some View{
        
        var buttonText = "Add"
        switch self.mode {
        case .ADD:
            break
        case .EDIT:
            buttonText = "Done"
        case .INIT:
            break
        }
        
        return Button(action:{
            
            if(self.inputedName == "" || self.inputedURL == ""){
                return
                
            }
            

            if(self.mode == .INIT){
                self.initViewOn.initialMode = false
                self.addSite()
                
            }else if(self.mode == .ADD || self.mode == .EDIT){
                
                if (self.mode == .EDIT){
                    //サイトの編集モードの時にボタンを押した時の処理
                    print(self.editedObject!)
                    let newName = self.inputedName
                    let newURL = self.inputedURL
                    let newIcon = self.inputedColorNum
                    let newOrder = self.editedObject!.order
                    self.manager.update(site: self.editedObject!, name: newName, url: newURL, background: newIcon, order: Int(newOrder))
                    self.sites = self.manager.getData()
                }else if(self.mode == .ADD){
                    self.addSite()
                    self.sites = self.manager.getData()
                   
                }
                
                self.presentation.wrappedValue.dismiss()
            }
            
        }){
            Text(buttonText)
                .fontWeight(.bold)
                .frame(width: 302,height: 52)
                .foregroundColor(Color.white)
                .background(Color(UIColor.systemBlue))
                .clipShape(Capsule())
                .shadow(radius: 3)
            
        }
    }
    
    
    
    func addSite(){
        let order = self.sites.count
        self.manager.saveData(name: inputedName, url: inputedURL, background: Int(Int64(Double(Int(inputedColorNum) ))), order: order)
        
    }
    
    mutating func changeMode(_ mode:modeType){
        self.mode = mode
    }
}


struct Settings_Previews: PreviewProvider {
    static var previews: some View {
        Settings(sites: Binding<[Sites]>.constant([]),coredata: CoredataManager())
    }
}
