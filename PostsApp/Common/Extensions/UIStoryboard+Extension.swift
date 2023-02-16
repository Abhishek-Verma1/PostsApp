//
//  UIStoryboard+Extension.swift
//  PostsApp
//
//  Created by Abhishek Verma on 14.02.23.
//  Copyright © 2023 JMD. All rights reserved.
//

import UIKit

extension UIStoryboard {
    /// Define all the enums case for the storyboards
    enum Name: String {
        case Main
    }
    
    convenience init(name: Name, bundle: Bundle? = nil) {
        self.init(name: name.rawValue, bundle: bundle)
    }
}
