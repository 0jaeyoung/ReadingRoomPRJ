//
//  ViewController.swift
//  ReadingRoomPRJ
//
//  Created by 김재영 on 2021/02/18.
//


import UIKit
import Alamofire
//import NVActivityIndicatorView

class LoginViewController: UIViewController {
    var subLogo: UIImageView!
    var id: UITextField!
    var password: UITextField!
    var btnLogin: UIButton!
    var btnAutoLogin: UIButton!
    var autoLoginLb: UILabel!
    
    var autoLoginBtnState: Bool = false
    
    override func loadView() {
        super.loadView()
        view.backgroundColor = UIColor.appColor(.mainBackgroundColor)
        subLogo = UIImageView()
        subLogo.translatesAutoresizingMaskIntoConstraints = false
        subLogo.contentMode = .scaleAspectFit
        let subLogoImage = UIImage(named: "loginIMG.png")
        subLogo.image = subLogoImage
        self.view.addSubview(subLogo)
        
        id = UITextField()
        id.translatesAutoresizingMaskIntoConstraints = false
        id.backgroundColor = UIColor.appColor(.mainBackgroundColor)
        id.layer.borderWidth = 0.5
        id.layer.borderColor = #colorLiteral(red: 0.837041378, green: 0.8320663571, blue: 0.8408662081, alpha: 1)
        id.autocapitalizationType = .none
        id.font = UIFont.systemFont(ofSize: 15)
        id.placeholder = " 아이디를 입력해주세요."
        id.keyboardType = .alphabet
        self.view.addSubview(id)
    
        password = UITextField()
        password.translatesAutoresizingMaskIntoConstraints = false
        password.backgroundColor = UIColor.appColor(.mainBackgroundColor)
        password.layer.borderWidth = 0.5
        password.layer.borderColor = #colorLiteral(red: 0.837041378, green: 0.8320663571, blue: 0.8408662081, alpha: 1)
        password.autocapitalizationType = .none
        password.font = UIFont.systemFont(ofSize: 15)
        password.placeholder = " 비밀번호를 입력해주세요."
        password.keyboardType = .alphabet
        password.isSecureTextEntry = true
        self.view.addSubview(password)

        
        btnAutoLogin = UIButton(type: .system)
        btnAutoLogin.translatesAutoresizingMaskIntoConstraints = false
        btnAutoLogin.tintColor = UIColor.appColor(.coal)
        let unchecked = UIImage(systemName: "square")
        btnAutoLogin.tintColor = .appColor(.mainColor)
        btnAutoLogin.setImage(unchecked, for: .normal)
        btnAutoLogin.addTarget(self, action: #selector(self.changeBtnImage), for: .touchUpInside)
        self.view.addSubview(btnAutoLogin)
        
        autoLoginLb = UILabel()
        autoLoginLb.text = "자동로그인"
        autoLoginLb.font = .appFont(size: 15, family: .Bold)
        autoLoginLb.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(autoLoginLb)
        
        btnLogin = UIButton()
        btnLogin.translatesAutoresizingMaskIntoConstraints = false
        btnLogin.backgroundColor = #colorLiteral(red: 0.5215686275, green: 0.6784313725, blue: 0.9019607843, alpha: 1)
        btnLogin.setTitle("로그인", for: .normal)
        btnLogin.titleLabel!.font = UIFont.boldSystemFont(ofSize: 20)
        btnLogin.addTarget(self, action: #selector(self.loginClick(_:)), for: .touchUpInside)
        self.view.addSubview(btnLogin)
        
        
        NSLayoutConstraint.activate([
            subLogo.topAnchor.constraint(equalTo: view.topAnchor, constant: view.bounds.height/4),
            subLogo.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            subLogo.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 3/5),
            
            id.topAnchor.constraint(equalTo: subLogo.bottomAnchor, constant: view.bounds.height/8),
            id.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            id.heightAnchor.constraint(equalToConstant: 40),
            id.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 4/5),
            
            password.topAnchor.constraint(equalTo: id.bottomAnchor, constant: 5),
            password.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            password.heightAnchor.constraint(equalTo: id.heightAnchor),
            password.widthAnchor.constraint(equalTo: id.widthAnchor),
            
            autoLoginLb.leadingAnchor.constraint(equalTo: btnAutoLogin.trailingAnchor, constant: 10),
            autoLoginLb.topAnchor.constraint(equalTo: password.bottomAnchor, constant: 15),

            btnAutoLogin.leadingAnchor.constraint(equalTo: password.leadingAnchor),
            btnAutoLogin.topAnchor.constraint(equalTo: password.bottomAnchor, constant: 15),
            
            btnLogin.topAnchor.constraint(equalTo: btnAutoLogin.bottomAnchor, constant: 25),
            btnLogin.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            btnLogin.heightAnchor.constraint(equalTo: id.heightAnchor),
            btnLogin.widthAnchor.constraint(equalTo: id.widthAnchor),
            btnLogin.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -75)
            
        ])
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        resignForKeyboardNotification()
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
                autoLoginBtnState = true
                self.btnAutoLogin.setImage(UIImage(systemName: "checkmark.square.fill"), for: .normal)
                self.loginClick(self)
            }
        }
    }
    
    @objc func dismissKeyboard() {  //키보드 숨김처리
        view.endEditing(true)
    }
    
    @objc func changeBtnImage(_sender: UIButton) {
        if autoLoginBtnState == false {
            let checked = UIImage(systemName: "checkmark.square.fill")
            btnAutoLogin.setImage(checked, for: .normal)
            autoLoginBtnState = true
        } else {
            let unchecked = UIImage(systemName: "square")
            btnAutoLogin.setImage(unchecked, for: .normal)
            autoLoginBtnState = false
        }
    }
    
    //https://github.com/ninjaprox/NVActivityIndicatorView
    func setLoading(){
        //Todo: 로딩화면 구성...?
    }
    
    
    func resignForKeyboardNotification() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        self.view.frame.origin.y = 0
        
        let bottom = view.frame.origin.y
        
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardReactangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardReactangle.height
            
            self.view.frame.origin.y = bottom - (keyboardHeight / 1) + 70
            //self.view.frame.origin.y = bottom - 80
            print(keyboardHeight)
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        self.view.frame.origin.y = 0
    }
    
    
    @objc func loginClick(_ sender: Any) {
        
        if id.text == "" {
            let alert = UIAlertController(title: "에러", message: "아이디를 입력하세요.", preferredStyle: .alert)
            let okButton = UIAlertAction(title: "확인", style: .default, handler: nil)
            alert.addAction(okButton)
            present(alert, animated: true, completion: nil)
        } else if password.text == "" {
            let alert = UIAlertController(title: "에러", message: "비밀번호를 입력하세요.", preferredStyle: .alert)
            let okButton = UIAlertAction(title: "확인", style: .default, handler: nil)
            alert.addAction(okButton)
            present(alert, animated: true, completion: nil)
        } else {
            let activityIndicator = UIActivityIndicatorView()
            activityIndicator.center = self.view.center
            activityIndicator.style = .large
            
            
            
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
                print(result)
                
                
                if (result) {
                    //UserDefaults.standard.set(data, forKey: "accountInfo")
                    UserDefaults.standard.set(data, forKey: "studentInfo")
                    var isAutoLogin: Bool
                    if self.autoLoginBtnState == true {
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
                //activityIndicator.stopAnimating()
                self.btnLogin.isEnabled = true
            })
        }
        
    }
}

