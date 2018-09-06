//
//  PostTableViewCell.swift
//  WhyiOS
//
//  Created by Markus Varner on 9/6/18.
//  Copyright © 2018 Markus Varner. All rights reserved.
//

import UIKit

class PostTableViewCell: UITableViewCell {

    
     //MARK: - Outlets
    @IBOutlet var cohortLabel: UILabel!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var reasonLabel: UILabel!
    
    
     //MARK: - Properties
    var post: Post? {
        didSet{
            updateViews()
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }

    func updateViews(){
        
        //option 1
        guard let post = post else {return}
        nameLabel.text = post.name
        cohortLabel.text = post.cohort
        reasonLabel.text = post.reason
        
        //option 2
//        nameLabel.text = post?.name
//        cohortLabel.text = post?.cohort
//        reasonLabel.text = post?.reason
        
    }
}
