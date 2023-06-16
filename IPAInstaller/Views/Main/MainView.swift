//
//  MainView.swift
//  IPAInstaller
//
//  Created by Alfie on 16/06/2023.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("Go and install your first app!")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .fontDesign(.rounded)
                    .multilineTextAlignment(.center)
                Text("Press the button in the toolbar\nto select an app to install.")
                    .font(.body)
                    .fontWeight(.regular)
                    .fontDesign(.rounded)
                    .multilineTextAlignment(.center)
            }
            .padding()
            .toolbar {
                ToolbarItem {
                    Button(action: {
//                        print("Add IPA")
                        do {
                            let allApps = try getAppsInstalledWithInstaller()
                        } catch let e {
                            print("ERROR: \(e.localizedDescription)")
                        }
                    }, label: {
                        Label("Install app", systemImage: "plus.circle")
                    })
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
