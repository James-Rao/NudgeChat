//
//  PeopleTableViewCell.swift
//  NudgeChat
//
//  Created by James Rao on 6/03/2016.
//  Copyright © 2016 James Studio. All rights reserved.
//

import UIKit

class PeopleTableViewCell: UITableViewCell {
    
    // controls
    @IBOutlet weak var nameLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
