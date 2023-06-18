//
//  Config.swift
//  Amber
//
//  Created by Alfie on 16/06/2023.
//

import Foundation

class InstallerConfiguration: ObservableObject {
    @Published var appsInstalled: [String] = [String]()
    var jailbreakName: String = ""
    var jailbreakType: JailbreakType = .rootless
}
