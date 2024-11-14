//
//  Constants.swift
//  StudLogs
//
//  Created by admin on 13/02/23.
//

import Foundation

struct CommenFunctions {
    
    static func isEmailValid(email: String) -> Bool {
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: email)
    }
    
    static func isPasswordValid(password: String) -> Bool {
        if password.count >= 8 && password.count <= 16 {
            let regexForSpecialChar = ".*[^A-Za-z0-9].*"
            let alphaNumStr = NSPredicate(format:"SELF MATCHES %@", regexForSpecialChar)
            let isSpecialCharPresent = alphaNumStr.evaluate(with: password)
            let isNumberPresent = password.contains(where: {$0.isNumber})
            let isUppercasePresent = password.contains(where: {$0.isUppercase})
            let isWhitespacePresent = password.contains(where: {$0.isWhitespace})
            
            if isSpecialCharPresent && isNumberPresent && isUppercasePresent && !isWhitespacePresent {
                return true
            }
        }
        return false
    }
    
    static func setLoggedUserCred(email: String?, password: String?, studentId: String?, entryLogId: String?) {
        let userDefault = UserDefaults.standard
        userDefault.set(email, forKey: UserDefaultConstants.email.rawValue)
        userDefault.set(password, forKey: UserDefaultConstants.password.rawValue)
        userDefault.set(studentId, forKey: UserDefaultConstants.studentId.rawValue)
        userDefault.set(entryLogId, forKey: UserDefaultConstants.entryLogId.rawValue)
        userDefault.synchronize()
    }
    
    static func removeLoggedUserCred() {
        let userDefault = UserDefaults.standard
        userDefault.removeObject(forKey: UserDefaultConstants.email.rawValue)
        userDefault.removeObject(forKey: UserDefaultConstants.password.rawValue)
        userDefault.removeObject(forKey: UserDefaultConstants.studentId.rawValue)
        userDefault.removeObject(forKey: UserDefaultConstants.entryLogId.rawValue)
    }
    
    static func getLoggedUserCred() -> (email: String, password: String, studentId: String, entryLogId: String) {
        let userDefault = UserDefaults.standard
        let email = userDefault.value(forKey: UserDefaultConstants.email.rawValue) as? String ?? ""
        let password = userDefault.value(forKey: UserDefaultConstants.password.rawValue) as? String ?? ""
        let studentId = userDefault.value(forKey: UserDefaultConstants.studentId.rawValue) as? String ?? ""
        let entryLogID = userDefault.value(forKey: UserDefaultConstants.entryLogId.rawValue) as? String ?? ""
        return(email, password, studentId, entryLogID)
    }
}
