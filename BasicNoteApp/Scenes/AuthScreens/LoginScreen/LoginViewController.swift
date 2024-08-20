//
//  LoginViewController.swift
//  BasicNoteApp
//
//  Created by Metehan Veliashvili on 10.07.2024.
//

import UIKit

class LoginViewController: UIViewController {
    
    var access_token: String?
    
    // TextFields
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    // Stacks
    @IBOutlet weak var passwordInvalidStack: UIStackView!
    
    // Buttons
    @IBAction func forgotPasswordButtonTapped(_ sender: UIButton) {
        let router = Router()
        router.viewController = self

        let modalTransition = ModalTransition()
        router.open("ForgotPassword", "ForgotPasswordViewController", transition: modalTransition)
    }
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        guard let email = emailTextField.text, !email.isEmpty, Validator.shared.isValidEmail(email) else {
            // passwordInvalidStack.isHidden = false
            // Bunları bi sormak lazım sıkıntıya sokabilir gibi. Yani bunun stack i olmalı mı mesela? Tasarım etkileniyor çünkü.
            return
        }
        
        guard let password = passwordTextField.text, !password.isEmpty else {
            passwordInvalidStack.isHidden = false
            return
        }
        
        makeLoginRequest(email: email, password: password)
        
    }
    
    @IBAction func signUpButtonTapped(_ sender: UIButton) {
        let router = Router()
        router.viewController = self

        let modalTransition = ModalTransition()
        router.open("Register", "RegisterViewController", transition: modalTransition)
    }
    
    // MARK: - LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        passwordInvalidStack.isHidden = true
    }
    
    func makeLoginRequest(email: String, password: String) {
        let loginRequest = PostLoginRequest(email: email, password: password)
        
        dataProvider.request(request: loginRequest) { [weak self] result in
            switch result {
            case .success(let response):
                print("Request succeeded with response: \(response)")
                self?.access_token = response.data?.access_token
                if response.code == "common.success" {
                    let router = Router()
                    router.viewController = self
                    
                    let pushTransition = PushTransition()
                    router.open("NoteList", "NoteListViewController", transition: pushTransition, extraParams: ["access_token": self?.access_token ?? "Gelmiyor"])
                }
            case .failure(let error):
                print("Request failed with error: \(error)")
            }
        }
    }
    
}
