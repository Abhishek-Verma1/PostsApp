//
//  UITableViewCell+Extension.swift
//  PostsApp
//
//  Created by Abhishek Verma on 14.02.23.
//  Copyright © 2023 JMD. All rights reserved.
//

import UIKit

/// Define to get the reuseIdentifier
protocol ReuseIdentifying {
    static var reuseIdentifier: String { get }
}

extension ReuseIdentifying {
    /// Will return the reuse identifier same a given class.
    static var reuseIdentifier: String {
        return String(describing: Self.self)
    }
}

extension UITableViewCell: ReuseIdentifying {}
