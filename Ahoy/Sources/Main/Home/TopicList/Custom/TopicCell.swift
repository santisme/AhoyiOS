//
//  TopicCell.swift
//  Ahoy
//
//  Created by Santiago Sanchez merino on 17/10/2019.
//  Copyright © 2019 Santiago Sanchez Merino. All rights reserved.
//

import UIKit

@IBDesignable
final class TopicCell: UITableViewCell {

    // MARK: - Outlets
    @IBOutlet weak var userAvatar: DesignableImageView!
    @IBOutlet weak var topicTitleLabel: UILabel!
    @IBOutlet weak var postCountLabel: UILabel!
    @IBOutlet weak var viewCountLabel: UILabel!
    @IBOutlet weak var createdAtLabel: UILabel!
    
    // MARK: - Private Properties
    let shapeLayer = CAShapeLayer()
    
    // MARK: - Inspectable variables
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            contentView.layer.cornerRadius = cornerRadius
            contentView.layer.masksToBounds = cornerRadius > 0
        }
    }

    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            contentView.layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor = .black {
        didSet {
            contentView.layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable var categoryColor: UIColor = .green {
        didSet {
            contentView.backgroundColor = categoryColor
        }
    }
    
    @IBInspectable var shadowColor: UIColor = .darkGray {
        didSet {
            shapeLayer.shadowColor = shadowColor.cgColor
        }
    }
    
    @IBInspectable var shadowOffset: CGSize = CGSize(width: 0, height: 0) {
        didSet {
            shapeLayer.shadowOffset = shadowOffset
        }
    }
    
    @IBInspectable var shadowRadius: CGFloat = 0 {
        didSet {
            shapeLayer.shadowRadius = shadowRadius
        }
    }
    
    @IBInspectable var shadowOpacity: Float = 1.0 {
        didSet {
            shapeLayer.shadowOpacity = shadowOpacity
        }
    }
    
    // MARK: - LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        topicTitleLabel.text = ""
        postCountLabel.text = "0"
        viewCountLabel.text = "0"
        createdAtLabel.text = ""

    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        addInnerShadowLayer()

    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    
    // MARK: - Private Methods
    private func addInnerShadowLayer() {
        clipsToBounds = true
        let shPath = UIBezierPath()
        shPath.move(to: CGPoint(x: 0 , y: self.frame.height-shadowOffset.height))
        
        shPath.addLine(to: CGPoint(x: self.frame.width , y: self.frame.height-shadowOffset.height))
        shPath.addLine(to: CGPoint(x: self.frame.width, y: self.frame.height))
        shPath.addLine(to: CGPoint(x: 0, y: self.frame.height))
        
        shapeLayer.shadowPath = shPath.cgPath
        self.layer.addSublayer(shapeLayer)

    }

}
