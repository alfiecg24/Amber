//
//  EntitlementSummaryView.swift
//  IPAInstaller
//
//  Created by Alfie on 18/06/2023.
//

import SwiftUI
import ApplicationsWrapper

struct EntitlementSummaryView: View {
    var app: LSApplicationProxy
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
           Text("Entitlements")
                .font(.title2)
                .fontWeight(.semibold)
                .fontDesign(.rounded)
            if app.parsedEntitlements.count >= 1 {
                HStack {
                    Text("Sandboxed:")
                        .fontWeight(.medium)
                    Text(app.isUnsandboxed ? "no" : "yes")
                        .foregroundColor(app.isUnsandboxed ? .red : .green)
                }
                if app.isPlatformApplication {
                    HStack {
                        Text(app.hasPersonaManagement ? "Can spawn binaries as root:" : "Can spawn binaries as mobile:")
                            .fontWeight(.medium)
                        Text("yes")
                            .foregroundColor(app.hasPersonaManagement ? .red :.orange)
                    }
                } else {
                    HStack {
                        Text("Can spawn binaries:")
                            .fontWeight(.medium)
                        Text("no")
                            .foregroundColor(.green)
                    }
                }
                HStack {
                    Text("Unrestricted app container access: ")
                        .fontWeight(.medium)
                    Text(app.hasUnrestrictedContainerAccess ? "yes" : "no")
                        .foregroundColor(app.hasUnrestrictedContainerAccess ? .red : .green)
                }
                if app.accessibleContainers.count >= 1 {
                    Text("Accessible containers: ")
                        .fontWeight(.medium)
                    ForEach(app.accessibleContainers, id: \.self) { container in
                        Text("\t• \(container.components(separatedBy: "/").last!)")
                    }
                }
                Group {
                    HStack {
                        Text("Unrestricted keychain access: ")
                            .fontWeight(.medium)
                        Text(app.hasUnrestrictedKeychainAccess ? "yes" : "no")
                            .foregroundColor(app.hasUnrestrictedKeychainAccess ? .red : .green)
                    }
                    if app.accessibleKeychainGroups.count >= 1 {
                        VStack(alignment: .leading) {
                            Text("Accessible keychain groups: ")
                                .fontWeight(.medium)
                            ForEach(app.accessibleKeychainGroups, id: \.self) { group in
                                Text("\t• \(group)")
                            }
                        }
                    }
                    if app.urlSchemes.count >= 1 {
                        VStack(alignment: .leading) {
                            Text("URL schemes: ")
                                .fontWeight(.medium)
                            ForEach(app.urlSchemes, id: \.self) { scheme in
                                Text("\t• \(scheme)")
                            }
                        }
                    }
                    if app.allowedTCCServices.count >= 1 {
                        VStack(alignment: .leading) {
                            Text("Automatically allowed TCC services: ")
                                .fontWeight(.medium)
                            ForEach(app.allowedTCCServices, id: \.self) { service in
                                Text("\t• \(service)")
                            }
                        }
                    } else {
                        HStack {
                            Text("Automatically allowed TCC services: ")
                                .fontWeight(.medium)
                            Text("none")
                                .foregroundColor(.green)
                        }
                    }
                    if app.allowedMobileGestaltKeys.count >= 1 {
                        VStack(alignment: .leading) {
                            Text("Allowed MobileGestalt keys: ")
                                .fontWeight(.medium)
                            ForEach(app.allowedMobileGestaltKeys, id: \.self) { key in
                                if let deobfuscatedKey = deobfuscatedKeys[key] {
                                    Text("\t• \(deobfuscatedKey)")
                                } else {
                                    Text("\t• \(key)")
                                }
                            }
                        }
                    }
                }
                NavigationLink(destination: {
                    EntitlementsFullView(app: app)
                }, label: {
                    Label("View all entitlements", systemImage: "list.bullet.clipboard")
                })
            } else {
                Text("None found")
                    .fontWeight(.medium)
                    .font(.title3)
            }
        }
    }
}

struct EntitlementsView_Previews: PreviewProvider {
    static var previews: some View {
        ApplicationDetailView(app: ApplicationsManager.shared.allApps[0])
    }
}
