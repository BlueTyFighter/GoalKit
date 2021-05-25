//
//  LocationCell.swift
//  HealthKitFinalProduct
//
//  Created by Tyler Calderwood on 4/18/21.
//  Copyright © 2021 Tyler Calderwood. All rights reserved.
//

import UIKit

class LocationCell: UITableViewCell {

    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var picture: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
