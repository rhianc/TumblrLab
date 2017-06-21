//
//  PhotoCellTableViewCell.swift
//  Day2Lab
//
//  Created by Rhian Chavez on 6/21/17.
//  Copyright © 2017 Rhian Chavez. All rights reserved.
//

import UIKit

class PhotoCellTableViewCell: UITableViewCell {

    
    @IBOutlet weak var Picture: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
