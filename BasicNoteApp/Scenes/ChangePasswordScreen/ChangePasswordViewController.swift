//
//  ChangePasswordViewController.swift
//  BasicNoteApp
//
//  Created by Metehan Veliashvili on 11.07.2024.
//

import UIKit

class ChangePasswordViewController: UIViewController {
    
    // MARK: - VARIABLES
    var accessToken: String?
    
    // MARK: - TEXTFIELDS
    
    @IBOutlet weak var currentPasswordTextField: UITextField!
    @IBOutlet weak var newPasswordTextField: UITextField!
    @IBOutlet weak var reNewPasswordTextField: UITextField!
    
    // MARK: - LIFECYLE METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Change Password"
    }
    
    // MARK: - ACTIONS
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        
        guard let token = accessToken else {
            print("Access Token is Missing!")
            return
        }
        
        guard let currentPassword = currentPasswordTextField.text, !currentPassword.isEmpty else {
            print("Şu anki Şifre Alanı Doldurulmadı!")
            return
        }
        
        guard let newPassword = newPasswordTextField.text, !newPassword.isEmpty else {
            print("Yeni Şifre Alanı Doldurulmadı!")
            return
        }
        
        guard let reNewPassword = reNewPasswordTextField.text, !reNewPassword.isEmpty else {
            print("Yeniden Yeni Şifre Alanı Doldurulmadı!")
            return
        }
        
        let updatePasswordRequest = UpdatePasswordRequest(password: currentPassword, newPassword: newPassword, newPasswordConfirmation: reNewPassword, access_token: token)
        
        if checkPasswords(newPassword: newPassword, reNewPassword: reNewPassword) {
            dataProvider.request(request: updatePasswordRequest) { result in
                switch result {
                case .success(let response):
                    if let message = response.message {
                        print("Message: \(message)")
                    }
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                }
            }
        } else {
            print("Şifreler Aynı Değil!")
        }
        
    }
    
    // MARK: - PRIVATE FUNCTIONS
    private func checkPasswords (newPassword: String, reNewPassword: String) -> Bool {
        if newPassword == reNewPassword {
            return Validator.shared.isValidPassword(newPassword)
        }
        return false
    }
    
}
