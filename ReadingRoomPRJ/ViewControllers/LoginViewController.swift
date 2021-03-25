//
//  ViewController.swift
//  ReadingRoomPRJ
//
//  Created by MCNC on 2021/02/18.
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
        if let autoLoginValue = UserDefaults.standard.dictionary(forKey: "autoLoginValue") as NSDictionary? {
            let isAutoLogin: Bool = autoLoginValue.object(forKey: "autoLogin") as! Bool
            print("자동로그인 \(isAutoLogin)")
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
        print("Login Click")
        
        //로그인 이벤트 주기
        //1. 텍스트 변화
        self.btnLogin.setTitle("로그인 중...", for: .normal)
        //2. 색깔 변화
        //self.btnLogin.backgroundColor = .lightGray
        
        // 입력값 가져오기
        let inputID: String = id.text ?? ""
        let inputPW: String = password.text ?? ""
        print(inputID, inputPW)
        
        // TODO : 입력값 유효 확인 (공백, 특수문자, 한글 검사 등)
        
        // REST API 세팅
        let URL = "http://3.34.174.56:8080/login"
        let PARAM: Parameters = [
            "id":inputID,
            "password":inputPW
        ]
        
        // REQUEST 세팅
        let alamo = AF.request(URL, method: .post, parameters: PARAM).validate(statusCode: 200..<300)
        
        // REST API 통신 요청
        alamo.responseJSON() { response in
            // response : 통신 결과 응답 확인
            print("result:\(response)")
            
            // REST API 통신 성공/실패 여부에 따라 분기
            switch response.result {
            // 통신 성공일 경우
            case .success(let value):
                // value : 응답 Data, data를 NSDictionary 타입으로 저장
                if let jsonObj = value as? NSDictionary {
                    // 로그인 성공/실패 여부에 따라 분기
                    let resultMsg: String? = jsonObj.object(forKey: "message") as? String
                    let result: Bool = jsonObj.object(forKey: "result") as! Bool
                    print("message:::"+resultMsg!)
                    
                    // message = SUCCESS 일 경우 (=로그인 성공)
                    if ( result ){
                        print("로그인성공")
                        // 학생 데이터 저장
                        UserDefaults.standard.set(jsonObj.object(forKey: "account"), forKey: "studentInfo")
                        
                        // 여기부터 자동로그인
                        var autoLoginValue: NSDictionary
                        if self.btnAutoLogin.isSelected { // 자동로그인인경우
                            print("autoLogin")
                            // 자동로그인을 위해서 값 세팅
                            autoLoginValue = ["autoLogin":true,
                                                  "id":inputID,
                                                  "pw":inputPW]
                        } else {
                            print("자동로그인 아님.")
                            // 다음번에 자동로그인 안되게 false로 세팅
                            autoLoginValue = ["autoLogin":false]
                        }
                        // 자동로그인 정보 저장
                        UserDefaults.standard.setValue(autoLoginValue, forKey: "autoLoginValue")
                        
                        // 메인화면 이동
                        let mainVC: MainViewController = MainViewController()
                        let navVC = UINavigationController(rootViewController: mainVC)
                        navVC.modalPresentationStyle = .fullScreen
                        self.present(navVC, animated: true, completion: nil)
                    } else {
                        // message != SUCCESS일 경우 (=로그인 실패)
                        // TODO : 로그인 실패시 처리 (ex. 알림팝업, 입력창 강조처리)
                        print("로그인실패")
                        if (resultMsg == "INVALID_ACCOUNT") {
                            let alert = UIAlertController(title: "로그인 실패", message: "계정 정보 불일치", preferredStyle: UIAlertController.Style.alert)
                            let okAction = UIAlertAction(title: "OK", style: .default) { (action) in}
                            alert.addAction(okAction)
                            self.present(alert, animated: false, completion: nil)
                        }
                    }
                } else {
                    // 서버에서 응답받은 데이터가 JSON 형식이 아닐 경우.
                    // TODO : 예외처리
                }
                
            // 통신 실패일 경우
            case.failure(let error):
                // TODO : 실패시 처리 (ex. 팝업, 네트워크상태 확인, 서버상태 확인 등)
                print("error: \(String(error.errorDescription!))")
                // 인터넷 오프라인 오류
            }
            
            //로그인 이벤트 주기
            //1. 텍스트 변화
            self.btnLogin.setTitle("로그인", for: .normal)
            //2. 색깔 변화
            //self.btnLogin.backgroundColor = .gray
        }
        
    }
    

}

