//
// RoomCellController.swift
//  CinemAdvisor
//
//  Created by François BOITEUX on 22/12/2015.
//  Copyright © 2015 Epita. All rights reserved.
//

import UIKit

class RoomCellController: UITableViewCell {
    @IBOutlet var roomLabel: UILabel!
    @IBOutlet var floatRatingView: FloatRatingView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
