//
//  Photo.swift
//  Squirrel
//
//  Created by Hannah Jiang on 4/25/20.
//  Copyright © 2020 Hannah Jiang. All rights reserved.
//

import Foundation
import Firebase

class Photos {
    var photo: Photo
    var db: Firestore!
    
    init() {
        db = Firestore.firestore()
        photo = Photo()
    }
    
    func loadData(listing: Listing, completed: @escaping () -> ())  {
        guard listing.documentID != "" else {
            return
        }
        let storage = Storage.storage()
        db.collection("listings").document(listing.documentID).collection("photos").addSnapshotListener { (querySnapshot, error) in
            guard error == nil else {
                print("*** ERROR: adding the snapshot listener \(error!.localizedDescription)")
                return completed()
            }
            self.photo = Photo()
            let storageRef = storage.reference().child(listing.documentID)
            // there are querySnapshot!.documents.count documents in the spots snapshot
            for document in querySnapshot!.documents {
                let picture = Photo(dictionary: document.data())
                picture.documentUUID = document.documentID
                self.photo = picture
                
                // Loading in Firebase Storage images
                let photoRef = storageRef.child(self.photo.documentUUID)
                photoRef.getData(maxSize: 2 * 1024 * 1024) { data, error in
                    if let error = error {
                        print("*** ERROR: An error occurred while reading data from file ref: \(photoRef) \(error.localizedDescription)")
                        return completed()
                    } else {
                        let image = UIImage(data: data!)
                        self.photo.image = image!
                        return completed()
                    }
                }
            }
        }
    }
}
