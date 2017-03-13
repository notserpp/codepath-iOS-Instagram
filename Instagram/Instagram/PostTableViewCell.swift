//
//  PostTableViewCell.swift
//  Instagram
//
//  Created by Leo Wong on 3/12/17.
//  Copyright © 2017 SpotTunes. All rights reserved.
//

import UIKit

class PostTableViewCell: UITableViewCell {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var mediaImageView: UIImageView!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var postUserLabel: UILabel!
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var createdAtLabel: UILabel!
    
    var post : Post? {
        didSet {
            print("PostTableViewCell post didSet()")
            self.usernameLabel.text = self.post?.author.username
            self.postUserLabel.text = self.post?.author.username
            
            self.mediaImageView.image = nil
            self.post?.getMedia(completion: { (image, error) in
                print("getMedia Completed")
                if let image = image {
                    print(image)
                    self.mediaImageView.image = image
                }
            })
            
            self.post?.author.loadUserProfileImage(withCompletion: { (image, error) in
                if let image = image {
                    self.profileImageView.image = image
                }
            })
            
            self.captionLabel.text = self.post?.caption
            self.likesLabel.text = "\((self.post?.likesCount)!) Likes"
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
