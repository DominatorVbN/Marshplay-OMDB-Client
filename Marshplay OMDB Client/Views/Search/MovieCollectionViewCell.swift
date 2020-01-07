//
//  MovieCollectionViewCell.swift
//  Marshplay OMDB Client
//
//  Created by dominator on 07/01/20.
//  Copyright © 2020 dominator. All rights reserved.
//

import UIKit

class MovieCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "MovieCell"
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
}
