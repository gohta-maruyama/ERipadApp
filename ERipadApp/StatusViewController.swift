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
    var topBroadcasts: [BroadcastData] = []
    var childBroadcasts: [String: [BroadcastData]] = [:]
    
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
            "emergencyStatus": 2
        ])
        
        print("火起こし終了指示OK")
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
        
        
        guard let headerSize = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout else {return}
        headerSize.headerReferenceSize = CGSize(width: self.view.bounds.width, height: 100)
        
        guard let cellSize = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout else {return}
        cellSize.itemSize = CGSize(width: 200, height: 80)
        
        guard let cellLayout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout else {return}
        cellLayout.sectionInset = UIEdgeInsets(top: 10, left: 0 , bottom: 20, right: 0)
        
        // Do any additional setup after loading the view.

    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "BroadcastHeader", for: indexPath) as! BroadcastHeaderView
        header.layer.borderColor = UIColor.black.cgColor
        header.layer.borderWidth = 5.0
        if kind == UICollectionView.elementKindSectionHeader {
            let topBroadcast = topBroadcasts[indexPath.section]
            header.headLabel.text = topBroadcast.name
            if topBroadcast.status == 0 {
                header.backgroundColor = .white
            }else if topBroadcast.status == 1 {
                header.backgroundColor = .cyan
            }else if topBroadcast.status == 2 {
                header.backgroundColor = .yellow
            }else if topBroadcast.status == 3 {
                header.backgroundColor = .green
            }else if topBroadcast.status == 4 {
                header.backgroundColor = .orange
            }else if topBroadcast.status == 5 {
                header.backgroundColor = .purple
            }
            return header
        }
        return UICollectionReusableView()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return topBroadcasts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let topBroadcast = topBroadcasts[section]
        return childBroadcasts[topBroadcast.getPreCode()]!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        
        let topBroadcast = topBroadcasts[indexPath.section]
        let broadcast = childBroadcasts[topBroadcast.getPreCode()]![indexPath.row]
        let label = cell.contentView.viewWithTag(1) as? UILabel
        label?.text = broadcast.name
        
        
        cell.layer.borderWidth = 5.0
        if broadcast.level == 3 {
            cell.layer.borderColor = UIColor(red: 0.30, green: 0.30, blue: 0.30, alpha: 1).cgColor
        } else if broadcast.level == 4 {
            cell.layer.borderColor = UIColor(red: 0.60, green: 0.60, blue: 0.60, alpha: 1).cgColor
        } else {
            cell.layer.borderColor = UIColor(red: 0.90, green: 0.90, blue: 0.90, alpha: 1).cgColor
        }
        
        
        if broadcast.status == 0 {
            cell.backgroundColor = .white
        }else if broadcast.status == 1 {
            cell.backgroundColor = .cyan
        }else if broadcast.status == 2 {
            cell.backgroundColor = .yellow
        }else if broadcast.status == 3 {
            cell.backgroundColor = .green
        }else if broadcast.status == 4 {
            cell.backgroundColor = .orange
        }else if broadcast.status == 5 {
            cell.backgroundColor = .purple
        }
        
        return cell
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        if Auth.auth().currentUser != nil {
            let broadRef = Firestore.firestore().collection("areas").document(area!.id).collection("halls").document(hall!.id).collection("broadcasts").order(by: "code")
            broadRef.addSnapshotListener() { (querySnapshot, error) in
                if let error = error {
                    print("DEBUG_PRINT: snapshotの取得が失敗しました。 \(error)")
                    return
                }
                self.topBroadcasts = []
                self.childBroadcasts = [:]
                let documents = querySnapshot!.documents
                for document in documents {
                    let broadcast = BroadcastData(document: document)
                    print("DEBUG_PRINT: document取得 \(broadcast.status)")
                    
                    if broadcast.isTop() {
                        self.topBroadcasts.append(broadcast)
                    } else{
                        if self.childBroadcasts[broadcast.getPreCode()] == nil {
                            self.childBroadcasts[broadcast.getPreCode()] = []
                        }
                     
                        self.childBroadcasts[broadcast.getPreCode()]!.append(broadcast)
                        
                        }
                    
                }
                self.collectionView.reloadData()
            }
        }
        
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
