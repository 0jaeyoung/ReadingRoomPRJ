//
//  ViewController.swift
//  ReadingRoomPRJ
//
//  Created by 김재영 on 2021/02/18.
//


import UIKit
import Alamofire

class LoginViewController: UIViewController {
    var subLogo: UIImageView!
    var id: UITextField!
    var password: UITextField!
    var btnLogin: UIButton!
    var btnAutoLogin: UIButton!
    var autoLoginLb: UILabel!
    
    override func loadView() {
        super.loadView()
        view.backgroundColor = UIColor.appColor(.mainBackgroundColor)
        subLogo = UIImageView()
        subLogo.translatesAutoresizingMaskIntoConstraints = false
        subLogo.contentMode = .scaleAspectFit
        let subLogoImage = UIImage(named: "logo_jungsook.png")
        subLogo.image = subLogoImage
        self.view.addSubview(subLogo)
        
        id = UITextField()
        id.translatesAutoresizingMaskIntoConstraints = false
        id.backgroundColor = .gray
        id.autocapitalizationType = .none
        id.placeholder = " ID"
        self.view.addSubview(id)
        
        password = UITextField()
        password.translatesAutoresizingMaskIntoConstraints = false
        password.backgroundColor = .gray
        password.autocapitalizationType = .none
        password.placeholder = " PW"
        password.isSecureTextEntry = true
        self.view.addSubview(password)
        
        btnLogin = UIButton()
        btnLogin.translatesAutoresizingMaskIntoConstraints = false
        btnLogin.backgroundColor = .gray
        btnLogin.setTitle("로그인", for: .normal)
        btnLogin.addTarget(self, action: #selector(self.loginClick(_:)), for: .touchUpInside)
        self.view.addSubview(btnLogin)
        
        btnAutoLogin = UIButton(type: .system)
        btnAutoLogin.translatesAutoresizingMaskIntoConstraints = false
        let unchecked = UIImage(systemName: "square")
        let checked = UIImage(systemName: "checkmark.square.fill")
        btnAutoLogin.setImage(unchecked, for: .normal)
        btnAutoLogin.setImage(checked, for: .selected)
        btnAutoLogin.addTarget(self, action: #selector(self.changeBtnImage), for: .touchUpInside)
        self.view.addSubview(btnAutoLogin)
        
        autoLoginLb = UILabel()
        autoLoginLb.text = "자동로그인"
        autoLoginLb.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(autoLoginLb)
        
        NSLayoutConstraint.activate([
            subLogo.topAnchor.constraint(equalTo: view.topAnchor, constant: view.bounds.height/7),
            subLogo.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            subLogo.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 3/5),
            
            id.topAnchor.constraint(equalTo: view.centerYAnchor),
            id.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            id.heightAnchor.constraint(equalToConstant: 40),
            id.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 2/3),
            
            password.topAnchor.constraint(equalTo: id.bottomAnchor, constant: 5),
            password.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            password.heightAnchor.constraint(equalTo: id.heightAnchor),
            password.widthAnchor.constraint(equalTo: id.widthAnchor),
            
            btnAutoLogin.topAnchor.constraint(equalTo: password.bottomAnchor, constant: 10),
            btnAutoLogin.leadingAnchor.constraint(equalTo: password.leadingAnchor),
            
            autoLoginLb.centerYAnchor.constraint(equalTo: btnAutoLogin.centerYAnchor),
            autoLoginLb.leadingAnchor.constraint(equalTo: btnAutoLogin.trailingAnchor, constant: 5),
            
            btnLogin.topAnchor.constraint(equalTo: btnAutoLogin.bottomAnchor, constant: 15),
            btnLogin.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            btnLogin.heightAnchor.constraint(equalTo: id.heightAnchor),
            btnLogin.widthAnchor.constraint(equalTo: password.widthAnchor, multiplier: 2/3),
            
        ])
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //다른 공간 클릭 시 키보드 내리기
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        // 저장된 로그인 정보 가져오기
        if let autoLoginValue = UserDefaults.standard.dictionary(forKey: "accountInfo") as NSDictionary? {
            let isAutoLogin: Bool = autoLoginValue["isAutoLogin"] as! Bool
            if isAutoLogin {
                // 자동로그인일경우 id,pw,자동로그인 자동으로 세팅
                id.text = autoLoginValue.object(forKey: "id") as? String
                password.text = autoLoginValue.object(forKey: "pw") as? String
                btnAutoLogin.isSelected = true
                // 로그인버튼 트리거
                self.loginClick(self)
            }
        }
    }
    
    @objc func dismissKeyboard() {  //키보드 숨김처리
        view.endEditing(true)
    }
    
    @objc func changeBtnImage(_sender: UIButton) {
        _sender.isSelected.toggle()
    }
    
    @objc func loginClick(_ sender: Any) {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.center = self.view.center
        activityIndicator.style = .large
        activityIndicator.startAnimating()
        view.addSubview(activityIndicator)
        
        btnLogin.isEnabled = false
        self.btnLogin.setTitle("로그인 중...", for: .disabled)
        
        let inputID: String = id.text ?? ""
        let inputPW: String = password.text ?? ""
        
        let param = [
            "id":inputID,
            "password":inputPW
        ]
        // TODO : 입력값 유효 확인 (공백, 특수문자, 한글 검사 등)
        
        RequestAPI.post(resource: "/account/login", param: param, responseData: "account", completion: { (result, response) in
            let data = response as! NSDictionary
            if (result) {
                UserDefaults.standard.set(data, forKey: "studentInfo")
                var isAutoLogin: Bool
                if self.btnAutoLogin.isSelected {
                    isAutoLogin = true
                } else {
                    isAutoLogin = false
                }
                
                var accountInfo: NSDictionary
                accountInfo = [ "isAutoLogin" : isAutoLogin,
                                   "id" : inputID,
                                   "pw" : inputPW   ]
                UserDefaults.standard.setValue(accountInfo, forKey: "accountInfo")
                
                let mainVC: MainViewController = MainViewController()
                let navVC = UINavigationController(rootViewController: mainVC)
                navVC.modalPresentationStyle = .fullScreen
                self.present(navVC, animated: true, completion: nil)
            } else {
                if (data["message"] != nil) {
                    // TODO:토스트메시지 띄우기
                    print("► 로그인 실패: \(String(describing: data["message"]))")
                    
                    if (data["message"] as! String == "INVALID_ACCOUNT") {
                        let alert = UIAlertController(title: "로그인 실패", message: "계정 정보 불일치", preferredStyle: UIAlertController.Style.alert)
                        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in}
                        alert.addAction(okAction)
                        self.present(alert, animated: false, completion: nil)
                    }
                } else {
                    print("알수없는 에러 : \(String(describing: data["error"]))")
                }
            }
            activityIndicator.stopAnimating()
            self.btnLogin.isEnabled = true
        })
    }
}

