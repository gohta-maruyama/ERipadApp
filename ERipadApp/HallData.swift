//
//  HallData.swift
//  ERipadApp
//
//  Created by 丸山昂大 on 2021/12/18.
//

import UIKit
import Firebase

class HallData: NSObject {
    var id: String
    var name: String
    var broadcasts: [BroadcastData] = []
    
    init(id: String, name: String) {
        self.id = id
        self.name = name
        
    }
    init(document: QueryDocumentSnapshot) {
        self.id = document.documentID
        
        let hallDic = document.data()
        
        self.name = hallDic["name"] as! String
        
        }
    
}

