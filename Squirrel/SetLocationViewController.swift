//
//  SetLocationViewController.swift
//  Squirrel
//
//  Created by Hannah Jiang on 4/24/20.
//  Copyright © 2020 Hannah Jiang. All rights reserved.
//

import UIKit
import GooglePlaces
import GoogleMaps
import CoreLocation

class SetLocationViewController: UIViewController {
    
    var coordinate = CLLocationCoordinate2D()
    var city = ""
    var state = ""
    var searchRadius = 5
    var currentLocation = CLLocation()
    var listings = Listings()
    var photos = Photos()
    var pictionary: [String: Photo]! = [:]
    
    
    @IBOutlet weak var lookupLocationLabel: UIButton!
    @IBOutlet weak var searchRadiusLabel: UILabel!
    @IBOutlet weak var searchRadiusSlider: UISlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        searchRadius = Int(searchRadiusSlider.value)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    func loadPictionary(){
        print("In function: loadPictionary")
        listings.loadLocationArray(searchRadius: searchRadius, currentLocation: currentLocation) {
        }
        
        print("successfully loaded your array")
        print ("Size of locListingArray: \(self.listings.locationListingArray.count)")
        for listing in self.listings.locationListingArray {
            self.photos.loadData(listing: listing){}
            self.pictionary[listing.documentID] = self.photos.photo
            print("size of pictionary \(pictionary.count)")
            
        }
    }
    
    @IBAction func lookupLocationButtonPressed(_ sender: UIButton) {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        present(autocompleteController, animated: true, completion: nil)
        //loadPictionary()
        
        
    }
    @IBAction func searchRadiusSliderChanged(_ sender: UISlider) {
        let roundedValue = round(sender.value)
        sender.value = roundedValue
        
        searchRadiusLabel.text = "\(Int(sender.value)) \(Int(sender.value) == 1 ? "mile": "miles")"
        searchRadius = Int(sender.value)
        //loadPictionary()
    }
    
    @IBAction func nextBarButtonPressed(_ sender: UIBarButtonItem) {
        //loadPictionary()
        performSegue(withIdentifier: "ShowListings", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowListings" {
            let destination = segue.destination as! ListingListViewController
            destination.searchRadius = searchRadius
            destination.currentLocation = currentLocation
            destination.listings = listings
            //loadPictionary()
            //destination.pictionary = self.pictionary
        }
    }
}
extension SetLocationViewController: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        //var address = place.formattedAddress ?? "unknown location" //need to set this to the city and state
        coordinate = place.coordinate
        currentLocation = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        for addressComponent in (place.addressComponents)! {
            for type in (addressComponent.types){
                switch(type){
                case "locality":
                    city = addressComponent.name
                    
                case "administrative_area_level_1":
                    state = addressComponent.name
                    
                default:
                    break
                }
                
            }
        }
        if(city != "" && state != ""){
            lookupLocationLabel.setTitle("\(city), \(state)", for: .normal)
        }
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}
