//
//  ViewController+Extension.swift
//  PostsApp
//
//  Created by Abhishek Verma on 14.02.23.
//  Copyright © 2023 JMD. All rights reserved.
//

import UIKit

extension UIViewController {
    /// This display the alert with given message `.
    /// - Parameters
    ///     - message:  Use to provide the message for alert.
    func showAlert(_ message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .default))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    /// This methods will use to get the storyboardID same as controller name.
    static func storyboardID() -> String {
        return String(describing: self)
    }
    
    func hideKeyboardWhenTappedAround(viewToTap: UIView? = nil) {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        if let viewToTap = viewToTap {
            viewToTap.addGestureRecognizer(tap)
        } else {
            view.addGestureRecognizer(tap)
        }
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
