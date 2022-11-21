//
//  FileManager-DocumentsDirectory.swift
//  HighRollers
//
//  Created by christian on 11/21/22.
//

import Foundation

extension FileManager {
    static var documentsDirectory: URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
