//
//  GradientMaker.swift
//  AppleNews
//
//  Created by  MacBookAir on 2020/06/02.
//  Copyright © 2020 dan. All rights reserved.
//

import Foundation
import SwiftUI

class GradientMaker{
    public static  func backGroundColor(colorNum:Int) -> LinearGradient {
        if colorNum > 7 {
            return LinearGradient(gradient: Gradient(colors: [Color.white, Color.black]), startPoint: UnitPoint.init(x: 0, y: 0), endPoint: UnitPoint.init(x:1,y:1))
        }
        
            // 左上から右下にポイントを設定する。
            let start = UnitPoint.init(x: 0, y: 0) // 左上(始点)
            let end = UnitPoint.init(x: 1, y: 1) // 右下(終点)
            
        let index:Int = colorNum//添字は0から始まるから、１を引く。(なんか合わないのでやめました。)
         
            let startColor:UIColor = Icon.combination[index].0
            let endColor:UIColor = Icon.combination[index].1
            
            // 「Color」は以前の「UIColor」からの変換もできるぞ！ 助かる。
            let colors = Gradient(colors: [Color(startColor), Color(endColor)])
            

            let gradientColor = LinearGradient(gradient: colors, startPoint: start, endPoint: end)
            
            return gradientColor
        }
}
