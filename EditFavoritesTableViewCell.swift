//
//  EditFavoritesTableViewCell.swift
//  Bus
//
//  Created by Davide Spadini on 18/04/15.
//  Copyright (c) 2015 Davide Spadini. All rights reserved.
//

import UIKit

class EditFavoritesTableViewCell: UITableViewCell {

    
    @IBOutlet weak var longNameLabel: UILabel!
    @IBOutlet weak var shortNameLabel: UILabel!
    @IBOutlet weak var busImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
