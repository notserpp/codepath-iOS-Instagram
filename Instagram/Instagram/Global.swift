//
//  Global.swift
//  Instagram
//
//  Created by Leo Wong on 3/12/17.
//  Copyright © 2017 SpotTunes. All rights reserved.
//

import UIKit
import Parse

struct Global {
    static let author = "author"
    static let media = "media"
    static let caption = "caption"
    static let createdAt = "createdAt"
    static let height = "height"
    static let width = "width"
    static let profileImage = "profileImage"
    static let profileImageSize = CGSize(width: 100, height: 100)
    static let post = "post"
    static let likesCount = "likesCount"
    static let didPostNotificationName = Notification.Name("didPostNotification")
}

func resize(image: UIImage?, newSize: CGSize) -> UIImage? {
    if let image = image {
        let resizeImageView = UIImageView(frame: CGRect(x:0, y:0, width: newSize.width, height: newSize.height))
        resizeImageView.contentMode = .scaleAspectFill
        resizeImageView.image = image
        
        UIGraphicsBeginImageContext(resizeImageView.frame.size)
        resizeImageView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    return nil
}

/** Converts a UIImage to PFFile
 - parameter image: Image that the user wants to upload to parse
 - returns: PFFile for the the data in the image */
func getPFFileFromImage(image: UIImage?) -> PFFile? {
    if let image = image {
        if let imageData = UIImagePNGRepresentation(image) {
            return PFFile(name: "image.png", data: imageData)
        }
    }
    return nil
}

extension UIImage {
    enum JPEGQuality: CGFloat {
        case lowest  = 0
        case low     = 0.25
        case medium  = 0.5
        case high    = 0.75
        case highest = 1
    }
    
    /// Returns the data for the specified image in PNG format
    /// If the image object’s underlying image data has been purged, calling this function forces that data to be reloaded into memory.
    /// - returns: A data object containing the PNG data, or nil if there was a problem generating the data. This function may return nil if the image has no data or if the underlying CGImageRef contains data in an unsupported bitmap format.
    var png: Data? { return UIImagePNGRepresentation(self) }
    
    /// Returns the data for the specified image in JPEG format.
    /// If the image object’s underlying image data has been purged, calling this function forces that data to be reloaded into memory.
    /// - returns: A data object containing the JPEG data, or nil if there was a problem generating the data. This function may return nil if the image has no data or if the underlying CGImageRef contains data in an unsupported bitmap format.
    func jpeg(_ quality: JPEGQuality) -> Data? {
        return UIImageJPEGRepresentation(self, quality.rawValue)
    }
}

