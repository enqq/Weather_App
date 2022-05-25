//
//  CityTableViewCell.swift
//  Weather_App
//
//  Created by Dawid Karpiński on 23/05/2022.
//

import UIKit

class CityTableViewCell: UITableViewCell {

    @IBOutlet weak var country: UILabel!
    @IBOutlet weak var state: UILabel!
    @IBOutlet weak var cityName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
