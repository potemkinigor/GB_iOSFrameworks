//
//  LoginViewController.swift
//  GB_iOSFrameworks
//
//  Created by Igor Potemkin on 09.11.2021.
//

import UIKit
import RealmSwift

class LoginViewController: UIViewController {

    @IBOutlet weak var loginTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func enterButtonPressed(_ sender: Any) {
        if isTextFieldsEmpty() {
            return
        }
        
        guard let login = loginTF.text,
              let password = passwordTF.text else { return }
        
        guard let user = findUser(login: login) else {
            showAlert(title: "Ошибка",
                      message: "Пользователь не найден. Необходимо зарегистрироваться")
            return
        }
        
        if password == user.password {
            openMapVC()
        } else {
            showAlert(title: "Некорректные данные",
                      message: "Неверный пароль. Повторите попытку")
        }
    }
    
    @IBAction func registerButtonPressed(_ sender: Any) {
        if isTextFieldsEmpty() {
            return
        }
        
        guard let login = loginTF.text,
              let password = passwordTF.text else { return }
        
        let user = User()
        user.login = login
        user.password = password
        
        let realm = try! Realm()
        
        try! realm.write {
            realm.add(user, update: Realm.UpdatePolicy.modified)
            openMapVC()
        }
        
    }
    
    private func isTextFieldsEmpty() -> Bool {
        guard let login = loginTF.text,
              let password = passwordTF.text else { return false }
        
        if login.isEmpty || password.isEmpty {
            showAlert(title: "Некорректные данные",
                      message: "Введите логин и/или пароль")
        }
        
        return login.isEmpty || password.isEmpty
    }
    
    private func findUser(login: String) -> User? {
        let realm = try! Realm()
        guard let user = realm.objects(User.self).first(where: { $0.login == login }) else {
            return nil
        }
        
        return user
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        
        alert.view.layer.opacity = 0.5
        
        self.present(alert, animated: true, completion: nil)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            alert.dismiss(animated: true, completion: nil)
        }
    }
    
    private func openMapVC() {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "mapVC") as! ViewController
        
        AppRouter.create(UIApplication.shared.delegate as! AppDelegate, controller: self)
        
        AppRouter.router.go(controller: vc,
                            mode: .modal,
                            animated: true,
                            modalTransitionStyle: UIModalTransitionStyle.partialCurl)
    }
    
}

extension LoginViewController: ViewSecurityBlurProtocol {
    func blurSecuredTextFields() {
        self.loginTF.layer.opacity = 0
        self.passwordTF.layer.opacity = 0
    }
    
    func unblurSecuredTextFields() {
        self.loginTF.layer.opacity = 1
        self.passwordTF.layer.opacity = 1
    }
    
}
