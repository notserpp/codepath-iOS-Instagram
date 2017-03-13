//
//  Post.swift
//  Instagram
//
//  Created by Leo Wong on 3/12/17.
//  Copyright © 2017 SpotTunes. All rights reserved.
//

import Parse
import UIKit

class Post: NSObject {
    
    let author: PFUser
    let caption: String
    var media: PFFile!
    let likesCount: Int
    let width: CGFloat
    let height: CGFloat
    let timestamp: String

    init(object: PFObject) {
        self.author = object[Global.author] as! PFUser
        self.caption = object[Global.caption] as! String
        self.media = object[Global.media] as! PFFile
        self.likesCount = object[Global.likesCount] as! Int
        self.width = object[Global.width] as! CGFloat
        self.height = object[Global.height] as! CGFloat
        let date = object[Global.createdAt]
//        let formatter = DateFormatter()
//        formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
//        self.timestamp = formatter.date(from: timestampString)
        
        self.timestamp = ""
    }
    
    class func postMedia(image: UIImage?, withCaption caption: String?, withCompletion completion: PFBooleanResultBlock?) {
        print("Posting Media")
        
        let post = PFObject(className: Global.post)
        post[Global.author] = PFUser.current() // Pointer column points to PFUser
        post[Global.caption] = caption
        if let image = resize(image: image, newSize: CGSize(width: 300, height: 300)) {
            post[Global.media] = getPFFileFromImage(image: image) // PFFile column
            post[Global.width] = image.size.width
            post[Global.height] = image.size.height
            print("Height \(image.size.height)")
            print("Width \(image.size.width)")
        }
        post[Global.likesCount] = 0
        post.saveInBackground(block: completion)
    }
    
    func getMedia(completion: @escaping (UIImage?, Error?) -> Void) {
        DispatchQueue.global(qos: .default).async {
            self.media.getDataInBackground { (data,error) in
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
    
    class func getPostsForUser(user: PFUser?, completion: @escaping (_ objects:[Post]? , _ error: Error?) -> Void) {
        
        guard let user = user else{
            return
        }
        let query = PFQuery(className: Global.post)
        query.whereKey(Global.author, equalTo: user)
        query.includeKey(Global.author)
        query.findObjectsInBackground { (objects, error) in
            if error == nil{
                if let objects = objects{
                    let posts = objects.map({ (object) -> Post in
                        return Post(object: object)
                    })
                    completion(posts, error)
                } else {
                    completion(nil, nil)
                }
            } else {
                completion(nil, error)
            }
        }
    }

}
