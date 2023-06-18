//
//  Entitlement++.swift
//  IPAInstaller
//
//  Created by Alfie on 18/06/2023.
//

import Foundation

extension Entitlement {
    var valueTypeString: String {
        switch self.valueType {
        case .anyArray:
            return "Array"
        case .bool:
            return "Boolean"
        case .data:
            return "Data"
        case .dictionary:
            return "Dictionary"
        case .int:
            return "Integer"
        case .string:
            return "String"
        case .stringArray:
            return "String array"
        case .other:
            return "Other"
        }
    }
}
