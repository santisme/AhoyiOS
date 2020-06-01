//
//  PostListPosterCell.swift
//  Ahoy
//
//  Created by Santiago Sanchez merino on 28/10/2019.
//  Copyright © 2019 Santiago Sanchez Merino. All rights reserved.
//

import UIKit

final class PostListPosterCell: UICollectionViewCell {
    // MARK: - Outlets
    @IBOutlet weak var userAvatarImage: DesignableImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    
    // MARK: - LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
