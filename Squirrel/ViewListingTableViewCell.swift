//
//  ViewListingTableViewCell.swift
//  Squirrel
//
//  Created by Hannah Jiang on 4/25/20.
//  Copyright © 2020 Hannah Jiang. All rights reserved.
//

import UIKit

class ViewListingTableViewCell: UITableViewCell {
    
    @IBOutlet weak var listingImageView: UIImageView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var numBoxesLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var mainBackground: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib() 
        // In;itialization code
        setupInterface()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.listingImageView.image = UIImage(named: "squirrel")
    }
    
    func setupInterface(){
        mainBackground.layer.cornerRadius = 10.0
        mainBackground.layer.masksToBounds = false
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
