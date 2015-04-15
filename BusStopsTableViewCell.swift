//
//  BusStopsTableViewCell.swift
//  Bus
//
//  Created by Davide Spadini on 15/04/15.
//  Copyright (c) 2015 Davide Spadini. All rights reserved.
//

import UIKit

class BusStopsTableViewCell: UITableViewCell {

    @IBOutlet weak var busStopCell: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
