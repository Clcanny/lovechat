//
//  RememberTableViewCell.swift
//  lovechat
//
//  Created by Demons on 2017/6/14.
//  Copyright © 2017年 Demons. All rights reserved.
//

import UIKit

class RememberTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!    
    @IBOutlet weak var beginDayLabel: UILabel!
    @IBOutlet weak var untilAfterDaysLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
