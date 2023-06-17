//
//  ApplicationDetailView.swift
//  IPAInstaller
//
//  Created by Alfie on 17/06/2023.
//

import SwiftUI
import ApplicationsWrapper
import NSTaskBridge

struct ApplicationDetailView: View {
    let app: LSApplicationProxy
    let manager = ApplicationsManager.shared
    var body: some View {
        VStack(alignment: .center) {
            VStack(alignment: .leading) {
                HStack(alignment: .bottom) {
                    Image(uiImage: manager.icon(forApplication: app))
                        .resizable()
                        .frame(width: 64, height: 64)
                        .cornerRadius(12)
                        .padding(.trailing)
                    VStack(alignment: .leading) {
                        Text(app.localizedName())
                            .font(.title)
                            .fontWeight(.semibold)
                            .fontDesign(.rounded)
                        Text(app.applicationIdentifier())
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    Spacer()
                }
            }
            VStack(alignment: .center) {
                HStack {
                    Label(app.isContainerized ? "Sandboxed" : "Unsandboxed", systemImage: app.isContainerized ? "lock" : "lock.open")
                        .padding()
                    Label(app.applicationType == "System" ? "System app" : "User app", systemImage: app.applicationType == "System" ? "iphone.gen3" : "person")
                        .padding()
                }
            }
            Button(action: {
                do {
                    try manager.openApp(app)
                } catch let e {
                    print("ERROR: \(e)")
                    let generator = UINotificationFeedbackGenerator()
                    generator.notificationOccurred(.error)
                }
            }, label: {
                Text("Open \(app.localizedName())")
                    .customButton()
            })
            
            Spacer()
        }
        .padding()
    }
}

struct ApplicationDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ApplicationDetailView(app: ApplicationsManager.shared.allApps[0])
    }
}
