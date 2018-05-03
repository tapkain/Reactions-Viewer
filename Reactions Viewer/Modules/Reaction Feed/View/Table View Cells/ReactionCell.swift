//
//  ReactionCell.swift
//  VIPER-REALM
//
//  Created by Oleksii Ozun on 5/1/18.
//  Copyright © 2018 Oleksii Ozun. All rights reserved.
//

import UIKit

public class ReactionCell: UITableViewCell, NibRepresentable, IdentifierRepresentable {
    @IBOutlet public var title: UILabel!
    @IBOutlet public var details: UILabel!
    @IBOutlet public var displayname: UILabel!
    @IBOutlet public var username: UILabel!
    @IBOutlet public var avatar: UIImageView!
    @IBOutlet public var thumbnail: UIImageView!
    
    override public  func awakeFromNib() {
        super.awakeFromNib()
        avatar.layer.masksToBounds = true
        avatar.layer.cornerRadius = avatar.layer.bounds.width/2.0
    }
    
    override public  func prepareForReuse() {
        super.prepareForReuse()
        title.text = ""
        details.text = ""
        displayname.text = ""
        username.text = ""
        avatar.image = nil
        thumbnail.image = nil
    }
}
