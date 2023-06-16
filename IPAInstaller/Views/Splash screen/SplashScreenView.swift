//
//  SplashScreenView.swift
//  IPAInstaller
//
//  Created by Alfie on 16/06/2023.
//

import SwiftUI

struct SplashScreenView: View {
    @State private var isFinished = false
    var body: some View {
        VStack(alignment: .center) {
            
            Spacer()
            
            TitleView()
            
            InformationContainerView()
            
            Spacer()
            
            Button(action: {
                let generator = UINotificationFeedbackGenerator()
                generator.notificationOccurred(.success)
                isFinished.toggle()
                UserDefaults.standard.set(true, forKey: "hasLaunchedBefore")
            }) {
                Text("Continue")
                    .customButton()
            }
            .padding(.horizontal)
            .fullScreenCover(isPresented: $isFinished, content: {
                MainView()
            })
            Spacer()
        }
    }
}
