//
//  URL++.swift
//  Amber
//
//  Created by Alfie on 16/06/2023.
//

import Foundation
extension URL {
    var isFile: Bool {
        return self.scheme == "file"
    }
    var filePath: String {
        return self.path
    }
}
