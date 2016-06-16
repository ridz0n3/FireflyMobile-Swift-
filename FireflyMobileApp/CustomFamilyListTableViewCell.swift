//
//  CustomFamilyListTableViewCell.swift
//  FireflyMobileApp
//
//  Created by ME-Tech Mac User 1 on 6/7/16.
//  Copyright © 2016 Me-tech. All rights reserved.
//

import UIKit

class CustomFamilyListTableViewCell: UITableViewCell {

    @IBOutlet weak var editBtn: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var views: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
