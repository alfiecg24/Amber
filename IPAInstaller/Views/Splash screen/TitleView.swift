//
//  TitleView.swift
//  IPAInstaller
//
//  Created by Alfie on 16/06/2023.
//

import SwiftUI

struct TitleView: View {
    var body: some View {
        VStack {
            Image(systemName: "square.and.arrow.down")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 80, alignment: .center)
                .accessibility(hidden: true)

            Text("Welcome to")
                .customTitleText()

            Text("Installer")
                .customTitleText()
                .foregroundColor(.mainColor)
        }
    }
}
