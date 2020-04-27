//
//  ListingTableViewCell.swift
//  Squirrel
//
//  Created by Hannah Jiang on 4/24/20.
//  Copyright © 2020 Hannah Jiang. All rights reserved.
//

import UIKit
import CoreLocation

class ListingTableViewCell: UITableViewCell {

    @IBOutlet weak var mainBackground: UIView!

    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var listingImageView: UIImageView!
    
   
    var currentLocation: CLLocation!
    
    
    func configureCell(listing: Listing, photo: Photo){
        
        mainBackground.layer.cornerRadius = 10.0
        mainBackground.layer.masksToBounds = false
//        mainBackground.layer.shadowOffset = CGSize(width: -1, height: 1)
//        mainBackground.layer.shadowOpacity = 1
//        mainBackground.layer.cornerRadius = 10
//        mainBackground.layer.shadowColor = UIColor(named: "Orange")?.cgColor
        
        listingImageView.clipsToBounds = true
        
        locationLabel.text = "\(listing.city), \(listing.state)" //configure this to city and state
        priceLabel.text = "$\(listing.price)/Box"
        listingImageView.image = photo.image
        
        guard let currentLocation = currentLocation else {
            return
        }
        
        
        let distanceInMeters = currentLocation.distance(from: listing.location) //convert from address to location
        let distanceString = "\((distanceInMeters*0.00062137).roundTo(places: 1)) miles"
        distanceLabel.text = distanceString
    }
   
}
