//
//  ApplicationDetailView.swift
//  Amber
//
//  Created by Alfie on 17/06/2023.
//

import SwiftUI
import ApplicationsWrapper

struct ApplicationDetailView: View {
    let app: LSApplicationProxy
    let manager = ApplicationsManager.shared
    private var idiom : UIUserInterfaceIdiom { UIDevice.current.userInterfaceIdiom }
    var body: some View {
        ScrollView {
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
                        if app.isBetaApp {
                            Label("Beta app", systemImage: "clock")
                        }
                        if idiom == .pad {
                            if app.isInstalledWithTrollStore {
                                Label("TrollStore app", systemImage: "square.and.arrow.down.on.square")
                            } else if app.isTrollStorePersistenceHelper {
                                Label("TrollStore persistence helper", systemImage: "arrow.triangle.2.circlepath")
                            }
                        } else {
                            if idiom == .pad {
                                if app.isInstalledWithTrollStore || app.isTrollStorePersistenceHelper {
                                    Label("TrollStore app", systemImage: "square.and.arrow.down.on.square")
                                }
                            }
                        }
                    }
                }
                HStack {
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
                    if app.isDeletable {
                        Button(action: {
                            do {
                                try manager.openApp(app)
                            } catch let e {
                                print("ERROR: \(e)")
                                let generator = UINotificationFeedbackGenerator()
                                generator.notificationOccurred(.error)
                            }
                        }, label: {
                            Text("Delete \(app.localizedName())")
                                .foregroundColor(.white)
                                .font(.headline)
                                .padding()
                                .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
                                .background(RoundedRectangle(cornerRadius: 15, style: .continuous)
                                    .fill(Color.red))
                                .padding(.bottom)
                        })
                    }
                    if idiom == .pad && (UIApplication.shared.canOpenURL(URL(string: "filza://")!) || UIApplication.shared.canOpenURL(URL(string: "santander://")!)) {
                        Button(action: {
                            if UIApplication.shared.canOpenURL(URL(string: "filza://")!) {
                                if let url = URL(string: "filza://view\(app.bundleURL())") {
                                    UIApplication.shared.open(url)
                                }
                            } else {
                                if let url = URL(string: "santander://\(app.bundleURL())") {
                                    UIApplication.shared.open(url)
                                }
                            }
                        }, label: {
                            Text("Open bundle")
                                .foregroundColor(.white)
                                .font(.headline)
                                .padding()
                                .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
                                .background(RoundedRectangle(cornerRadius: 15, style: .continuous)
                                    .fill(Color.blue))
                                .padding(.bottom)
                        })
                        Button(action: {
                            if UIApplication.shared.canOpenURL(URL(string: "filza://")!) {
                                if let url = URL(string: "filza://view\(app.containerURL())") {
                                    UIApplication.shared.open(url)
                                }
                            } else {
                                if let url = URL(string: "santander://\(app.containerURL())") {
                                    UIApplication.shared.open(url)
                                }
                            }
                        }, label: {
                            Text("Open data")
                                .foregroundColor(.white)
                                .font(.headline)
                                .padding()
                                .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
                                .background(RoundedRectangle(cornerRadius: 15, style: .continuous)
                                    .fill(Color.blue))
                                .padding(.bottom)
                        })
                    }
                }
                .frame(maxHeight: 50)
                if idiom == .phone && (UIApplication.shared.canOpenURL(URL(string: "filza://")!) || UIApplication.shared.canOpenURL(URL(string: "santander://")!)) {
                    HStack {
                        Button(action: {
                            if UIApplication.shared.canOpenURL(URL(string: "filza://")!) {
                                if let url = URL(string: "filza://view\(app.bundleURL())") {
                                    UIApplication.shared.open(url)
                                }
                            } else {
                                if let url = URL(string: "santander://\(app.bundleURL())") {
                                    UIApplication.shared.open(url)
                                }
                            }
                        }, label: {
                            Text("Open bundle")
                                .foregroundColor(.white)
                                .font(.headline)
                                .padding()
                                .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
                                .background(RoundedRectangle(cornerRadius: 15, style: .continuous)
                                    .fill(Color.blue))
                                .padding(.bottom)
                        })
                        Button(action: {
                            if UIApplication.shared.canOpenURL(URL(string: "filza://")!) {
                                if let url = URL(string: "filza://view\(app.containerURL())") {
                                    UIApplication.shared.open(url)
                                }
                            } else {
                                if let url = URL(string: "santander://\(app.containerURL())") {
                                    UIApplication.shared.open(url)
                                }
                            }
                        }, label: {
                            Text("Open data")
                                .foregroundColor(.white)
                                .font(.headline)
                                .padding()
                                .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
                                .background(RoundedRectangle(cornerRadius: 15, style: .continuous)
                                    .fill(Color.blue))
                                .padding(.bottom)
                        })
                    }
                    .frame(maxHeight: 50)
                }
                
                
                
                
                // Entitlements view
                EntitlementSummaryView(app: app)
                
                Spacer()
            }
            .padding()
        }
    }
}

struct ApplicationDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ApplicationDetailView(app: ApplicationsManager.shared.allApps[0])
    }
}
