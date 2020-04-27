//
//  Listing.swift
//  Squirrel
//
//  Created by Hannah Jiang on 4/24/20.
//  Copyright © 2020 Hannah Jiang. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit
import MapKit
import Firebase


class Listing: NSObject {
    var name: String
    var documentID: String
    var userID: String
    var city: String
    var state: String
    var coordinates: CLLocationCoordinate2D
    var price: Int
    var numBoxesAvailable: Int
    var activationStatus: Bool
    var email: String
    var phone: String
    
    var longitude: CLLocationDegrees {
        return coordinates.longitude
    }
    
    var latitude: CLLocationDegrees {
        return coordinates.latitude
    }
    
    var location: CLLocation {
        return CLLocation(latitude: latitude, longitude: longitude)
    }
    
    var dictionary: [String: Any]{
        return ["name": name, "userID": userID, "city": city, "state": state, "longitude": longitude, "latitude": latitude, "price": price, "numBoxesAvailable": numBoxesAvailable, "activationStatus": activationStatus, "email": email, "phone": phone]
    }
    
    init(name: String, documentID: String, userID: String, city: String, state: String, coordinates: CLLocationCoordinate2D, price: Int, numBoxesAvailable: Int, activationStatus: Bool, email: String, phone: String){
        self.name = name
        self.documentID = documentID
        self.userID = userID
        self.city = city
        self.state = state
        self.coordinates = coordinates
        self.price = price
        self.numBoxesAvailable = numBoxesAvailable
        self.activationStatus = activationStatus
        self.email = email
        self.phone = phone
    }
    
    convenience override init() {
        self.init(name: "", documentID: "", userID: "", city: "", state: "", coordinates: CLLocationCoordinate2D(), price: 0, numBoxesAvailable: 0, activationStatus: true, email: "", phone: "")
    }
    
    convenience init(dictionary: [String: Any]) {
        let name = dictionary["name"] as! String? ?? ""
        let userID = dictionary["userID"] as! String? ?? ""
        let city =  dictionary["city"] as! String? ?? ""
        let state = dictionary["state"] as! String? ?? ""
        let longitude = dictionary["longitude"] as! CLLocationDegrees? ?? 0.0
        let latitude = dictionary["latitude"] as! CLLocationDegrees? ?? 0.0
        let coordinates = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let price = dictionary["price"] as! Int? ?? 0
        let numBoxesAvailable = dictionary["numBoxesAvailable"] as! Int? ?? 0
        let activationStatus = dictionary["activationStatus"] as! Bool? ?? true
        let email = dictionary["email"] as! String? ?? ""
        let phone = dictionary["phone"] as! String? ?? ""
        self.init(name: name, documentID: "", userID: userID, city: city, state: state, coordinates: coordinates, price: price, numBoxesAvailable: numBoxesAvailable, activationStatus: activationStatus, email: email, phone: phone)
    }
    
    
    func saveData(completed: @escaping (Bool) -> ()) {
        let db = Firestore.firestore()
        //Grab the userID
        guard let userID = (Auth.auth().currentUser?.uid) else {
            print("ERROR: Could not save data because we don't have a valid postingUserID")
            return completed(false)
        }
        self.userID = userID
        //create the dictionary representing the data we want to save
        let dataToSave = self.dictionary
        //if we have saved a record, we'll have a documentID
        if self.documentID != "" {
            let ref = db.collection("listings").document(self.documentID)
            ref.setData(dataToSave){ (error) in
                if let error = error {
                    print("ERROR: updating document \(self.documentID)\(error.localizedDescription)")
                    completed(false)
                }else {
                    print("Document updated with ref ID \(ref.documentID)")
                    completed(true)
                }
            }
            
        }else {
            var ref: DocumentReference? = nil //let firestore create the new documentID
            ref = db.collection("listings").addDocument(data: dataToSave) {error in
                if let error = error {
                    print("ERROR: creating new document \(self.documentID)\(error.localizedDescription)")
                    completed(false)
                }else {
                    print("new document created with ref ID \(ref?.documentID ?? "unknown")")
                    self.documentID = ref?.documentID as! String
                    completed(true)
                }
            }
        }
    }
    
}
