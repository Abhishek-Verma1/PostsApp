//
//  Bundle+Extension.swift
//  
//
//  Created by Abhishek Verma on 14.02.23.
//  Copyright © 2023 JMD. All rights reserved.
//

import Foundation

extension Bundle {
    /// Use to get the value from the .plist file by provided `key`.
    /// - Parameter key: Specify the key name.
    /// - Returns
    ///    - get the value from the provided key
    func infoForKey(_ key: String) -> String? {
        return (infoDictionary?[key] as? String)?
            .replacingOccurrences(of: "\\", with: "")
    }
}
