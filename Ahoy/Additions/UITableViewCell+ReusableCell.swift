//
//  UITableViewCell+ReusableCell.swift
//  Ahoy
//
//  Created by Santiago Sanchez merino on 06/03/2020.
//  Copyright © 2020 Santiago Sanchez Merino. All rights reserved.
//

// Extension to provide CellId from the Cell itself
import UIKit
protocol ReusableCell {
    static var identifier: String { get }
}
extension ReusableCell {
    static var identifier: String {
        return "\(self)"
    }
}
extension UICollectionViewCell: ReusableCell {}
extension UITableViewCell: ReusableCell {}
extension UITableViewHeaderFooterView: ReusableCell {}
