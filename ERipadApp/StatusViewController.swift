//
//  StatusViewController.swift
//  ERipadApp
//
//  Created by 丸山昂大 on 2021/12/18.
//

import UIKit
import Firebase
import SVProgressHUD

class StatusViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var area: AreaData!
    var hall: HallData!
    var broadcast: BroadcastData!
    var broadArray: [BroadcastData] = []
    var listener: ListenerRegistration?
    
    @IBAction func emergencyReadyButton(_ sender: Any) {
        let ref = Firestore.firestore().collection("emergencies").document(hall.id)
        ref.updateData([
            "emergencyStatus": 1
        ])
        
        print("火起こしOK")
        emergencyEndButton.isHidden = false
        emergencyEndButton.isEnabled = true
        emergencyReadyButton.isEnabled = false
        emergencyReadyButton.isHidden = true
        emergencyReadyFakeButton.isHidden = false
    }
    @IBAction func emergencyEndButton(_ sender: Any) {
        let ref = Firestore.firestore().collection("emergencies").document(hall.id)
        ref.updateData([
            "emergencyStatus": 0
        ])
        
        emergencyEndButton.isHidden = true
        emergencyEndButton.isEnabled = false
        emergencyReadyButton.isHidden = false
        emergencyReadyButton.isEnabled = true
        emergencyReadyFakeButton.isHidden = true
    }
    
    
    @IBOutlet weak var HallNameTextLabel: UILabel!
    
    @IBOutlet weak var emergencyReadyButton: UIButton!
    @IBOutlet weak var emergencyEndButton: UIButton!
    @IBOutlet weak var emergencyReadyFakeButton: UIButton!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        HallNameTextLabel.text = "\(hall.name)会館"
        self.HallNameTextLabel.layer.borderColor = UIColor.blue.cgColor
        self.HallNameTextLabel.layer.borderWidth = 2.0
        
        UIView.animate(withDuration: 1.0, delay: 0.0, options: .repeat, animations: {self.emergencyReadyFakeButton.alpha = 0.0} ) {
            (_) in
            self.emergencyReadyFakeButton.alpha = 1.0
        }
        
        // Do any additional setup after loading the view.
        if Auth.auth().currentUser != nil {
            let broadRef = Firestore.firestore().collection("areas").document(area!.id).collection("halls").document(hall!.id).collection("broadcasts").order(by: "code")
            broadRef.getDocuments() { (querySnapshot, error) in
                if let error = error {
                    print("DEBUG_PRINT: snapshotの取得が失敗しました。 \(error)")
                    return
                }
                self.broadArray = querySnapshot!.documents.map { document in
                    let broadcast = BroadcastData(document: document)
                    print("DEBUG_PRINT: document取得 \(broadcast.name)")

                    return broadcast

                }
                self.collectionView.reloadData()
            }
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return broadArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        
        let label = cell.contentView.viewWithTag(1) as? UILabel
        label?.text = broadArray[indexPath.row].name
        
//        cell.layer.borderColor = UIColor.black.cgColor
        cell.layer.borderWidth = 5.0
        if broadArray[indexPath.row].level == 1 {
            cell.layer.borderColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1).cgColor
        } else if broadArray[indexPath.row].level == 2 {
            cell.layer.borderColor = UIColor(red: 0.35, green: 0.35, blue: 0.35, alpha: 1).cgColor
        } else if broadArray[indexPath.row].level == 3 {
            cell.layer.borderColor = UIColor(red: 0.50, green: 0.50, blue: 0.50, alpha: 1).cgColor
        } else if broadArray[indexPath.row].level == 4 {
            cell.layer.borderColor = UIColor(red: 0.75, green: 0.75, blue: 0.75, alpha: 1).cgColor
        } else {
            cell.layer.borderColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1).cgColor
        }
        
        func viewWillAppear(_ animated: Bool) {
            listener = Firestore.firestore().collection("areas").document(area.id).collection("halls").document(hall.id).collection("broadcasts").addSnapshotListener { documentSnapshot, error in
                if let error = error {
                    print("ドキュメントの取得に失敗しました",error)
                } else {
                    self.broadArray = documentSnapshot!.documents.map { document in
                        let broadcast = BroadcastData(document: document)
                        return broadcast
                    }
                }
                
                if self.broadcast.status == 0 {
                    cell.backgroundColor = .white
                } else if self.broadcast.status == 1 {
                    cell.backgroundColor = .cyan
                } else if self.broadcast.status == 2 {
                    cell.backgroundColor = .yellow
                } else if self.broadcast.status == 3 {
                    cell.backgroundColor = .green
                } else if self.broadcast.status == 4 {
                    cell.backgroundColor = .orange
                }
                
                
            }
        }
        
        return cell
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        listener = Firestore.firestore().collection("areas").document(area.id).collection("halls").document(hall.id).collection("broadcasts").addSnapshotListener { documentSnapshot, error in
//                   if let error = error {
//                       print("ドキュメントの取得に失敗しました",error)
//                   } else {
//                       self.broadArray = documentSnapshot!.documents.map { document in
//                           let broadcast = BroadcastData(document: document)
//                           return broadcast
//
//                           if self.broadcast.status == 1 {
//
//                               }
//                           }
//                       }
//                   }
//    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
