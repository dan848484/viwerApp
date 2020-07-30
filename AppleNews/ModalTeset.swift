//
//  ModalTeset.swift
//  AppleNews
//
//  Created by  MacBookAir on 2020/07/26.
//  Copyright © 2020 dan. All rights reserved.
//

import SwiftUI

struct ModalTeset: View {
    @State private var bottomSheetShown = false
    var body: some View {
         GeometryReader { geometry in
                           Color.green
                           BottomSheetView(
                               isOpen: self.$bottomSheetShown,
                               maxHeight: geometry.size.height * 0.7
                           ) {
                               Color.blue
                           }
                       }.edgesIgnoringSafeArea(.all)
    }
}

struct ModalTeset_Previews: PreviewProvider {
    static var previews: some View {
        ModalTeset()
    }
}
