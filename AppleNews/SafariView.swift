//
//  SafariView.swift
//  AppleNews
//
//  Created by  MacBookAir on 2020/03/21.
//  Copyright © 2020 dan. All rights reserved.
//

import SwiftUI
import SafariServices

struct SafariView: UIViewControllerRepresentable {
    var url:URL
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<SafariView>) -> SafariView.UIViewControllerType {
        return SFSafariViewController(url:url)
    }
    
    func updateUIViewController(_ uiViewController: SFSafariViewController, context: UIViewControllerRepresentableContext<SafariView>) { }
}

struct SafariView_Previews: PreviewProvider {
    static var previews: some View {
        SafariView(url: URL(string: "https://apple.com")!)
    }
}
