//
//  Validator.swift
//  BasicNoteApp
//
//  Created by Metehan Veliashvili on 23.07.2024.
//

import Foundation

class Validator {
    static let shared = Validator()
    
    private init() {}
    
    func isValidFullName(_ fullName: String) -> Bool {
        // En az iki kelime içermeli
        let fullNameRegex = "^[a-zA-Z]+(?: [a-zA-Z]+)*$"
        let fullNameTest = NSPredicate(format: "SELF MATCHES %@", fullNameRegex)
        return fullNameTest.evaluate(with: fullName)
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "^[A-Z0-9a-z._%+-]+@[A-Z0-9a-z.-]+\\.[A-Za-z]{2,64}$"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailTest.evaluate(with: email)
    }
    
    func isValidPassword(_ password: String) -> Bool {
        // En az 8 karakter, en az bir büyük harf, bir küçük harf ve bir rakam içermeli
        let passwordRegex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d).{8,}$"
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        return passwordTest.evaluate(with: password)
    }
}
