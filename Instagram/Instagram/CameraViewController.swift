//
//  CameraViewController.swift
//  Instagram
//
//  Created by Leo Wong on 3/11/17.
//  Copyright © 2017 SpotTunes. All rights reserved.
//

import UIKit

protocol CameraControllerDelegate: class {
    func didPost(cameraViewController: CameraViewController, uploaded: Bool)
}

class CameraViewController: UIViewController {
    
    var selected : Bool = false
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var captionTextField: UITextField!
    @IBOutlet weak var submitButton: UIButton! {
        didSet {
            self.submitButton.isEnabled = false
        }
    }
    
    weak var delegate: CameraControllerDelegate?
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.delegate = self
        if self.selected == false {
            presentPhotoPicker()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func presentPhotoPicker() {
        let vc = UIImagePickerController()
        vc.delegate = self
        vc.allowsEditing = true
        vc.sourceType = UIImagePickerControllerSourceType.photoLibrary
        self.submitButton.isEnabled = true
        self.selected = true
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func onSubmitPressed(_ sender: Any) {
        self.submitButton.isEnabled = false
        Post.postMedia(image: posterImageView.image, withCaption: captionTextField.text) { (done, error) in
            if error == nil {
                DispatchQueue.main.async {
                    print("Finished Posting Media")
                    self.resetUI()
                    self.delegate?.didPost(cameraViewController: self, uploaded: done)
                    self.tabBarController?.selectedIndex = 0 //Set to homepage
                }
            } else {
                self.submitButton.isEnabled = true
                print(error!.localizedDescription)
            }
        }
    }
    
    func resetUI() {
        self.captionTextField.text = ""
        self.posterImageView.image = nil
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }

}

//For getting an image
extension CameraViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : Any]) {
        
        // Get the image captured by the UIImagePickerController
        if let originalImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            posterImageView.image = originalImage
        }
        self.selected = true
        dismiss(animated: true, completion: nil)
    }
}

//For tabbar button press
extension CameraViewController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        print("Camera TabBar Selected")
        let tabBarIndex = tabBarController.selectedIndex
        if tabBarIndex == 1 {
            presentPhotoPicker()
        }
       self.selected = false
    }
    
}
