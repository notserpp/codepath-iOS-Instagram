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
    
    @IBOutlet weak var tableView: UITableView!
    
    var posts: [Post]? {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.delegate = self
    }

    override func viewDidLoad() {
        print("HomeViewDidLoad")
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.estimatedRowHeight = self.tableView.rowHeight
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        NotificationCenter.default.addObserver(self, selector: #selector(didPost(notification:)), name: Global.didPostNotificationName, object: nil)

        if let postNVC = self.tabBarController?.viewControllers?[1] as? UINavigationController {
            if let postVC = postNVC.viewControllers.first as? CameraViewController {
                postVC.delegate = self
            }
        }
        self.loadTimeline()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onLogoutTapped(_ sender: Any) {
        print("Logout tapped")
        PFUser.logOutInBackground { (error: Error?) in
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "UserDidLogout"), object: nil)
        }
    }
    
    func didPost(notification: Notification) {
        print("didPost() Notification - Inserting Row")
        let indexPath = IndexPath(row: 0, section: 0)
        self.tableView.insertRows(at: [indexPath], with: .automatic)
    }
    
    func loadTimeline() {
        print("Start loadTimeline()")
        PFUser.getHomeTimeline { (posts, error) in
            if let posts = posts {
                self.posts = posts
            }
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }

}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! PostTableViewCell
        cell.post = posts?[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.posts?.count ?? 0
    }
    
}

extension HomeViewController: CameraControllerDelegate {
    func didPost(cameraViewController: CameraViewController, uploaded: Bool) {
        if uploaded {
            self.loadTimeline()
        }
    }
}

//Update timeline on home button press
extension HomeViewController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        print("Tabbar index: \(tabBarController.selectedIndex)")
        let tabBarIndex = tabBarController.selectedIndex
        if tabBarIndex == 0 {
            print("Reloading Timeline")
            self.loadTimeline()
        } else if tabBarIndex == 1 {
            let nvc = self.tabBarController?.viewControllers?[tabBarIndex] as! UINavigationController
            let vc = nvc.viewControllers[0] as! CameraViewController
            print(vc)
            self.tabBarController?.delegate = vc
        }
    }
}

