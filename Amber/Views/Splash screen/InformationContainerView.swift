//
//  InformationContainerView.swift
//  Amber
//
//  Created by Alfie on 16/06/2023.
//

import SwiftUI

struct InformationContainerView: View {
    var body: some View {
        VStack(alignment: .leading) {
            InformationDetailView(title: "App manager", subTitle: "Amber can be used to manage the apps installed on your device and offers a vast amount of information on each of them.", imageName: "list.bullet.clipboard")
            
            InformationDetailView(title: "Installer", subTitle: "Amber allows you to install any .ipa or .app file onto your device with entitlements that may not normally be available.", imageName: "lock.open")
            
            InformationDetailView(title: "Security", subTitle: "Amber will give you a detailed overview of the permissions that each app has, such as personal data they may be able to access.", imageName: "exclamationmark.triangle")
        }
        .padding(.horizontal)
    }
}
