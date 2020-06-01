//
//  PostListHeaderCell.swift
//  Ahoy
//
//  Created by Santiago Sanchez merino on 31/10/2019.
//  Copyright © 2019 Santiago Sanchez Merino. All rights reserved.
//

import UIKit

final class PostListHeaderCell: UITableViewCell {
    
    // MARK: - Private Properties
    private var model: PostListHeaderCellModel? = nil
    weak var delegate: PostListHeaderCellDelegate?
    
    // MARK: - Outlets
    @IBOutlet weak var topicTitleLabel: UILabel!
    @IBOutlet weak var postsCountLabel: UILabel!
    @IBOutlet weak var viewCountLabel: UILabel!
    @IBOutlet weak var updatedAtLabel: UILabel!
    @IBOutlet weak var topicTextLabel: UILabel!
    @IBOutlet weak var postersCollectionView: UICollectionView!
    @IBOutlet weak var answerButton: UIButton!
    
    // MARK: - LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    @IBAction func answerClicked(_ sender: UIButton) {
        delegate?.answerClicked()
    }
    
    private func setupView() {
        self.topicTitleLabel.text = ""
        self.postsCountLabel.text = "0"
        self.viewCountLabel.text = "0"
        self.topicTextLabel.text = ""
    }
    
}

extension PostListHeaderCell: PostListHeaderCellProtocol {
    func fillOutUI(model: PostListHeaderCellModel) {
        
        postersCollectionView.dataSource = self
        
        // Register CollectionView Cell
        let collectionCellNib = UINib(nibName: PostListPosterCell.identifier, bundle: Bundle(for: PostListPosterCell.self))
        postersCollectionView.register(collectionCellNib, forCellWithReuseIdentifier: PostListPosterCell.identifier)
        
        self.model = model
        postersCollectionView.reloadData()
        
        self.topicTitleLabel.text = self.model?.topicTitle
        self.postsCountLabel.text = "\(self.model?.postsCount ?? 0)"
        self.viewCountLabel.text = "\(self.model?.viewCount ?? 0)"
        self.topicTextLabel.text = self.model?.topicText       
        self.topicTextLabel.setNeedsLayout()
        
        let updatedAt = TimeOffsetRepository.factory.getTimeOffset(dateToCompareString: model.updatedAt)
        self.updatedAtLabel.text = (updatedAt.amount > 1) ? "\(updatedAt.amount) \(updatedAt.unit)s" : "\(updatedAt.amount) \(updatedAt.unit)"
        
        do {
            if let data = self.model?.topicText.data(using: .utf16) {
                let attribString = try NSMutableAttributedString(data: data, options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil)
                
                setPostFontAttributes(attributedString: attribString)
                
                self.topicTextLabel.attributedText = attribString
            }
            
        } catch let error {
            print(error.localizedDescription)
        }
        
    }
    
}

extension PostListHeaderCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.model?.posterList.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PostListPosterCell.identifier, for: indexPath) as? PostListPosterCell ?? PostListPosterCell()
        
        cell.userNameLabel.text = self.model?.posterList[indexPath.row].username
        cell.userNameLabel.textColor = AhoyUIResources.factory.color(usage: .ahoyMainTextColor)
        cell.userAvatarImage.image = self.model?.posterList[indexPath.row].userAvatar
        
        return cell
    }
    
}

extension PostListHeaderCell {
    private func setPostFontAttributes(attributedString: NSMutableAttributedString) {
        // Font types
        let regularFont = AhoyUIResources.factory.font(style: .body18regular)
        let boldFont = AhoyUIResources.factory.font(style: .body18bold)
        let italicFont = UIFont.italicSystemFont(ofSize: 18)
        
        // Check the font type of each character
        attributedString.enumerateAttribute(.font, in: NSRange(0..<attributedString.length)) { value, range, stop in
            attributedString.addAttributes([NSAttributedString.Key.foregroundColor : AhoyUIResources.factory.color(usage: Color.ahoyMainTextColor)], range: range)
            
            if let font = value as? UIFont {
                
                // check if input font is bold
                if font.fontDescriptor.symbolicTraits.contains(.traitBold) {
                    // Set bold font
                    attributedString.addAttribute(.font, value: boldFont, range: range)
                    
                    // check if input font is italic
                } else if font.fontDescriptor.symbolicTraits.contains(.traitItalic) {
                    // Set italic font
                    attributedString.addAttribute(.font, value: italicFont, range: range)
                } else {
                    // Set Regular font for the rest of cases
                    attributedString.addAttribute(.font, value: regularFont, range: range)
                }
            }
        }
        
    }
}

protocol PostListHeaderCellDelegate: class {
    func answerClicked()
}
