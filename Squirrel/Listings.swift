//
//  Listings.swift
//  Squirrel
//
//  Created by Hannah Jiang on 4/25/20.
//  Copyright © 2020 Hannah Jiang. All rights reserved.
//

import Foundation
import Firebase
import GeoFire

class Listings {
    var listingArray = [Listing]()
    var locationListingArray = [Listing]()
    var selfListingArray = [Listing]()
    
    
    var db: Firestore!
    
    init() {
        db = Firestore.firestore()
        
    }
    
    func loadData(completed: @escaping ()->()){
        db.collection("listings").addSnapshotListener { (querySnapshot, error) in
            guard error == nil else {
                print("***ERROR: adding the snapshot listener \(error!.localizedDescription)")
                return completed()
            }
            self.listingArray = []
            //there are questSnapshot!.documents.count documents in the spots snapshot
            for document in querySnapshot!.documents {
                let listing = Listing(dictionary: document.data())
                listing.documentID = document.documentID
                self.listingArray.append(listing)
            }
            completed()
        }
    }
    
    func loadLocationArray(searchRadius: Int, currentLocation: CLLocation, completed: @escaping ()->()){
        
        db.collection("listings").addSnapshotListener { (querySnapshot, error) in
            guard error == nil else {
                print("***ERROR: adding the snapshot listener \(error!.localizedDescription)")
                return completed()
            }
            self.locationListingArray = []
            //there are questSnapshot!.documents.count documents in the spots snapshot
            for document in querySnapshot!.documents {
                let listing = Listing(dictionary: document.data())
                let distanceInMeters = currentLocation.distance(from: listing.location)
                let distanceInMiles = (distanceInMeters*0.00062137).roundTo(places: 1)
                if(distanceInMiles <= Double(searchRadius)){
                    listing.documentID = document.documentID
                    self.locationListingArray.append(listing)
                    
                }
            }
            completed()
        }
    }
    
    func loadYourArray(completed: @escaping ()->()){
        
        db.collection("listings").addSnapshotListener { (querySnapshot, error) in
            guard error == nil else {
                print("***ERROR: adding the snapshot listener \(error!.localizedDescription)")
                return completed()
            }
            self.selfListingArray = []
            //there are questSnapshot!.documents.count documents in the spots snapshot
            for document in querySnapshot!.documents {
                let listing = Listing(dictionary: document.data())
                guard let userID = (Auth.auth().currentUser?.uid) else {
                    print("ERROR: Could not save data because we don't have a valid postingUserID")
                    return completed()
                }
                if(listing.userID == userID){
                    listing.documentID = document.documentID
                    self.selfListingArray.append(listing)
                }
            }
            completed()
        }
    }
    
}
