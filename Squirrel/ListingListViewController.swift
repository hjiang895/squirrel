//
//  ListingListViewController.swift
//  Squirrel
//
//  Created by Hannah Jiang on 4/24/20.
//  Copyright © 2020 Hannah Jiang. All rights reserved.
//

import UIKit
import CoreLocation
import Firebase
import FirebaseUI

class ListingListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var listings = Listings()
    var currentLocation: CLLocation!
    var photos = Photos()
    var searchRadius: Int!
    var pictionary: [String: Photo] = [:]
    typealias didLoad = () -> ()
    
    func loadListingPhoto(listing: Listing, completed: @escaping didLoad) {
        self.photos.loadData(listing: listing) { () -> () in
            self.pictionary[listing.documentID] = self.photos.photo
            completed()
        }
    }
    
    func loadPictionary(completed: @escaping didLoad) {
        listings.loadLocationArray(searchRadius: searchRadius, currentLocation: currentLocation) {}
        for listing in self.listings.locationListingArray {
            loadListingPhoto(listing: listing) { () -> () in
                self.tableView.reloadData()
            }
            completed()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        loadPictionary {}
        
        // Do any additional setup after loading the view.
        
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //self.tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetail" {
            let destination = segue.destination as! ListingDetailViewController
            let selectedIndexPath = tableView.indexPathForSelectedRow!
            let listing = listings.locationListingArray[selectedIndexPath.row]
            destination.listing = listing
            destination.photo = self.pictionary[listing.documentID]
            
        } else {
            print("***ERROR: Couldn't select the selected row")
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                tableView.deselectRow(at: selectedIndexPath, animated: true)
            }
            
        }
    }
}

extension ListingListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listings.locationListingArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let listing = listings.locationListingArray[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ListingTableViewCell
        cell.locationLabel.text = "\(listing.city), \(listing.state)"
        if let currentLocation = currentLocation {
            cell.currentLocation = currentLocation
        }
        cell.distanceLabel.text = ""
        
        let blank = Photo()
        blank.image = UIImage(named: "squirrel") ?? UIImage()
        let image = pictionary[listing.documentID] ?? blank
        
        cell.configureCell(listing: listings.locationListingArray[indexPath.row], photo: image)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
        
    }
    
    
    
}

