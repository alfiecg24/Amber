//
//  TitleView.swift
//  Amber
//
//  Created by Alfie on 16/06/2023.
//

import SwiftUI

struct TitleView: View {
    var body: some View {
        VStack {
            Image("LogoGreen")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 80, alignment: .center)
                .accessibility(hidden: true)

            Text("Welcome to")
                .customTitleText()

            Text("Amber")
                .customTitleText()
                .foregroundColor(.mainColor)
        }
    }
}
