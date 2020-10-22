//
//  APIClient.swift
//  AppleNews
//
//  Created by MacBookAir on 2020/09/21.
//  Copyright © 2020 dan. All rights reserved.
//

import Foundation

class Client {
    
    
    static var locked:Bool = false
    
    static var previousArticles: [(String,URL)] = []
    
    static func getArticle(_ urltext:String) -> [(String,URL)]{
        
        //ロック状態であれば弾き、最後にゲットした記事情報を返す。。viewがレンタリングするたびにアクセスしてたらやばいから。
        if Client.locked {           
            return self.previousArticles
        }
        
        let semaphore = DispatchSemaphore(value: 0) //同期処理を実現するためのもの。
        var articles:[(String,URL)] = []
    
        //        guard let url = URL(string: "https://api.rss2json.com/v1/api.json?rss_url=https%3A%2F%2Fnews.yahoo.co.jp%2Frss%2Ftopics%2Fit.xml") else {
        //            print("URLが間違っている可能性があります")
        //            return  [("failed", URL(string: "")!)]
        //
        //        }
        print("Client: 通信します。（通信確認用）")
        
        guard let url = URL(string: urltext) else {
            print("Client.getArticle():URLが間違っている可能性があります")
            return [("failed", URL(string: "")!)]
        }
        
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
            if let error = error{
                print(error)
                return
            }
            
            
            if let data = data{
                
                let decoder = JSONDecoder()
                
                guard let elements = try?decoder.decode(ArticleList.self, from: data) else{
                    print("Client.getArticle():decoderで失敗しました")
                    return
                    
                }
                
                
                for i in 0 ..< (elements.items.count) {
                    let item = elements.items[i]
                    articles.append((item.title,URL(string: item.link)!))
                }
                
            }
            
            semaphore.signal()
        })
        task.resume()
        semaphore.wait()
        self.lock()
        print(Client.locked)
        Client.previousArticles = articles
        print(Client.previousArticles)
        
        return articles
    }
    
    static func lock(){
        Client.locked = true
    }
    
    static func unlock(){
        Client.locked = false
    }
    
    
}


/// RSSから取得する記事リスト
struct ArticleList: Codable {
    let items: [Item]
}
/// 記事詳細
struct Item: Codable {
    let title: String
    let pubDate: String
    let link: String
    let guid: String
}


