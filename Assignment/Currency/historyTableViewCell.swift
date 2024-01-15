//
//  historyTableViewCell.swift
//  Assignment
//
//  Created by Atul Dhiman on 15/01/24.
//

import UIKit

class historyTableViewCell: UITableViewCell {

    @IBOutlet weak var currentLbl: UILabel!
    @IBOutlet weak var baseLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
