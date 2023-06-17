//
//  Entitlements.swift
//  IPAInstaller
//
//  Created by Alfie on 17/06/2023.
//

import Foundation

enum EntitlementValueType {
    case string
    case int
    case bool
    case stringArray
    case anyArray
    case data
    case dictionary
    case other
}

struct Entitlement: Hashable, Identifiable {
    
    let key: String
    let valueType: EntitlementValueType
    let value: Any
    var id: String { key }
    
    init(key: String, value: Any) {
        self.key = key
        if let val = value as? String {
            self.valueType = .string
            self.value = val
        } else if let val = value as? Int {
            self.valueType = .int
            self.value = val
        } else if let val = value as? Bool {
            self.valueType = .bool
            self.value = val
        } else if let val = value as? [String] {
            self.valueType = .stringArray
            self.value = val
        } else if let val = value as? [Any] {
            self.valueType = .anyArray
            self.value = val
        } else if let val = value as? Data {
            self.valueType = .data
            self.value = val
        } else if let val = value as? [String : Any] {
            self.valueType = .dictionary
            self.value = val
        } else {
            self.valueType = .other
            self.value = value
        }
    }
}

extension Entitlement {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.key)
    }
    
    static func == (lhs: Entitlement, rhs: Entitlement) -> Bool {
        return lhs.key == rhs.key
    }
}

func parseEntitlements(entitlements: [String:Any]) -> [Entitlement] {
    var entitlements = entitlements
    var parsedEntitlements = [Entitlement]()
    while entitlements.count > 0 {
        let key = entitlements.keys.first!
        let value = entitlements[key]!
        entitlements.removeValue(forKey: key)
        if let value = value as? [String:Any] {
            for (subKey, subValue) in value {
                entitlements["\(key).\(subKey)"] = subValue
            }
        } else {
            parsedEntitlements.append(Entitlement(key: key, value: value))
        }
    }
    return parsedEntitlements
}
