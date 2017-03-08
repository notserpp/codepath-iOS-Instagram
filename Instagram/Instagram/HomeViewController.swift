//
//  HomeViewController.swift
//  Instagram
//
//  Created by Leo Wong on 3/7/17.
//  Copyright © 2017 SpotTunes. All rights reserved.
//

import UIKit
import Parse

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onLogoutTapped(_ sender: Any) {
        print("Logout tapped")
        PFUser.logOutInBackground { (error: Error?) in
            // PFUser.currentUser() will now be nil
            self.dismiss(animated: true, completion: nil)
            //self.navigationController?.popViewController(animated: true)
            //self.navigationController?.popViewController(animated: true)
            //self.performSegue(withIdentifier: "loginSegue", sender: nil)
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
