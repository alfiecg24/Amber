//
//  Filesystem.swift
//  IPAInstaller
//
//  Created by Alfie on 16/06/2023.
//

import Foundation

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

func getAppsInstalledWithInstaller() throws -> [String] {
//    let allApps = [String]()
    if isSandboxed() {
        print("ERROR: We are sandboxed")
        throw FilesystemError.notWriteable
    }
    do {
        guard FileManager.default.isReadableFile(atPath: "/var/containers") else {
            print("ERROR: Could not read /var/containers")
            throw FilesystemError.notReadable
        }
        try FileManager.default.contentsOfDirectory(atPath: "/var/containers")
    } catch let e {
        print("ERROR: \(e)")
        throw FilesystemError.notReadable
    }
    let appsInstalledWithInstaller = [String]()
//    for app in allApps {
//        print(app)
//    }
    
    return appsInstalledWithInstaller
}
