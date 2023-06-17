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
    @State private var entitlements = [Entitlement]()
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
            ForEach(entitlements) { entitlement in
                if entitlement.valueType == .string {
                    Text("\(entitlement.key) - \(entitlement.value as! String)")
                }
            }
            Spacer()
        }
        .padding()
        .onAppear {
            entitlements = parseEntitlements(entitlements: app.entitlements)
        }
    }
}

struct ApplicationDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ApplicationDetailView(app: ApplicationsManager.shared.allApps[0])
    }
}
