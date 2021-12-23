//
//  PostData.swift
//  ERipadApp
//
//  Created by 丸山昂大 on 2021/12/23.
//

import UIKit
import Firebase

class PostData: NSObject {
    var id: String
    var caption: String?
    var comment: String?
    var date: Date?
    
    init(document: QueryDocumentSnapshot) {
        self.id = document.documentID
        
        let postDic = document.data()
        self.caption = postDic["caption"] as? String
        self.comment = postDic["comment"] as? String
        
        let timestamp = postDic["date"] as? Timestamp
        self.date = timestamp?.dateValue()
    }
    
}
