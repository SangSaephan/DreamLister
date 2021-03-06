//
//  ItemCell.swift
//  DreamLister
//
//  Created by Sang Saephan on 1/6/17.
//  Copyright © 2017 Sang Saephan. All rights reserved.
//

import UIKit

class ItemCell: UITableViewCell {

    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var itemLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var detailsLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(item: Item) {
        self.itemLabel.text = item.name
        self.priceLabel.text = "$\(item.price)"
        self.detailsLabel.text = item.details
        self.thumbnailImageView.image = item.toImage?.image as! UIImage?
    }

}
