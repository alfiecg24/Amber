//
//  LSApplicationProxy++.swift
//  Amber
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
    
    func hasEntitlement(_ key: String) -> Bool {
        for ent in self.parsedEntitlements {
            if ent.key == key {
                return true
            }
        }
        return false
    }
    
    func getValueForEntitlement(_ key: String) -> Any {
        for ent in self.parsedEntitlements {
            if ent.key == key {
                return ent.value
            }
        }
        return ""
    }
    
    var parsedEntitlements: [Entitlement] {
        return parseEntitlements(entitlements: self.entitlements)
    }
    
    // Largely taken from https://github.com/opa334/TrollStore/tree/main/TrollStore/TSAppInfo.m#L764
    
    var isUnsandboxed: Bool {
        return (self.hasEntitlement("com.apple.private.security.container-required")
        || self.hasEntitlement("com.apple.private.security.no-container")
        || self.hasEntitlement("com.apple.private.security.no-sandbox"))
    }
    
    var isPlatformApplication: Bool {
        return self.hasEntitlement("platform-application")
    }
    
    var hasPersonaManagement: Bool {
        return self.hasEntitlement("com.apple.private.persona-mgmt")
    }
    
    var hasUnrestrictedContainerAccess: Bool {
        return self.hasEntitlement("com.apple.private.security.storage.AppDataContainers")
    }
    
    var accessibleContainers: [String] {
        var containersToReturn = [String]()
        if !self.hasUnrestrictedContainerAccess {
            
            if self.hasEntitlement("com.apple.developer.icloud-container-identifiers") {
                if let ids = self.getValueForEntitlement("com.apple.developer.icloud-container-identifiers") as? [String] {
                    for id in ids {
                        if !containersToReturn.contains([id]) {
                            containersToReturn.append(id)
                        }
                    }
                }
            }
            
            if self.hasEntitlement("com.apple.security.application-groups") {
                if let ids = self.getValueForEntitlement("com.apple.security.application-groups") as? [String] {
                    for id in ids {
                        if !containersToReturn.contains([id]) {
                            containersToReturn.append(id)
                        }
                    }
                }
            }
            
            if self.hasEntitlement("com.apple.security.system-groups") {
                if let ids = self.getValueForEntitlement("com.apple.security.system-groups") as? [String] {
                    for id in ids {
                        if !containersToReturn.contains([id]) {
                            containersToReturn.append(id)
                        }
                    }
                }
            }
        }
        
        return containersToReturn
    }
    
    var hasUnrestrictedKeychainAccess: Bool {
        if self.hasEntitlement("keychain-access-groups") {
            if let groups = self.getValueForEntitlement("keychain-access-groups") as? [String] {
                for group in groups {
                    if group == "*" {
                        return true
                    }
                }
            }
        }
        return false
    }
    
    var accessibleKeychainGroups: [String] {
        var groupsToReturn = [String]()
        if !self.hasUnrestrictedKeychainAccess {
            if let groups = self.getValueForEntitlement("keychain-access-groups") as? [String] {
                for group in groups {
                    if !groupsToReturn.contains([group]) {
                        groupsToReturn.append(group)
                    }
                }
            }
        }
        return groupsToReturn
    }
    
    var urlSchemes: [String] {
        var urlSchemesToReturn = [String]()
        guard self.hasEntitlement("CFBundleURLTypes") else {
            return urlSchemesToReturn
        }
        if let schemes = self.getValueForEntitlement("CFBundleURLTypes") as? [[String:[String]]] {
            for urlTypeDict in schemes {
                if let cURLSchemes = urlTypeDict["CFBundleURLSchemes"] {
                    for scheme in cURLSchemes {
                        if !urlSchemesToReturn.contains([scheme]) {
                            urlSchemesToReturn.append(scheme)
                        }
                    }
                }
            }
        }
        return urlSchemesToReturn
    }
    
    var allowedTCCServices: [String] {
        var servicesToReturn = [String]()
        if self.hasEntitlement("com.apple.private.tcc.allow") {
            if let services = self.getValueForEntitlement("com.apple.private.tcc.allow") as? [String] {
                for service in services {
                    if let displayName = commonTCCServices[service] {
                        servicesToReturn.append(displayName)
                    } else {
                        servicesToReturn.append(service.replacingOccurrences(of: "kTCCService", with: ""))
                    }
                }
            }
        } else if self.hasEntitlement("com.apple.locationd.preauthorized") {
            if let hasPreauthLocation = self.getValueForEntitlement("com.apple.locationd.preauthorized") as? Bool {
                if hasPreauthLocation { servicesToReturn.append("Location") }
            }
        }
        return servicesToReturn
    }
    
    var allowedMobileGestaltKeys: [String] {
        var keysToReturn = [String]()
        if self.hasEntitlement("com.apple.private.MobileGestalt.AllowedProtectedKeys") {
            if let allowedKeys = self.getValueForEntitlement("com.apple.private.MobileGestalt.AllowedProtectedKeys") as? [String] {
                for key in allowedKeys {
                    keysToReturn.append(key)
                }
            }
        }
        return keysToReturn
    }
    
    var isInstalledWithTrollStore: Bool {
        let path = self.bundleURL().deletingLastPathComponent()
        do {
            for file in try FileManager.default.contentsOfDirectory(atPath: path.path()) {
                if file == "_TrollStore" {
                    return true
                }
            }
        } catch let e {
            print("ERROR: \(e)")
        }
        return false
    }
    
    var isTrollStorePersistenceHelper: Bool {
        let path = self.bundleURL()
        do {
            for file in try FileManager.default.contentsOfDirectory(atPath: path.path()) {
                if file == ".TrollStorePersistenceHelper" {
                    return true
                }
            }
        } catch let e {
            print("ERROR: \(e)")
        }
        return false
    }
    
}
