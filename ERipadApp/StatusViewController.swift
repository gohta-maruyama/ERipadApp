//
//  StatusViewController.swift
//  ERipadApp
//
//  Created by 丸山昂大 on 2021/12/18.
//

import UIKit
import Firebase
import SVProgressHUD

class StatusViewController: UIViewController {
    
    var hallName: String = ""
    
    @IBAction func emergencyReadyButton(_ sender: Any) {
    }
    
    @IBOutlet weak var HallNameTextLabel: UILabel!
    
    @IBOutlet weak var emergencyReadyButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        HallNameTextLabel.text = "\(hallName)会館"
        self.HallNameTextLabel.layer.borderColor = UIColor.blue.cgColor
        self.HallNameTextLabel.layer.borderWidth = 2.0
        
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
