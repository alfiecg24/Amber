//
//  KnownEntitlements.swift
//  IPAInstaller
//
//  Created by Alfie on 17/06/2023.
//

import Foundation

struct FormattedEntitlement {
    var key: String
    var description: String
    var type: EntitlementValueType
    var valueToTriggerWarning: Any?
}

let knownEntitlements: [FormattedEntitlement] = [
    FormattedEntitlement(key: "get-task-allow", description: "Perform debugging operations", type: .bool, valueToTriggerWarning: true),
    FormattedEntitlement(key: "dynamic-codesigning", description: "Execute JIT-compiled code", type: .bool, valueToTriggerWarning: true),
    FormattedEntitlement(key: "task_for_pid-allow", description: "Obtain the task port of any process", type: .bool, valueToTriggerWarning: true),
    FormattedEntitlement(key: "com.apple.security.exception.files.absolute-path.read-write", description: "Can read and write to specified directories", type: .stringArray),
    FormattedEntitlement(key: "com.apple.security.exception.files.absolute-path.read-write", description: "Can read files in specified directories", type: .stringArray)
]
