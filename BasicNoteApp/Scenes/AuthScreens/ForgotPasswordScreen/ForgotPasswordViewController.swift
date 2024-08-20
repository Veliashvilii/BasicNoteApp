//
//  ForgotPasswordViewController.swift
//  BasicNoteApp
//
//  Created by Metehan Veliashvili on 10.07.2024.
//

import UIKit

class ForgotPasswordViewController: UIViewController {
    
    // TextFields
    @IBOutlet weak var emailTextField: UITextField!
    
    // Stacks
    @IBOutlet weak var emailErrorStack: UIStackView!
    
    // Buttons
    @IBAction func resetPasswordTapped(_ sender: UIButton) {
        guard let email = emailTextField.text, !email.isEmpty, Validator.shared.isValidEmail(email) else {
            emailErrorStack.isHidden = false
            return
        }
        makeResetPasswordRequest(email: email)
    }
    
    override func viewDidLoad() {
        emailErrorStack.isHidden = true
    }
    
    func makeResetPasswordRequest(email: String) {
        let resetPasswordRequest = PostForgotPasswordRequest(email: email)
        
        dataProvider.request(request: resetPasswordRequest) { result in
            switch result {
            case .success(let response):
                print("Request succeeded with response: \(response)")
            case .failure(let error):
                print("Request failed with error: \(error)")
            }
        }
    }
    
}
