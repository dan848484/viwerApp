//
//  Today.swift
//  AppleNews
//
//  Created by MacBookAir on 2020/09/24.
//  Copyright © 2020 dan. All rights reserved.
//

import SwiftUI




struct Today: View {
    
    var articles:[(String, URL)]
    
    
    
    init(){
        // To remove all separators including the actual ones:
        UITableView.appearance().separatorStyle = .none
        UIScrollView.appearance().backgroundColor = UIColor.secondarySystemBackground
        
        //listの追加の下線を消す
        UITableView.appearance().tableFooterView = UIView()
        
        self.articles = Client.getArticle( "https://api.rss2json.com/v1/api.json?rss_url=https%3A%2F%2Fnews.yahoo.co.jp%2Frss%2Ftopics%2Fit.xml")
    }
    var body: some View {
        VStack {
            VStack{
                GeometryReader{ geometry in
                    List{
                        ForEach(0..<self.articles.count/2){ i in
                            HStack{
                                article(windowWidth:geometry.size.width,title:self.articles[i*2].0,url: self.articles[i*2].1).padding(.trailing,8)
                                article(windowWidth:geometry.size.width,title:self.articles[(i*2)+1].0,url: self.articles[(i*2)+1].1).padding(.leading,8)
                            }.padding(.top)
                        }.listRowBackground( Color(UIColor.secondarySystemBackground))
                        
                    }
                    
                }
                
            }
        }
    }
}



struct article: View {
    
    let widht:CGFloat
    let titleText:String
    let url:URL
    
    
    init(windowWidth:CGFloat,title:String,url:URL){
        self.widht = windowWidth
        self.titleText = title
        self.url = url
    }
    
    @State var showSafari = false
    
    var body: some View{
        //        GeometryReader{ geometry in
        
        
        //            Button(action:{
        //                self.showSafari = true
        //            })
        VStack{
            
            VStack(alignment: .leading){
                
                Image("testimg")
                    .resizable()
                    .frame(width: self.widht/2, height:140)
                VStack(alignment: .leading){
                    VStack(alignment: .leading){
                        Text("2020/08/4")
                        
                        Text(self.titleText)
                            .fontWeight(.bold)
                            .offset(y: 5)
                            .frame(width: self.widht/2-5)
                    }
                    
                }.frame(width: self.widht/2, height: 92)
                .offset(x: -20, y: -15)
            }.sheet(isPresented: self.$showSafari, content: {
                SafariView(url: self.url)
            })
            .padding(10)
            .frame(width: self.widht/2 - 30 , height:232)
            .background(Color.white)
            .cornerRadius(30)
            
        }.frame(width: self.widht/2 - 30 , height:232)
        .gesture(TapGesture(count: 1).onEnded({
            self.showSafari = true
        }))
        
        
        //        }
        
    }
}


struct Today_Previews: PreviewProvider {
    static var previews: some View {
        VStack{
            Today()
            
        }
    }
}
