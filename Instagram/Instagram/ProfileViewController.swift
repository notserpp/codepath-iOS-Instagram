//
//  ProfileViewController.swift
//  Instagram
//
//  Created by Leo Wong on 3/12/17.
//  Copyright © 2017 SpotTunes. All rights reserved.
//

import UIKit
import Parse

class ProfileViewController: UIViewController {

    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var profileImageView: UIImageView! {
        didSet {
            self.profileImageView.layer.cornerRadius = 6.0
            self.profileImageView.layer.borderWidth = 4.0
            self.profileImageView.layer.borderColor = UIColor.white.cgColor
                PFUser.current()?.loadUserProfileImage(withCompletion: { (image, error) in
                    if let image = image {
                        self.profileImageView.image = image
                    }
                })
        }
    }
    
    @IBOutlet weak var addPictureButton: UIButton! {
        didSet {
            self.addPictureButton.isEnabled = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.delegate = self
        self.addPictureButton.isEnabled = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.usernameLabel.text = PFUser.current()?.username
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onEditProfilePictureTapped(_ sender: Any) {
        let vc = UIImagePickerController()
        vc.delegate = self
        vc.allowsEditing = true
        vc.sourceType = UIImagePickerControllerSourceType.photoLibrary
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func onLogoutTapped(_ sender: Any) {
        PFUser.logOutInBackground { (error: Error?) in
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "UserDidLogout"), object: nil)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }

}

//For getting an image
extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : Any]) {
        
        // Get the image captured by the UIImagePickerController
        if let originalImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            PFUser.current()?.saveProfileImage(image: originalImage, completion: { (success, error) in
                if success {
                    self.profileImageView.image = originalImage
                }
            })
        }
        self.addPictureButton.isEnabled = false
        dismiss(animated: true, completion: nil)
    }
}

extension ProfileViewController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        print("Profile TabBar Selected")
    }
    
}

