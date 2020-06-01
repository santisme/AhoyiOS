//
//  DesignableTextField.swift
//  Ahoy
//
//  Created by Santiago Sanchez merino on 26/02/2020.
//  Copyright © 2020 Santiago Sanchez Merino. All rights reserved.
//

import UIKit

@IBDesignable
class DesignableTextField: UITextField {
    
    // MARK: - Private Properties
    private let underlineLayer = CALayer()
    
    // MARK: - Overrided Methods
    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height: textFieldHeight)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        underlineLayer.frame = CGRect(
            x: 0,
            y: frame.size.height - underlineWidth,
            width: frame.size.width,
            height: frame.size.height - underlineWidth
        )
        underlineLayer.borderWidth = underlineWidth

    }
    
    // MARK: - IBInspectable Properties
    @IBInspectable var textFieldHeight: CGFloat = 35.0 {
        didSet {
            refreshUndeline()
        }
    }
    
    @IBInspectable var textFieldHorizontalPadding: CGFloat = 12.0 {
        didSet {
            refreshUndeline()
        }
    }
    
    @IBInspectable var underlineWidth: CGFloat = 1.0 {
        didSet {
            refreshUndeline()
        }
    }
    
    @IBInspectable var underlineColor: UIColor = UIColor.darkGray {
        didSet {
            refreshUndeline()
        }
    }
    
    @IBInspectable var underline: Bool = false {
        didSet {
            refreshUndeline()
        }
    }
    
    // MARK: - Private Methods
    private func setupUnderline(lineWidth: CGFloat, borderColor: UIColor) {
        // Clean previous borders
        borderStyle = .none
        
        // Set new ones
        let lineWidth: CGFloat = lineWidth
        underlineLayer.borderColor = borderColor.cgColor
        underlineLayer.frame = CGRect(
            x: 0,
            y: frame.size.height - lineWidth,
            width: frame.size.width,
            height: frame.size.height - lineWidth
        )
        underlineLayer.borderWidth = lineWidth
        
        // Add new layer to the view
        layer.addSublayer(underlineLayer)
        layer.masksToBounds = true
        
    }
    
    private func addPadding() {
        // Set side views of textField visible
//        rightViewMode = .always
        leftViewMode = .always

        // Define padding
        let paddingView = UIView(
            frame: CGRect(
                x: 0,
                y: 0,
                width: textFieldHorizontalPadding,
                height: textFieldHeight
            )
        )
        
        // Set padding
        leftView = paddingView
//        rightView = paddingView

    }
    
    private func setTextStyle() {
        font = AhoyUIResources.factory.font(style: FontStyle.textField16regular)
    }
    
    private func refreshUndeline() {
        if (underline) {
            addPadding()
            setupUnderline(lineWidth: underlineWidth, borderColor: underlineColor)
            setTextStyle()
        }
    }
    
}
