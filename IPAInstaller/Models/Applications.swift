//
//  Applications.swift
//  IPAInstaller
//
//  Created by Alfie on 16/06/2023.
//

import Foundation

struct Application {
    var name: String
    var bundleID: String
    var path: URL
    var isInstalledWithInstaller: Bool
}
