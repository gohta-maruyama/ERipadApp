//
//  PostTableViewCell.swift
//  ERipadApp
//
//  Created by 丸山昂大 on 2021/12/23.
//

import UIKit
import Firebase

class PostTableViewCell: UITableViewCell {
    
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setPostData(_ postData: PostData) {
        self.captionLabel.text = postData.caption
        
        self.commentLabel.text = postData.comment
        
        self.dateLabel.text = ""
        if let date = postData.date {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm"
            let dateString = formatter.string(from: date)
            self.dateLabel.text = dateString
        }
    }
    
}
