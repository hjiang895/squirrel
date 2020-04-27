//
//  CreateListingTableViewController.swift
//  Squirrel
//
//  Created by Hannah Jiang on 4/24/20.
//  Copyright © 2020 Hannah Jiang. All rights reserved.
//

import UIKit
import GooglePlaces
import GoogleMaps

class CreateListingTableViewController: UITableViewController {
    
    @IBOutlet weak var priceStepper: UIStepper!
    @IBOutlet weak var lookupLocationButton: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var boxesStepper: UIStepper!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var boxesLabel: UILabel!
    @IBOutlet weak var listingImageView: UIImageView!
    @IBOutlet weak var activationLabel: UILabel!
    @IBOutlet weak var saveBarButton: UIBarButtonItem!
    
    var listing = Listing()
    var imagePicker = UIImagePickerController()
    var photo = Photo()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        //listing = Listing()
        boxesStepper.value = 10
        priceStepper.value = 5
        priceLabel.text = "$\(Int(priceStepper.value))"
        boxesLabel.text = "\(Int(boxesStepper.value))"
        
        
    }
    
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(alertAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func cameraOrLibraryAlert(){
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: .default) {_ in
            self.accessCamera()
        }
        let photoLibraryAction = UIAlertAction(title: "Photo Library", style: .default){_ in
            self.accessLibrary()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cameraAction)
        alertController.addAction(photoLibraryAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
        
    }

    func enableDisableSaveButton() {
        if listing.name == "" || listing.phone == "" || listing.email == "" || "\(lookupLocationButton.titleLabel)" == "Lookup Location" {
              saveBarButton.isEnabled = false
          } else {
              saveBarButton.isEnabled = true
          }
      }
    
    func updateImage(picture: Photo){
        listingImageView.image = picture.image
        photo = picture
    }

    @IBAction func nameTextFieldReturned(_ sender: UITextField) {
        sender.resignFirstResponder()
        listing.name = sender.text! ?? "unknown name"
        enableDisableSaveButton()
    }
    @IBAction func imageTapped(_ sender: UITapGestureRecognizer) {
        cameraOrLibraryAlert()
    }
    
    @IBAction func lookupLocationPressed(_ sender: UIButton) {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        present(autocompleteController, animated: true, completion: nil)
        enableDisableSaveButton()
    }
    
    @IBAction func emailTextField(_ sender: UITextField) {
         sender.resignFirstResponder()
        listing.email = sender.text ?? "unknown email"
        enableDisableSaveButton()
    }
    @IBAction func phoneTextField(_ sender: UITextField) {
         sender.resignFirstResponder()
        listing.phone = sender.text ?? "unknown phone"
        enableDisableSaveButton()
    }
    
    @IBAction func pricesStepperChanged(_ sender: UIStepper) {
        let roundedValue = round(sender.value)
        sender.value = roundedValue
        listing.price = Int(sender.value)
        priceLabel.text = "$\(Int(sender.value))"
    }
    @IBAction func boxesStepperChanged(_ sender: UIStepper) {
        let roundedValue = round(sender.value)
        sender.value = roundedValue
        listing.numBoxesAvailable = Int(sender.value)
        boxesLabel.text = "\(Int(sender.value))"
    }
    @IBAction func activationToggleChanged(_ sender: UISwitch) {
        listing.activationStatus = sender.isOn
    }
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        listing.name = nameTextField.text!
        
        listing.saveData { success in
            if success {
                self.photo.saveData(listing: self.listing) { completed in
                    if completed {
                        self.performSegue(withIdentifier: "ViewListings", sender: nil)
                    } else {
                        print("***ERROR: could not leave view controller because data wasn't saved")
                }
                }
            }else {
                print("***ERROR: Couldn't leave this view controller because data wasn't saved")
            }
        }
        
    }
    override func tableView(_ tableView: UITableView!, viewForHeaderInSection section: Int) -> UIView?
    {
      let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 10))
        headerView.backgroundColor = UIColor.clear
      
      return headerView
    }
}
extension CreateListingTableViewController: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        let address = place.formattedAddress ?? "unknown location" //need to set this to the city and state
        listing.coordinates = place.coordinate
        if(address != "unknown location"){
            lookupLocationButton.setTitle("\(address)", for: .normal)
        }
        for addressComponent in (place.addressComponents)! {
            for type in (addressComponent.types){
                switch(type){
                case "locality":
                    listing.city = addressComponent.name
                    
                case "administrative_area_level_1":
                    listing.state = addressComponent.name
                    
                default:
                    break
                }
                
            }
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


extension CreateListingTableViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let currentPhoto = Photo()
              currentPhoto.image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        dismiss(animated: true){
            self.updateImage(picture: currentPhoto)
        }
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    func accessLibrary() {
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
        
    }
    
    func accessCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker.sourceType = .camera
            present(imagePicker, animated: true, completion: nil)
        }else {
            showAlert(title: "Camera not available", message: "There is no camera available on this device.")
        }
    }
}




