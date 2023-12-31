//
//  AmberApp.swift
//  Amber
//
//  Created by Alfie on 16/06/2023.
//

import SwiftUI

@main
struct AmberApp: App {
    var body: some Scene {
        WindowGroup {
            if UserDefaults.standard.bool(forKey: "hasLaunchedBefore") {
                MainView()
                    .tint(.mainColor)
            } else {
                SplashScreenView()
                    .tint(.mainColor)
            }
        }
    }
}
