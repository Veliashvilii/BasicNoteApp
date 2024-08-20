//
//  RegisterViewController.swift
//  BasicNoteApp
//
//  Created by Metehan Veliashvili on 10.07.2024.
//

import UIKit

class RegisterViewController: UIViewController {
    
    var access_token: String?
    
    // Stacks
    @IBOutlet weak var passwordInvalidStack: UIStackView!
    @IBOutlet weak var fullNameInvalidStack: UIStackView!
    @IBOutlet weak var emailInvalidStack: UIStackView!
    
    // TextFields
    @IBOutlet weak var fullNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    // Buttons
    @IBAction func signUpButton(_ sender: UIButton) {
        guard let fullName = fullNameTextField.text, !fullName.isEmpty, Validator.shared.isValidFullName(fullName) else {
            fullNameInvalidStack.isHidden = false
            return
        }
        
        guard let email = emailTextField.text, !email.isEmpty, Validator.shared.isValidEmail(email) else {
            emailInvalidStack.isHidden = false
            return
        }
        
        guard let password = passwordTextField.text, !password.isEmpty, Validator.shared.isValidPassword(password) else {
            passwordInvalidStack.isHidden = false
            return
        }
        
        makeRegsiterRequest(fullName: fullName, email: email, password: password)
    }
    
    @IBAction func signInButtonTapped(_ sender: UIButton) {
        let router = Router()
        router.viewController = self

        let pushTransition = PushTransition()
        router.open("Login", "LoginViewController", transition: pushTransition)
    }
    
    @IBAction func forgotPasswordButtonTapped(_ sender: UIButton) {
        let router = Router()
        router.viewController = self

        let pushTransition = PushTransition()
        router.open("ForgotPassword", "ForgotPasswordViewController", transition: pushTransition)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fullNameInvalidStack.isHidden = true
        emailInvalidStack.isHidden = true
        passwordInvalidStack.isHidden = true
    }
    
    func makeRegsiterRequest(fullName: String, email: String, password: String) {
        let registerRequest = PostRegisterRequest(fullName: fullName, email: email, password: password)
        
        dataProvider.request(request: registerRequest) { [weak self] result in
            switch result {
            case .success(let response):
                print("Request succeeded with response: \(response)")
                self?.access_token = response.data?.access_token
                print("Accses Toke: \(String(describing: self?.access_token))")
            case .failure(let error):
                print("Request failed with error: \(error)")
            }
        }
        
    }
    
}
