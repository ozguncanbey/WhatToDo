//
//  TableViewCell.swift
//  WhatToDo
//
//  Created by Özgün Can Beydili on 2.08.2023.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var priorityImageView: UIImageView!
    @IBOutlet weak var taskLabel: UILabel!
    @IBOutlet weak var checkedImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
