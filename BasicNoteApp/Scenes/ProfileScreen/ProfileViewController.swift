//
//  ProfileViewController.swift
//  BasicNoteApp
//
//  Created by Metehan Veliashvili on 10.07.2024.
//

import UIKit

class ProfileViewController: UIViewController {
    
    // MARK: - Variables
    var accessToken: String?
    
    // MARK: - TEXTFIELDS
    
    @IBOutlet weak var fullNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Profile"
        
    }
    
    // MARK: - ACTIONS
    @IBAction func changePasswordButtonTapped(_ sender: UIButton) {
        let router = Router()
        router.viewController = self
        
        let pushTransition = PushTransition()
        router.open("ChangePassword", "ChangePasswordViewController", transition: pushTransition, extraParams: ["access_token": self.accessToken ?? "Gelmiyor"])
    }
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        
        guard let token = accessToken else {
            print("Access Token is Missing!")
            return
        }
        
        let fullName = fullNameTextField.text ?? ""
        let email = emailTextField.text ?? ""
        var updateMeRequest: UpdateMeRequest?
        
        if isValidInputs(fullName: fullName, email: email) {
            updateMeRequest = UpdateMeRequest(fullName: fullName, email: email, access_token: token)
        } else if Validator.shared.isValidFullName(fullName) {
            updateMeRequest = UpdateMeRequest(fullName: fullName, access_token: token)
        } else if Validator.shared.isValidEmail(email) {
            updateMeRequest = UpdateMeRequest(email: email, access_token: token)
        } else {
            print("Her iki girdi de YOK!")
            return
        }
        
        guard let request = updateMeRequest else { return }
        
        dataProvider.request(request: request) { result in
            switch result {
            case .success(let response):
                if let message = response.message {
                    print("Message: \(message)")
                }
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    @IBAction func signOutButtonTapped(_ sender: UIButton) {
        let router = Router()
        router.viewController = self
        
        let modalTransition = ModalTransition()
        router.open("Login", "LoginViewController", transition: modalTransition)
    }
    
    // MARK: - PRIVATE FUNCTIONS
    private func isValidInputs(fullName: String, email: String) -> Bool {
        return Validator.shared.isValidFullName(fullName) && Validator.shared.isValidEmail(email)
    }
    
}
