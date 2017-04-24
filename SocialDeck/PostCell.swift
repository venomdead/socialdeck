//
//  PostCell.swift
//  SocialDeck
//
//  Created by Jorge Osuna Benitez on 4/18/17.
//  Copyright © 2017 Jorge Osuna Benitez. All rights reserved.
//

import UIKit
import Firebase

class PostCell: UITableViewCell {

    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var postImg: UIImageView!
    @IBOutlet weak var caption: UITextView!
    @IBOutlet weak var likesLbl: UILabel!
    
    var post: Post!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    func configureCell(post: Post, img: UIImage? = nil) {
        self.post = post
        self.caption.text = post.caption
        self.likesLbl.text = "\(post.likes)"
        
            //download image from firebase
        if img != nil {
            self.postImg.image = img
        } else {
                let ref = FIRStorage.storage().reference(forURL: post.imageURL)
                ref.data(withMaxSize: 2 * 1024 * 1024, completion: {(data, error) in
                    if error != nil {
                        print("JORGE: Unable to download image from firebase")
                    } else {
                        print("JORGE: image downloaded successfully")
                        if let imgData = data {
                            if let img = UIImage(data: imgData) {
                                self.postImg.image = img
                                FeedVC.imageCache.setObject(img, forKey: post.imageURL as NSString)
                            }
                        }
                    }
                
                })
        
        }
        
    }
   
   

}
