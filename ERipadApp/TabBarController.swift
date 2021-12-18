//
//  TabBarController.swift
//  ERipadApp
//
//  Created by 丸山昂大 on 2021/12/18.
//

import UIKit
import Firebase


class TabBarController: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        

        // Do any additional setup after loading the view.
        super.viewDidLoad()
        // タブアイコンの色
        self.tabBar.tintColor = UIColor(red: 0.11, green: 0.44, blue: 1.0, alpha: 1)
        // タブバーの背景色
        self.tabBar.barTintColor = UIColor(red: 0.87, green: 0.91, blue: 0.96, alpha: 1)
        // UITabBarControllerDelegateプロトコルのメソッドをこのクラスで処理する。
        self.delegate = self
    }
    
    // タブバーのアイコンがタップされた時に呼ばれるdelegateメソッドを処理する。
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        return true
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // currentUserがnilならログインしていない
        if Auth.auth().currentUser == nil {
            // ログインしていないときの処理
            let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: "Login")
                        self.present(loginViewController!, animated: true, completion: nil)
            print("before present login")
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
