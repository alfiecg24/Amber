//
//  LSApplicationProxy++.swift
//  IPAInstaller
//
//  Created by Alfie on 17/06/2023.
//

import ApplicationsWrapper

extension LSApplicationProxy: Hashable {
    public static func == (lhs: LSApplicationProxy, rhs: LSApplicationProxy) -> Bool {
        return (lhs.applicationIdentifier() == rhs.applicationIdentifier() &&
        lhs.applicationType == rhs.applicationType &&
        lhs.bundleContainerURL == rhs.bundleContainerURL &&
        lhs.entitlements.count == rhs.entitlements.count)
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.hashValue)
    }
    
    func hasEntitlement(forKey key: String) -> Bool {
        let ents = parseEntitlements(entitlements: self.entitlements)
        for ent in ents {
            if ent.key == key {
                return true
            }
        }
        return false
    }
}
