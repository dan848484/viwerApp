//
//  Today.swift
//  AppleNews
//
//  Created by MacBookAir on 2020/09/24.
//  Copyright © 2020 dan. All rights reserved.
//

import SwiftUI




struct Today: View {
    
    init(){
        // To remove all separators including the actual ones:
        UITableView.appearance().separatorStyle = .none
        UIScrollView.appearance().backgroundColor = UIColor.secondarySystemBackground
        
    }
    var body: some View {
   
            
                VStack {
                      
                
                VStack{
                    
                    
                    
                    
                    List{
                        ForEach(1..<6){_ in
                            
                            HStack{
                                article().padding(.trailing,12)
                                article().padding(.leading,12)
                            }.padding(.top)
                        }.listRowBackground( Color(UIColor.secondarySystemBackground))
                    }
                }
                
                
                
                
                
                
                
            }
            
            
            
            
            
            
    }
}



struct article: View {
    var body: some View{
        VStack(alignment: .leading){
            Image("testimg")
                .resizable()
                .frame(width: 166, height:140)
            VStack(alignment: .leading){
                VStack(alignment: .leading){
                    Text("2020/08/4")
                    
                    Text("記事のテスト")
                        .fontWeight(.bold)
                        .offset(y: 5)
                }
                
            }.frame(width: 166, height: 92)
                .offset(x: -20, y: -15)
        }.padding(10)
            .frame(width:166, height:232)
            .background(Color.white)
            .cornerRadius(30)
    }
}


struct Today_Previews: PreviewProvider {
    static var previews: some View {
        VStack{
            Today()
            
        }
    }
}
