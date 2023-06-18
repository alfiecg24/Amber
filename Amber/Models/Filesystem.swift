//
//  Filesystem.swift
//  Amber
//
//  Created by Alfie on 16/06/2023.
//

import Foundation
import ApplicationsWrapper

enum FilesystemError: Error {
    case notReadable
    case notWriteable
    case doesNotExist
}

extension FilesystemError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .notReadable:
            return NSLocalizedString("Could not read contents of file or directory", comment: "Not readable")
        case .notWriteable:
            return NSLocalizedString("Could not write to file or directory", comment: "Not writable")
        case .doesNotExist:
            return NSLocalizedString("Requested file or directory does not exist", comment: "Does not exist")
        }
    }
}

func isSandboxed() -> Bool {
    !FileManager.default.isWritableFile(atPath: "/var/mobile")
}

func getAppsInstalledWithAmber() throws -> [LSApplicationProxy] {
    let manager = ApplicationsManager.shared
    let allApps = manager.allApps
//    if isSandboxed() {
//        print("ERROR: We are sandboxed")
//        throw FilesystemError.notWriteable
//    }
    var appsInstalledWithAmber = [LSApplicationProxy]()
    for app in allApps {
        do {
            for file in try FileManager.default.contentsOfDirectory(atPath: app.bundleURL().deletingLastPathComponent().path()) {
                if file == ".installed_amber" {
                    appsInstalledWithAmber.append(app)
                }
            }
        } catch let e {
            print("ERROR: \(e)")
        }
    }
    
    return appsInstalledWithAmber
}
