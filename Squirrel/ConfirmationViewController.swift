//
//  ConfirmationViewController.swift
//  Squirrel
//
//  Created by Hannah Jiang on 4/24/20.
//  Copyright © 2020 Hannah Jiang. All rights reserved.
//

import UIKit

class ConfirmationViewController: UIViewController {
    
    var listing: Listing!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var acornImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        phoneLabel.text = listing.phone
        emailLabel.text = listing.email
        acornImageView.transform = acornImageView.transform.rotated(by: CGFloat(Double.pi))
        
        
    }
    
    @IBAction func doneBarButtonPressed(_ sender: UIBarButtonItem) {
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
        self.navigationController!.popToViewController(viewControllers[viewControllers.count - 5], animated: true)
    }
}




