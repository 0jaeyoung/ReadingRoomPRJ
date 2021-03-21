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
        view.backgroundColor = .white
        
        logoutButton = UIButton(type: .system)
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        logoutButton.backgroundColor = .systemIndigo
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
