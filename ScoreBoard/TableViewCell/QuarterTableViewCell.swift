//
//  QuarterTableViewCell.swift
//  ScoreBoard
//
//  Created by BarryKao on 2019/11/5.
//  Copyright © 2019 BarryKao. All rights reserved.
//

import UIKit

class QuarterTableViewCell: UITableViewCell {

    
    @IBOutlet weak var quarterNumber: UILabel!
    
    @IBOutlet weak var firstScoreLabel: UILabel!
    
    @IBOutlet weak var secondScoreLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
