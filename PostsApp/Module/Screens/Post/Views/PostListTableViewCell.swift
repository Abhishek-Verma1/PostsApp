//
//  PostListTableViewCell.swift
//  PostsApp
//
//  Created by Abhishek Verma on 14.02.23.
//  Copyright © 2023 JMD. All rights reserved.
//

import UIKit
import Domain

final class PostListTableViewCell: UITableViewCell {
    // MARK: - private properties
    @IBOutlet private weak var repoNameLabel: UILabel!
    @IBOutlet private weak var fullNameLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    
    // MARK: - Public methods
    public func configure(with viewItem: Post) {
        favoriteButton.setBackgroundImage(UIImage(named: "favorite"), for: .selected)
        favoriteButton.setBackgroundImage(UIImage(named: "unfavorite"), for: .normal)
        repoNameLabel.text = viewItem.title
        fullNameLabel.text = viewItem.body
        favoriteButton.isSelected = viewItem.isFavourite ?? false
        favoriteButton.tag = viewItem.id
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        favoriteButton.isSelected = false
    }
}
