//
//  InformationContainerView.swift
//  IPAInstaller
//
//  Created by Alfie on 16/06/2023.
//

import SwiftUI

struct InformationContainerView: View {
    var body: some View {
        VStack(alignment: .leading) {
            InformationDetailView(title: "Install any app", subTitle: "Installer can be used to install any .ipa or .app file to your jailbroken iOS device, regardless of codesigning.", imageName: "square.and.arrow.down.on.square")
            
            InformationDetailView(title: "Custom entitlements", subTitle: "Installer allows you use any entitlement that you want, giving apps permissions that they wouldn't normally have.", imageName: "lock.open")
            
            InformationDetailView(title: "No re-signing", subTitle: "Any apps installed with Installer will remained available to use as long as your device is jailbroken.", imageName: "arrow.triangle.2.circlepath")
        }
        .padding(.horizontal)
    }
}
