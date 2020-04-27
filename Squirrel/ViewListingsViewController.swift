//
//  ViewListingsViewController.swift
//  Squirrel
//
//  Created by Hannah Jiang on 4/24/20.
//  Copyright © 2020 Hannah Jiang. All rights reserved.
//

import UIKit
import CoreLocation
import Firebase
import FirebaseUI

class ViewListingsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var listings = Listings()
    var photos = Photos()
    var pictionary: [String: Photo] = [:]
    //var locationManager: CLLocationManager!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        
        listings.loadYourArray {
            self.tableView.reloadData()
            }
        for listing in self.listings.selfListingArray {
            self.photos.loadData(listing: listing) {
                self.pictionary[listing.documentID] = self.photos.photo
    }
        }
            
        // Do any additional setup after loading the view.
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //            listings.loadData {
        //                // self.sortBasedOnSegmentPressed()
        //                self.tableView.reloadData()
        //            }
        self.tableView.reloadData()
        //        for listing in listings.selfListingArray{
        //            photos.loadData(listing: listing) {
        //                print("Loaded Photos Successfully")
        //            }
        //        }
    }
    
    
}
extension ViewListingsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //print("This is the number of rows \(listings.selfListingArray.count)")
        return listings.selfListingArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListingCell", for: indexPath) as! ViewListingTableViewCell
        let listing = listings.selfListingArray[indexPath.row]
        cell.numBoxesLabel.text = "\(listing.numBoxesAvailable) Boxes Left"
        cell.locationLabel.text = "\(listing.city), \(listing.state)"
        cell.priceLabel.text = "$\(listing.price)/Box"
       
        
        /*var image = Photo()
        
        photos.loadData(listing: listings.selfListingArray[indexPath.row]){
            image = self.photos.photo 
        }
        
        cell.listingImageView.image = image.image*/
        
        /*if pictionary[listing.documentID] == nil {
            photos.loadData(listing: listing) {}
            cell.listingImageView.image = self.photos.photo.image
            pictionary[listing.documentID] = self.photos.photo
        } else {
            cell.listingImageView.image = pictionary[listing.documentID]?.image
        }*/
        
        let blank = UIImage(named: "tree") ?? UIImage()
        cell.listingImageView.image = pictionary[listing.documentID]?.image ?? blank
        
        return cell
    }
    
    //called whenever your table needs to know the height
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250
    }
}


