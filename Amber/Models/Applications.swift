//
//  Applications.swift
//  IPAInstaller
//
//  Created by Alfie on 16/06/2023.
//

import Foundation
import Zip
import SwiftUI
import ApplicationsWrapper

enum ApplicationError: Error {
    case incorrectFileType
    case notAFile
    case couldNotUnzip
    case couldNotFindApp
}

struct Application: Hashable {
    var name: String
    var bundleID: String
    var path: URL
    var isSystemApp: Bool
    var isInstalledWithAmber: Bool
    var icon: UIImage
}


extension Application {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.name + self.bundleID + self.path.path())
    }
}

func handleApplicationImport(_ path: URL) throws -> Application {
    guard path.isFile else {
        throw ApplicationError.notAFile
    }
    
    guard path.pathExtension != "" && (path.pathExtension == "ipa" || path.pathExtension == "app") else {
        throw ApplicationError.incorrectFileType
    }
    
    print("Location of file: \(path)")
    
    let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    print(documentsDirectory)
    
    if path.pathExtension == "ipa" {
        do {
            print("Copying to \(path.path().replacingOccurrences(of: ".ipa", with: "") + ".zip")")
            try FileManager.default.copyItem(atPath: path.path(), toPath: "\(path.path().replacingOccurrences(of: ".ipa", with: "") + ".zip")")
        } catch let e {
            print("ERROR: \(e)")
        }
        
        let newPath = URL(string: path.path().replacingOccurrences(of: ".ipa", with: "") + ".zip")
        var unzipDirectory = URL(string: "")
        do {
            unzipDirectory = try Zip.quickUnzipFile(newPath!)
            print("Unzipped at \(unzipDirectory!.path())")
        } catch let e {
            print("ERROR: \(e)")
            throw ApplicationError.couldNotUnzip
        }
        
        var appDirectoryURL = URL(filePath: "")
        
        do {
            for file in try FileManager.default.contentsOfDirectory(atPath: unzipDirectory!.path()) {
                print(file)
                if file == "Payload" {
                    print("\(unzipDirectory!.path())Payload")
                    for file2 in try FileManager.default.contentsOfDirectory(atPath: "\(unzipDirectory!.path())Payload") {
                        print(file2)
                        appDirectoryURL = URL(filePath: "\(unzipDirectory!.path())Payload/\(file2)")
                    }
                }
            }
        } catch let e {
            print("ERROR: \(e)")
        }

        guard appDirectoryURL.path().hasSuffix(".app") else {
            print("ERROR: Could not find .app directory")
            throw ApplicationError.couldNotFindApp
        }
        
        let newDestinationURL = URL(string: "\(documentsDirectory)Temp.app")!
        if FileManager.default.fileExists(atPath: (newPath!.path())) {
            do {
                try FileManager.default.removeItem(at: newDestinationURL)
            } catch let e {
                print("ERROR: \(e)")
            }
        }
        
        do {
            try FileManager.default.copyItem(at: appDirectoryURL, to: newDestinationURL)
        } catch let e {
            print("ERROR: \(e)")
        }
        
        print("Created temporary app at \(newDestinationURL)")
        
        for file in try! FileManager.default.contentsOfDirectory(atPath: newDestinationURL.path()) {
            print(file)
        }
        
        let appIconURL = URL(string: "\(newDestinationURL.path())/AppIcon60x60@2x.png")!
        print(appIconURL.path())
        let appIcon = UIImage(contentsOfFile: appIconURL.path())!
        
        do {
            try FileManager.default.removeItem(at: newDestinationURL)
        } catch let e {
            print("ERROR: \(e)")
        }
        
        return Application(name: "TestFlight", bundleID: "com.apple.TestFlight", path: newDestinationURL, isSystemApp: false, isInstalledWithAmber: true, icon: appIcon)
        
        
    }
    return Application(name: "TestFlight", bundleID: "com.apple.TestFlight", path: URL(string: "")!, isSystemApp: false, isInstalledWithAmber: true, icon: UIImage(systemName: "gear")!)
}
