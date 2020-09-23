
import SwiftUI
import CoreData


 enum SpecialIconType {
    case TODAY
}



struct Icon: View {
    var managedObject:NSManagedObject
    var siteName:String
    var url:URL?
    var backgroundNum:Int //背景番号。背景ひとつひとつに番号がついている。詳しくはAdobeXDのNewsAppを参照。
    var background:LinearGradient {
        
        let color = backGroundColor()
        
        return color
        
    }
    
    var type:SpecialIconType?
    
    
    //全７種類のグラデーションの組み合わせ（Iconの背景用）
    static  var combination:[(UIColor,UIColor)] = [
//        (UIColor(hex:"00F2FE"),UIColor(hex:"4FACFE")),
        (UIColor(hex:"FB546B"),UIColor(hex:"FB546B")),
        (UIColor(hex:"FFD1FF"),UIColor(hex:"FAD0C4")),
        (UIColor(hex:"F9F586"),UIColor(hex:"96FBC4")),
        (UIColor(hex:"8DDAD5"),UIColor(hex:"00CDAC")),
        (UIColor(hex:"50A7C2"),UIColor(hex:"B7F8DB")),
        (UIColor(hex:"9795F0"),UIColor(hex:"FBC8D4")),
        (UIColor(hex:"C2E9FB"),UIColor(hex:"A1C4FD"))
    ]
    
  
    static let todayColor = ( UIColor(red: 251/255, green: 49/255, blue: 97/255, alpha: 1),
                               UIColor(red: 251/255, green: 84/255, blue: 107/255, alpha: 1))
    
    let titleText:Text
    
    
    init(_ site:Sites){
        self.siteName = site.name ?? "no given name"
        self.url = URL(string: site.url ?? "https://apple.com/jp/" )!
        self.titleText = Text(self.siteName)
        self.backgroundNum = Int(site.backgrround)
        self.managedObject = site
        
    }
    
    
    init(_ name:String, _ url:URL){
        self.siteName = name
        self.url = url
        self.titleText = Text(self.siteName)
        //Sites型の引数を取らないinitでは初期値として1番の背景を指定
        self.backgroundNum = 1
        self.managedObject = NSManagedObject()
        
    }
    

    init(_ type:SpecialIconType){
        
        switch type {
        case .TODAY:
            self.siteName = "Today"
            self.titleText = Text("Today")
            self.backgroundNum = 1
            self.managedObject = NSManagedObject()
            self.type = .TODAY


        }
    
    
    }
    
    var body: some View {
        VStack{
            return self.titleText
                .font(.title)
                .foregroundColor(Color.white)
                .fontWeight(.bold)
                .kerning(1.5)
                .padding(.horizontal, 30)
                .padding(.vertical, 10)
                .frame(height:70)
                .background(self.background)
                .clipShape(Capsule())
        }
        
    }
    

    
    private  func backGroundColor() -> LinearGradient {
        
        
        var startColor:UIColor
        var endColor:UIColor
        
        // 左上から右下にポイントを設定する。
        let start = UnitPoint.init(x: 0, y: 0) // 左上(始点)
        let end = UnitPoint.init(x: 1, y: 1) // 右下(終点)
        
        
        //特殊タイプのアイコンだった場合
        if let type = self.type {
           
            switch type {
            case .TODAY:
                startColor = Icon.todayColor.0
                endColor = Icon.todayColor.1
            }
        }else{//特殊なアイコンじゃない場合
            
            let index = self.backgroundNum//添字は0から始まるから、１を引く。 → この仕様はやめて、色ナンバーも0から始まるのに統一しました。
            
            startColor = Icon.combination[index].0
            endColor = Icon.combination[index].1
            
        }
        
        
        // 「Color」は以前の「UIColor」からの変換もできるぞ！ 助かる。
        let colors = Gradient(colors: [Color(startColor), Color(endColor)])
        
        let gradientColor = LinearGradient(gradient: colors, startPoint: start, endPoint: end)
        
        return gradientColor
    }
    
    
}




//struct back_normal: View {
//    var body: some View{
//        Circle()
//            .foregroundColor(Color.white)
//            .frame(width: 100, height: 100)
//    }
//}
//
//struct back_selected: View {
//
//    var body: some View{
//        Circle()
//            .foregroundColor(Color.gray)
//            .frame(width: 100, height: 100)
//            .shadow(radius: 4)
//
//    }
//}






struct Icon_Previews: PreviewProvider {
    //    @State static var hoge:Bool = false
    static let site:Sites = Sites()
    
    init(){
        Icon_Previews.site.name = "apple"
        Icon_Previews.site.url = "https://apple.com/jp/"
    }
    
    
    static var previews: some View {
        
        VStack{
            Icon("apple", URL(string: "https://apple.com/jp/")!)
                .frame(height: nil)
            
        }
        .frame(height: nil)
    }
}

