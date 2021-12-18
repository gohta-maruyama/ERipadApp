//
//  AreaData.swift
//  ERipadApp
//
//  Created by 丸山昂大 on 2021/12/18.
//

import UIKit
import Firebase

class AreaData: NSObject {
    var id: String
    var name: String
    var halls: [HallData] = []
    
    init(id: String, name: String) {
        self.id = id
        self.name = name
        
    }
    init(document: QueryDocumentSnapshot) {
        self.id = document.documentID
        
        let areaDic = document.data()
        
        self.name = areaDic["name"] as! String
        
        }
    
}
