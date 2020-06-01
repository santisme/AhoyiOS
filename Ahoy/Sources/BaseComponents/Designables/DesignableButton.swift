//
//  DesignableButton.swift
//  Ahoy
//
//  Created by Santiago Sanchez merino on 26/02/2020.
//  Copyright © 2020 Santiago Sanchez Merino. All rights reserved.
//

import UIKit

@IBDesignable
class DesignableButton: UIButton {
    
    // MARK: - Overrided Methods
    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height: buttonHeight)
    }
    
    // MARK: - IBInspectable Properties
    @IBInspectable var buttonHeight: CGFloat = 32.0 {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
            setNeedsLayout()
            
        }
    }
    
    @IBInspectable var mainButton: Bool = false {
        didSet {
            if (mainButton) {
                cancelButton = false
                secondaryButton = false
                topicFilterButton = false
                
                titleLabel?.font = AhoyUIResources.factory.font(style: .button16semibold)
                titleLabel?.textColor = AhoyUIResources.factory.color(usage: Color.ahoyButtonTextColor)
                self.setTitleColor(AhoyUIResources.factory.color(usage: Color.ahoyButtonTextColor), for: .normal)
                self.backgroundColor = AhoyUIResources.factory.color(usage: Color.ahoyButtonBackground)
                setNeedsLayout()
            }
        }
    }
    
    @IBInspectable var secondaryButton: Bool = false {
        didSet {
            if (secondaryButton) {
                mainButton = false
                cancelButton = false
                topicFilterButton = false
                titleLabel?.font = AhoyUIResources.factory.font(style: (secondaryButton) ? FontStyle.secondaryButton14regular : FontStyle.button16semibold)
                titleLabel?.textColor = AhoyUIResources.factory.color(usage: (secondaryButton) ? Color.ahoySecondaryButtonTextColor : Color.ahoyButtonTextColor)
                self.setTitleColor(AhoyUIResources.factory.color(usage: (secondaryButton) ? Color.ahoySecondaryButtonTextColor : Color.ahoyButtonTextColor), for: .normal)
                self.backgroundColor = AhoyUIResources.factory.color(usage: (secondaryButton) ?  Color.ahoySecondaryButtonBackground : Color.ahoyButtonBackground)
                setNeedsLayout()
            }
            
        }
    }
    
    @IBInspectable var cancelButton: Bool = false {
        didSet {
            if (cancelButton) {
                mainButton = false
                secondaryButton = false
                topicFilterButton = false
                titleLabel?.font = AhoyUIResources.factory.font(style: FontStyle.button16semibold)
                titleLabel?.textColor = AhoyUIResources.factory.color(usage: Color.ahoyButtonTextColor)
                self.setTitleColor(AhoyUIResources.factory.color(usage: Color.ahoyButtonTextColor), for: .normal)
                self.backgroundColor = AhoyUIResources.factory.color(usage: Color.ahoyCancelButtonBackground)
                setNeedsLayout()
            }
        }
    }
    
    @IBInspectable var topicFilterButton: Bool = false {
        didSet {
            if (topicFilterButton) {
                mainButton = false
                cancelButton = false
                secondaryButton = false
                
                titleLabel?.font = AhoyUIResources.factory.font(style: .button16semibold)
                titleLabel?.textColor = AhoyUIResources.factory.color(usage: Color.ahoyMainTextColor)
                self.setTitleColor(AhoyUIResources.factory.color(usage: Color.ahoyMainTextColor), for: .normal)
                self.backgroundColor = AhoyUIResources.factory.color(usage: Color.ahoySecondaryButtonBackground)
                setNeedsLayout()
            }
        }
    }
}
