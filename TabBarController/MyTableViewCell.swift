//
//  MyTableViewCell.swift
//  TabBarController
//
//  Created by Aaron on 16/9/16.
//  Copyright © 2016年 Aaron. All rights reserved.
//

import UIKit

class MyTableViewCell: UITableViewCell {

    @IBOutlet weak var currentEffectView: UIVisualEffectView!
    
    @IBOutlet weak var contentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        currentEffectView.layer.cornerRadius = 8.0
        currentEffectView.layer.masksToBounds = true
        self.backgroundColor = UIColor.clear
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
