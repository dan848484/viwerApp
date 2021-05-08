//
//  BottomModal.swift
//  AppleNews
//
//  Created by MacBookAir on 2021/05/04.
//  Copyright © 2021 dan. All rights reserved.
//

import SwiftUI

struct Controller: View {
    
    private let modalMaxHeight:CGFloat = 267.96000000000004
    @State private var bottomSheetShown = true
    @ObservedObject  var prev: PrevButtonPosition
    @Binding private var sites:[Sites]
    @Binding private var webview:WebViewer
    @State var showSheet:Bool = false //ペンシルアイコンを押した時のシート
    @State var EdittingModal:Bool = false
    @State var changeOrderView:Bool = false
    private var manager: CoredataManager
    @State var iconBackground = LinearGradient(gradient: Gradient(colors: [Color.white, Color.black]), startPoint: UnitPoint.init(x: 0, y: 0), endPoint: UnitPoint.init(x:1,y:1))
    @State var showingSite:Sites?
    @State var showingSite_name = ""//表示しているサイトの名前
    @State var settingModal:Bool = false
    @ObservedObject var loadBloker:LoadBloker
    @ObservedObject var initViewOn:InitialViewMode
    
    init(coredata:CoredataManager, prev :PrevButtonPosition,
         sites:Binding<[Sites]>,
         webview: Binding<WebViewer>,
         loadBlocker: LoadBloker,
         initViewOn: InitialViewMode){
        self.prev = prev
        self._sites = sites
        self._webview = webview
        self.manager = coredata
        self.loadBloker = loadBlocker
        self.initViewOn = initViewOn
    }
    
    var body: some View {
        Group{
            //モーダル
            BottomSheetView(isOpen: self.$bottomSheetShown,
                            prev: self.prev){
                Group{
                    HStack(){
                        Group{
                            Group{
                                ZStack{
                                    Circle()
                                        .frame(width: 42, height: 42)
                                        .foregroundColor(Color.white)
                                    
                                    Text("")
                                        .frame(width:40,height: 40)
                                        .background(self.iconBackground)
                                        .clipShape(Circle())
                                }
                                
                                Text(self.showingSite_name)
                                    .font(.largeTitle)
                                    .fontWeight(.bold)
                                    .frame(maxWidth: 172, alignment: .leading)
                            }
                            .offset(x:30, y: 10)
                            
                            
                            Spacer()
                            Button(action:{
                                self.showSheet = true
                                print(self.prev.position)
                            }){
                                Image(systemName: "pencil.circle")
                                    .resizable()
                                    .frame(width:32, height:32)
                            }
                            .actionSheet(isPresented: self.$showSheet, content: {
                                ActionSheet(title: Text("Edit"),
                                            message: Text("choose options"),
                                            buttons: [
                                                .default(Text("Edit"), action: {
                                                    self.EdittingModal = true
                                                    //Settings(self.showingSite!).environment(\.managedObjectContext, self.context)
                                                }),
                                                Alert.Button.default(Text("Change The Order"),action: {
                                                    self.changeOrderView = true
                                                    
                                                }),
                                                .destructive(Text("Remove"), action:{
                                                    self.manager.deleteSite(site: self.showingSite as! Sites)
                                                    self.sites = self.manager.getData()
                                                }),
                                                .cancel(Text("Cancel"))
                                ])
                                
                                
                            })  .sheet(isPresented: self.$EdittingModal){
                                Settings(self.showingSite!,coredata: self.manager, sites: self.$sites)
                            }.sheet(isPresented: self.$changeOrderView){
                                OrderView(sites: self.$sites, isShown: self.$changeOrderView)
                            }
                            
                            .offset(x:-40,y: 4)
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .frame(height:100)
                .background(Color(UIColor.systemBackground))
                
                
                //サイトアイコンの生成部分
                ScrollView(.horizontal,showsIndicators: false){
                    HStack{
                        //  button to add a new site
                        Button(action:{
                            self.settingModal = true
                        }){
                            Circle()
                                .foregroundColor(Color(UIColor.systemBlue))
                                .frame(width:72, height: 72)
                                .padding(.horizontal, 30)
                                .overlay(Image(systemName: "plus").resizable().foregroundColor(Color.white).frame(width:25,height:25))
                                .clipShape(Circle())
                        }
                        .sheet(isPresented: self.$settingModal, content: {
                            Settings(coredata:self.manager, sites: self.$sites)
                        })
                        ForEach(self.sites){ site in
                            if(site.name! == CoredataManager.dummySiteName && site.url! == CoredataManager.dummySiteURL){
                                EmptyView()
                            }else{
                                Button(action:{
                                    self.loadBloker.isBloked = false
                                    self.webview.url = site.url ?? "http://www.kuronekoyamato.co.jp/ytc/404error.html"
                                    self.showingSite_name =  site.name!
                                    self.iconBackground = GradientMaker.backGroundColor(colorNum: Int(site.backgrround))
                                    self.showingSite = site
                                    
                                    self.sites = self.manager.getData()
                                }){
                                    Icon(site)
                                        .padding(.horizontal, 8)
                                }
                            }
                        }
                    }
                }
                .padding(.bottom,40)
                .padding(.top,20)
                .background(Color(UIColor.secondarySystemBackground))
                .edgesIgnoringSafeArea(.bottom)
            }
        }
        .onAppear{
            self.sites = self.manager.getData()
            for i in 0 ..< self.sites.count{
                print(self.sites[i].name!)
            }
            if self.sites.count != 0 {
                let initialSite:Sites = self.sites[0]
                self.webview   .url = initialSite.url ?? "https://www.google.com/"
                self.showingSite_name = initialSite.name ?? "faile to get site name"
                self.iconBackground = GradientMaker.backGroundColor(colorNum: Int(initialSite.backgrround))
                self.showingSite = initialSite
                self.webview.setBloker(blocker: loadBloker)
                self.webview.unblockLoading()
            }else{
                print("登録されているサイトはないです。")
                self.initViewOn.initialMode = true
            }
        }
        .edgesIgnoringSafeArea(.all)
        }
    }

