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
    
    var area: AreaData!
    var hall: HallData!
    var broadcast: BroadcastData!
    var broadArray: [BroadcastData] = []
    
    @IBAction func emergencyReadyButton(_ sender: Any) {
        let ref = Firestore.firestore().collection("emergencies").document(hall.id)
        ref.updateData([
            "emergencyStatus": 1
        ])
        UIView.animate(withDuration: 1.0, delay: 0.0, options: .repeat, animations: {self.emergencyReadyButton.alpha = 0.0} ) {
            (_) in
            self.emergencyReadyButton.alpha = 1.0
        }
        print("火起こしOK")
        emergencyEndButton.isHidden = false
        emergencyEndButton.isEnabled = true
    }
    @IBAction func emergencyEndButton(_ sender: Any) {
        let ref = Firestore.firestore().collection("emergencies").document(hall.id)
        ref.updateData([
            "emergencyStatus": 0
        ])
        self.emergencyReadyButton.alpha = 1.0
        
        emergencyEndButton.isHidden = true
        emergencyEndButton.isEnabled = false
    }
    
    
    @IBOutlet weak var HallNameTextLabel: UILabel!
    
    @IBOutlet weak var emergencyReadyButton: UIButton!
    @IBOutlet weak var emergencyEndButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        HallNameTextLabel.text = "\(hall.name)会館"
        self.HallNameTextLabel.layer.borderColor = UIColor.blue.cgColor
        self.HallNameTextLabel.layer.borderWidth = 2.0
        emergencyReadyButton.titleLabel?.numberOfLines = 2
        emergencyReadyButton.titleLabel?.textAlignment = NSTextAlignment.center
        
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
