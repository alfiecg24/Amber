//
//  EntitlementsFullView.swift
//  IPAInstaller
//
//  Created by Alfie on 18/06/2023.
//

import SwiftUI
import ApplicationsWrapper

struct EntitlementsFullView: View {
    let app: LSApplicationProxy
    var body: some View {
        List {
            ForEach(app.parsedEntitlements, id: \.self) { entitlement in
                NavigationLink(destination: {
                    EntitlementDetailView(entitlement: entitlement)
                }, label: {
                    Text(entitlement.key)
                })
            }
        }
        .navigationViewStyle(.stack)
    }
}

struct EntitlementsFullView_Previews: PreviewProvider {
    static var previews: some View {
        EntitlementsFullView(app: ApplicationsManager.shared.allApps[0])
    }
}
