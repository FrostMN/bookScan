//
//  CustomTableViewCell.swift
//  bookScanTest
//
//  Created by Aaron Souer on 11/15/17.
//  Copyright © 2017 Aaron Souer. All rights reserved.
//
//  This page was created with help from
//  https://makeapppie.com/2016/10/17/custom-table-view-cells-in-swift-3/
//

import UIKit

class BookObjectTableViewCell: UITableViewCell {
    
    @IBOutlet weak var bookTitleLabel: UILabel!
    @IBOutlet weak var bookIdLabel: UILabel!
    @IBOutlet weak var bookLocationLabel: UILabel!
    @IBOutlet weak var bookAuthorLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
