//
//  EntitlementDetailView.swift
//  Amber
//
//  Created by Alfie on 18/06/2023.
//

import SwiftUI

struct EntitlementDetailView: View {
    let entitlement: Entitlement
    private var idiom : UIUserInterfaceIdiom { UIDevice.current.userInterfaceIdiom }
    var body: some View {
        List {
            Section(content: {
                Text(entitlement.key)
            }, header: {
                Text("Entitlement")
            })
            Section(content: {
                Text(entitlement.valueTypeString)
            }, header: {
                Text("Type")
            })
            Section(content: {
                if entitlement.valueType == .stringArray || entitlement.valueType == .anyArray {
                    if let values = entitlement.value as? [String] {
                        ForEach(values, id: \.self) { item in
                            Text(item)
                        }
                    } else {
                        Text("Could not display array - unknown types")
                    }
                } else if entitlement.valueType == .dictionary {
                    if let dict = entitlement.value as? [String:String] {
                        ForEach(Array(dict.keys), id: \.self) { key in
                            Text("\(key) - \(dict[key] ?? "No value")")
                        }
                    } else {
                        Text("Could not display dictionary - unknown types")
                    }
                } else if entitlement.valueType == .string {
                    Text(entitlement.value as! String)
                } else if entitlement.valueType == .bool {
                    Text((entitlement.value as! Bool) ? "True" : "False")
                } else if entitlement.valueType == .int {
                    Text("\(entitlement.value as! Int)")
                } else if entitlement.valueType == .data {
                    Text("\(entitlement.value as! Data)")
                } else {
                    Text("Failed to display value - unknown type")
                }
            }, header: {
                Text((entitlement.valueType == .stringArray || entitlement.valueType == .anyArray || entitlement.valueType == .dictionary) ? "Values" : "Value")
            })
        }
        .navigationTitle(idiom == .pad ? entitlement.key : "Entitlement")
        .navigationBarTitleDisplayMode(.inline)
    }
}
