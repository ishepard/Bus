//
//  MenuTableViewCell.swift
//  Bus
//
//  Created by Davide Spadini on 16/04/15.
//  Copyright (c) 2015 Davide Spadini. All rights reserved.
//

import UIKit

class MenuTableViewCell: UITableViewCell {

    @IBOutlet weak var busMenuLabel: UILabel!
    @IBOutlet weak var busMenuImage: UIImageView!
    @IBOutlet weak var busNumberMenuLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
