//
//  ReactionGridCell.swift
//  VIPER-REALM
//
//  Created by Oleksii Ozun on 5/3/18.
//  Copyright © 2018 Oleksii Ozun. All rights reserved.
//

import UIKit

class ReactionGridCell: UICollectionViewCell, NibRepresentable, IdentifierRepresentable {
    @IBOutlet var thumbnail: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
