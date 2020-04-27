//
//  CreateProfileViewController.swift
//  Squirrel
//
//  Created by Hannah Jiang on 4/24/20.
//  Copyright © 2020 Hannah Jiang. All rights reserved.
//

import UIKit
import Firebase
import FirebaseUI
import GoogleSignIn

class HomeViewController: UIViewController {

    var authUI: FUIAuth!
    
    @IBOutlet weak var acornButton: UIButton!
    @IBOutlet weak var treeButton: UIButton!
    @IBOutlet weak var squirrelButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        authUI = FUIAuth.defaultAuthUI()
        authUI.delegate = self
        setupUserInterface()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool){
        super.viewDidAppear(animated)
        signIn()
    }
    
    func setupUserInterface(){
        treeButton.layer.cornerRadius = 20.0
        squirrelButton.layer.cornerRadius = 20.0
        
        
        
    }
    func signIn() {
             let providers: [FUIAuthProvider] = [
                 FUIGoogleAuth(),]
             let currentUser = authUI.auth?.currentUser
             if authUI.auth?.currentUser == nil {
                 self.authUI?.providers = providers
                 let loginViewController = authUI.authViewController()
                 loginViewController.modalPresentationStyle = .fullScreen
                 present(loginViewController, animated: true, completion: nil)
             } else {
                // tableView.isHidden = false
             }
         }
    
    @IBAction func signOutPressed(_ sender: UIBarButtonItem) {
        do {
            try authUI!.signOut()
            print("^^^ Successfully signed out!")
            
            signIn()
        }catch {
            print("***ERROR: Couldn't sign out")
           
        }
    }

}

extension HomeViewController: FUIAuthDelegate{
    func application(_ app: UIApplication, open url: URL,
                     options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
        let sourceApplication = options[UIApplication.OpenURLOptionsKey.sourceApplication] as! String?
        if FUIAuth.defaultAuthUI()?.handleOpen(url, sourceApplication: sourceApplication) ?? false {
            return true
        }
        // other URL handling goes here.
        return false
    }
    
    func authUI(_ authUI: FUIAuth, didSignInWith user: User?, error: Error?) {
        // handle user and error as necessary
        if let user = user {
            //tableView.isHidden = false
            print("***We signed in with the user \(user.email ?? "unknown email")")
        }
    }
    
    func authPickerViewController(forAuthUI authUI: FUIAuth) -> FUIAuthPickerViewController {
        //create instance of FirebaseAuth login view controller
        let loginViewController = FUIAuthPickerViewController(authUI: authUI)
        //set background color to white
        loginViewController.view.backgroundColor = UIColor.white
        //create frame for an ImageView to hold our logo
        let marginInsets: CGFloat = 16
        let imageHeight: CGFloat = 225
        let imageY = self.view.center.y - imageHeight
        let logoFrame = CGRect(x: self.view.frame.origin.x + marginInsets, y: imageY, width: self.view.frame.width - (marginInsets*2), height: imageHeight)
        let logoImageView = UIImageView(frame: logoFrame)
        logoImageView.image = UIImage(named: "squirrel")
        logoImageView.contentMode = .scaleAspectFit
        loginViewController.view.addSubview(logoImageView)
        return loginViewController
        
    }
}
