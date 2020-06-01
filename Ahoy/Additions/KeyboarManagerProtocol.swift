//
//  KeyboarManagerProtocol.swift
//  Ahoy
//
//  Created by Santiago Sanchez merino on 26/02/2020.
//  Copyright © 2020 Santiago Sanchez Merino. All rights reserved.
//

import UIKit

protocol KeyboarManagerProtocol {
    var manageKeyboard: Selector { get }
    
    func registerForKeyboardNotifications(actionSelector: Selector)
    func unregisterForKeyboardNotifications()
    func animateKeyboard(size: CGFloat, duration: TimeInterval)
    
}

// MARK: - Extension KeyboarManagerProtocol to define default implementations
extension KeyboarManagerProtocol {
    func registerForKeyboardNotifications(actionSelector: Selector) {
        NotificationCenter.default.addObserver(self, selector: actionSelector, name:
            UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: actionSelector, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unregisterForKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self)
    }
    
}
