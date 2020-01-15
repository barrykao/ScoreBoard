//
//  GameTableViewCell.swift
//  ScoreBoard
//
//  Created by BarryKao on 2019/11/5.
//  Copyright © 2019 BarryKao. All rights reserved.
//

import UIKit

class GameTableViewCell: UITableViewCell {

    
    @IBOutlet weak var teamScore: UILabel!
    
    @IBOutlet weak var visitScore: UILabel!
    
    @IBOutlet weak var gamesNumber: UILabel!
    
    @IBOutlet weak var teamNameLabel: UILabel!
    
    @IBOutlet weak var visitNameLabel: UILabel!
    
    @IBOutlet weak var timeAllLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
