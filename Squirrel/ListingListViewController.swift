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
    
    var image = Photo()
    var listings = Listings()
    var currentLocation: CLLocation!
    var photos = Photos()
    var searchRadius: Int!
    var pictionary: [String: Photo] = [:]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        
        listings.loadLocationArray(searchRadius: searchRadius, currentLocation: currentLocation) {
            self.tableView.reloadData()
        }
        
        for listing in self.listings.locationListingArray {
            self.photos.loadData(listing: listing){
                self.pictionary[listing.documentID] = self.photos.photo
            }
        }
//        for listing in self.listings.locationListingArray {
//            self.photos.loadData(listing: listing){
//                self.pictionary[listing.documentID] = self.photos.photo
//            }
//        }
       // listings.loadLocationArray(searchRadius: searchRadius, currentLocation: currentLocation) {
            //print("successfully loaded your array")
            //print ("Size of locListingArray: \(self.listings.locationListingArray.count)")
            //            for listing in self.listings.locationListingArray {
            //                print("boofy beef")
            //                self.photos.loadData(listing: listing){
            //                self.pictionary[listing.documentID] = self.photos.photo
            //            }
            //self.tableView.reloadData()
    //    }
        
        
        self.tableView.reloadData()
        // Do any additional setup after loading the view.
        
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //self.sortBasedOnSegmentPressed()
        
        //          photos.loadData(listing: listing) {
        //              print("Photo loaded!")
//        listings.loadLocationArray(searchRadius: searchRadius, currentLocation: currentLocation) {}
//        for listing in self.listings.locationListingArray {
//            self.photos.loadData(listing: listing){
//                self.pictionary[listing.documentID] = self.photos.photo
//            }
//        }
        self.tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetail" {
            let destination = segue.destination as! ListingDetailViewController
            let selectedIndexPath = tableView.indexPathForSelectedRow!
            destination.listing = listings.locationListingArray[selectedIndexPath.row]
            /*photos.loadData(listing: listings.locationListingArray[indexPath.row]){
             }
             
             self.image = self.photos.photo*/
            destination.photo = self.image
            // destination.listingImageView.image = image.image ?? UIImage(named: "squirrel")
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
        cell.distanceLabel.text = ""//you can use the IBOutlets from SpotsTableViweCell because of the "as! SpotsTableViewCell"
        if let currentLocation = currentLocation {
            cell.currentLocation = currentLocation
        }
        
        print("Loading image to cell")
        
        let blank = Photo()
        blank.image = UIImage(named: "squirrel") ?? UIImage()
        self.image = pictionary[listing.documentID] ?? blank
        
        /*if pictionary[listing.documentID] == nil {
            photos.loadData(listing: listing) {}
            self.image = self.photos.photo
            pictionary[listing.documentID] = self.image
        } else {
            self.image = pictionary[listing.documentID]!
        }*/
        
        
        //self.image = self.photos.photo
        
        
        /*photos.loadData(listing: listing){
        }
        self.image = self.photos.photo
        pictionary[listing.documentID] = self.image*/
        
        cell.configureCell(listing: listings.locationListingArray[indexPath.row], photo: self.image)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
        
    }
    
    
    
}

