//
//  DesignableTextView.swift
//  Ahoy
//
//  Created by Santiago Sanchez merino on 24/10/2019.
//  Copyright © 2019 Santiago Sanchez Merino. All rights reserved.
//

import UIKit

class DesignableTextView: UITextView {
    // MARK: - Private Properties
    private let underlineLayer = CALayer()
    
    override func layoutSubviews() {
        super.layoutSubviews()

        underlineLayer.frame = CGRect(
            x: 1,
            y: frame.size.height - borderWidth,
            width: frame.size.width - 1,
            height: frame.size.height - borderWidth
        )
        underlineLayer.borderWidth = borderWidth

    }
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            self.layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor = .black {
        didSet {
            self.layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable var shadowColor: UIColor = .darkGray {
        didSet {
            self.layer.shadowColor = shadowColor.cgColor
        }
    }
    
    @IBInspectable var shadowOffset: CGSize = CGSize(width: 0, height: 0) {
        didSet {
            self.layer.shadowOffset = shadowOffset
        }
    }
    
    @IBInspectable var shadowRadius: CGFloat = 0 {
        didSet {
            self.layer.shadowRadius = shadowRadius
        }
    }
    
    @IBInspectable var shadowOpacity: Float = 1.0 {
        didSet {
            self.layer.shadowOpacity = shadowOpacity
        }
    }
    
    // MARK: - Private Methods
    private func setupBorder(lineWidth: CGFloat, borderColor: UIColor) {
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
    
    private func refreshUndeline() {
        if (borderWidth > 0) {
            setupBorder(lineWidth: borderWidth, borderColor: borderColor)
        }
    }
}
