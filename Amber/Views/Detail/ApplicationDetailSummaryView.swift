//
//  ApplicationDetailSummary.swift
//  Amber
//
//  Created by Alfie on 18/06/2023.
//

import SwiftUI
import ApplicationsWrapper

struct ApplicationDetailSummaryView: View {
    let app: LSApplicationProxy
    let canOpenFileManager = (UIApplication.shared.canOpenURL(URL(string: "filza://")!) || UIApplication.shared.canOpenURL(URL(string: "santander://")!))
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Details")
                .font(.title2)
                .fontWeight(.semibold)
                .fontDesign(.rounded)
            Label(app.isContainerized ? "Sandboxed" : "Unsandboxed", systemImage: app.isContainerized ? "lock" : "lock.open")
            Label(app.applicationType == "System" ? "System app" : "User app", systemImage: app.applicationType == "System" ? "iphone.gen3" : "person")
            Label(app.isBetaApp ? "Beta app": "Non-beta app", systemImage: "clock")
            
            if app.isInstalledWithTrollStore {
                Label("TrollStore app", systemImage: "square.and.arrow.down.on.square")
            } else if app.isTrollStorePersistenceHelper {
                Label("TrollStore persistence helper", systemImage: "arrow.triangle.2.circlepath")
            } else if app.isAppStoreVendable {
                Label("App Store app", systemImage: "square.and.arrow.down.on.square")
            } else {
                Label("Not App Store app", systemImage: "square.and.arrow.down.on.square")
                Label(app.isAdHocCodeSigned ? "Ad-hoc signed" : "Not ad-hoc signed", systemImage: "square.and.arrow.down.on.square")
            }
            Label(app.isLaunchProhibited ? "Launch-prohibited" : "Not launch-prohibited", systemImage: app.isLaunchProhibited ? "rectangle.badge.xmark" : "rectangle.badge.checkmark")
            
            if app.isRestricted {
                Label("Restricted", systemImage: "xmark.octagon")
            }
            if canOpenFileManager {
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
                    Label("Open bundle path", systemImage: "arrow.right.circle")
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
                    Label("Open data path", systemImage: "arrow.right.circle")
                })
            } else {
                Button(action: {
                    UIPasteboard.general.string = app.bundleURL().path()
                }, label: {
                    Label("Copy bundle path", systemImage: "arrow.right.doc.on.clipboard")
                })
                Button(action: {
                    UIPasteboard.general.string = app.containerURL().path()
                }, label: {
                    Label("Copy data path", systemImage: "arrow.right.doc.on.clipboard")
                })
            }
            
        }
    }
}
