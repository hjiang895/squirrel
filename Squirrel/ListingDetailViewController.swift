//
//  ListingDetailViewController.swift
//  Squirrel
//
//  Created by Hannah Jiang on 4/24/20.
//  Copyright © 2020 Hannah Jiang. All rights reserved.
//

import UIKit

class ListingDetailViewController: UIViewController {
    
    var listing: Listing!
    var photo: Photo!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var dayStepper: UIStepper!
    @IBOutlet weak var boxStepper: UIStepper!
    @IBOutlet weak var listingImageView: UIImageView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var numberBoxesLeftLabel: UILabel!
    @IBOutlet weak var numberBoxesLabel: UILabel!
    @IBOutlet weak var numberDaysLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if listing == nil {
            listing = Listing()
        }
        if photo == nil {
            photo = Photo()
        }
        
        self.updateInterface()
        print("$\(listing.price)")
        print("\(listing.name)")
        print("\(listing.numBoxesAvailable) boxes")
        
        
    }
    
    func updateInterface(){
        nameLabel.text = listing.name
        numberBoxesLabel.text = "10"
        numberDaysLabel.text = "10"
        locationLabel.text = "\(listing.city), \(listing.state)"
        numberBoxesLeftLabel.text = "\(listing.numBoxesAvailable) Boxes Left"
        totalPriceLabel.text = "Total: $\(listing.price * 10 * 10)"
        priceLabel.text = "$\(listing.price)/box per day"
        listingImageView.image =  photo.image
    }
    
      
      override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         
              let destination = segue.destination as! ConfirmationViewController
              destination.listing = listing
             
              }
              
    
    
    @IBAction func boxStepperChanged(_ sender: UIStepper) {
        numberBoxesLabel.text = "\(Int(boxStepper.value))"
        calcTotalPrice()
    }
    
    
    @IBAction func dayStepperChanged(_ sender: UIStepper) {
        numberDaysLabel.text  = "\(Int(dayStepper.value))"
        calcTotalPrice()
    }
    
    func calcTotalPrice(){
        var totalPrice = Int(boxStepper.value) * Int(dayStepper.value) * listing.price
        totalPriceLabel.text = "Total: $\(totalPrice)"
    }
}



