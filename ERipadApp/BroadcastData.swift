//
//  BroadcastData.swift
//  ERipadApp
//
//  Created by 丸山昂大 on 2021/12/18.
//

import UIKit
import Firebase

class BroadcastData: NSObject {
    var id: String
    var name: String
    var code: Int
    var status: Int
    var level: Int

    
    init(id: String, name: String, code: Int, status: Int, level: Int) {
        self.id = id
        self.name = name
        self.code = code
        self.status = status
        self.level = level
    }
    init(document: QueryDocumentSnapshot) {
        self.id = document.documentID
        
        let broadcastDic = document.data()
        
        self.name = broadcastDic["name"] as! String
        self.code = broadcastDic["code"] as! Int
        self.status = broadcastDic["status"] as! Int
        self.level = broadcastDic["level"] as! Int
        

        }
    func getPreCode() -> String {
        let preCode = String(String(self.code).prefix(3))
        return preCode
    }
    
    func isTop() -> Bool {
        let lastCode = String(String(self.code).suffix(6))
        return lastCode == "000000"
    }
    
}
