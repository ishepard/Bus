//
//  BusTableViewCell.swift
//  Bus
//
//  Created by Davide Spadini on 13/04/15.
//  Copyright (c) 2015 Davide Spadini. All rights reserved.
//

import UIKit

class BusTableViewCell: UITableViewCell {

    @IBOutlet weak var busImage: UIImageView!
    @IBOutlet weak var busLabel: UILabel!
    @IBOutlet weak var busLabelImage: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
