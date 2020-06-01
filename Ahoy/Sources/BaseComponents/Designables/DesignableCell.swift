//
//  DesignableCell.swift
//  Ahoy
//
//  Created by Santiago Sanchez merino on 23/10/2019.
//  Copyright © 2019 Santiago Sanchez Merino. All rights reserved.
//

import UIKit

@IBDesignable
class DesignableCell: UITableViewCell {
    // MARK: - Private Properties
    private let underlineLayer = CALayer()

    // MARK: - Override Methods
    override func layoutSubviews() {
        super.layoutSubviews()

        underlineLayer.frame = CGRect(
            x: 0,
            y: frame.size.height - underlineWidth,
            width: frame.size.width,
            height: frame.size.height - underlineWidth
        )
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
    
    private func refreshUndeline() {
        if (underline) {
            setupUnderline(lineWidth: underlineWidth, borderColor: underlineColor)
        }
    }
}
