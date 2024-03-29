//
//  OptionViewController.swift
//  ReadingRoomPRJ
//
//  Created by MCNC on 2021/03/14.
//

import UIKit

class OptionViewController: UIViewController {
    var logoutButton: UIButton!
    override func loadView() {
        super.loadView()
        view.backgroundColor = UIColor.appColor(.mainBackgroundColor)
        self.navigationController?.navigationBar.tintColor = UIColor.appColor(.coal)
        self.navigationItem.title = "설정"
        
        logoutButton = UIButton(type: .system)
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        logoutButton.backgroundColor = UIColor.appColor(.mainColor)
        logoutButton.setTitle("로그아웃", for: .normal)
        view.addSubview(logoutButton)
        
        NSLayoutConstraint.activate([
            logoutButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            logoutButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            logoutButton.widthAnchor.constraint(equalTo: view.widthAnchor),
            logoutButton.heightAnchor.constraint(equalToConstant: 50)
        
        ])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("option view")
        
        
        
        print("I'm test")
        if UserDefaults.standard.dictionary(forKey: "tokenDic")?.count == 0{
            print("x")
        }else {
        //print(UserDefaults.standard.dictionary(forKey: "tokenDic")! as Dictionary)
        //print(UserDefaults.standard.dictionary(forKey: "tokenDic")!["201735906"] as! String)
        }
        
        
        // Do any additional setup after loading the view.
        logoutButton.addTarget(self, action: #selector(logout), for: .touchUpInside)
    }
    
    @objc func logout() {
        navigationController?.dismiss(animated: true, completion: nil)
        
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
