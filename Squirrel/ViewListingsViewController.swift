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
    typealias didLoad = () -> ()
    
    func loadListingPhoto(listing: Listing, completed: @escaping didLoad) {
        self.photos.loadData(listing: listing) { () -> () in
            self.pictionary[listing.documentID] = self.photos.photo
            completed()
        }
    }
    
    func loadPictionary(completed: @escaping didLoad) {
        for listing in self.listings.selfListingArray {
            loadListingPhoto(listing: listing) { () -> () in
                self.tableView.reloadData()
            }
        }
        completed()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        listings.loadYourArray {
            self.loadPictionary {}
        }
            
        // Do any additional setup after loading the view.
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //self.tableView.reloadData()
    }
    
    
}
extension ViewListingsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listings.selfListingArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListingCell", for: indexPath) as! ViewListingTableViewCell
        let listing = listings.selfListingArray[indexPath.row]
        cell.numBoxesLabel.text = "\(listing.numBoxesAvailable) Boxes Left"
        cell.locationLabel.text = "\(listing.city), \(listing.state)"
        cell.priceLabel.text = "$\(listing.price)/Box"
       
        
        let blank = UIImage(named: "tree") ?? UIImage()
        cell.listingImageView.image = pictionary[listing.documentID]?.image ?? blank
        
        return cell
    }
    
    //called whenever your table needs to know the height
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250
    }
}


