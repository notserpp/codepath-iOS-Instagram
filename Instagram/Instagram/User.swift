//
//  User.swift
//  Instagram
//
//  Created by Leo Wong on 3/7/17.
//  Copyright © 2017 SpotTunes. All rights reserved.
//

import UIKit
import Parse

extension PFUser {

    class func getHomeTimeline(completion: @escaping (_ posts: [Post]?, _ error: Error?) -> Void ) {
        print("getHomeTimeline()")
        let query = PFQuery(className: Global.post)
        query.order(byDescending: Global.createdAt)
        query.includeKey(Global.author)
        query.limit = 20
        
        query.findObjectsInBackground { (postObjects : [PFObject]?, error) in
            if error == nil {
                if let postObjects = postObjects {
                    print("GetHomeTimeline Query Succeeded")
                    let posts = postObjects.map({ (object) -> Post in
                        return Post(object: object)
                    })
                    print(posts)
                    completion(posts, error)
                }
            } else {
                completion(nil, error)
            }
        }
    }
    
    func loadUserProfileImage(withCompletion completion: @escaping (UIImage?, Error?) -> Void){
        DispatchQueue.global(qos: .default).async {
            (self[Global.profileImage] as? PFFile)?.getDataInBackground { (data, error) in
                if error == nil {
                    if let data = data {
                        let image = UIImage(data: data)
                        completion(image, nil)
                    } else {
                        completion(nil, nil)
                    }
                } else {
                    completion(nil, error)
                }
            }
        }
    }
    
    func saveProfileImage(image: UIImage?, completion: PFBooleanResultBlock?){
        guard let image = image else{
            return
        }
        if let image = resize(image: image, newSize: Global.profileImageSize){
            self[Global.profileImage] = getPFFileFromImage(image: image) // PFFile column type
        }
        self.saveInBackground(block: completion)
    }

}
