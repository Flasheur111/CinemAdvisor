//
//  CommentCellController.swift
//  CinemAdvisor
//
//  Created by François BOITEUX on 22/12/2015.
//  Copyright © 2015 Epita. All rights reserved.
//

import UIKit

class CommentCellController: UITableViewCell {
    @IBOutlet var userLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var commentLabel: UILabel!
    @IBOutlet var floatRatingView: FloatRatingView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    

}
