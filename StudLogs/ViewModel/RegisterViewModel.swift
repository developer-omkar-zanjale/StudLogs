//
//  RegisterViewModel.swift
//  StudLogs
//
//  Created by admin on 24/05/23.
//

import Foundation

class RegisterViewModel {
    
    var alertMessage = ""
    var loggedStudent: Student?
    
    func checkAllowLogin(userName: String, password: String, name: String) -> Bool {
        if !userName.isEmpty {
            if !name.isEmpty{
                if !password.isEmpty {
                    if CommenFunctions.isEmailValid(email: userName) {
                        if CommenFunctions.isPasswordValid(password: password) {
                            alertMessage = AlertMessages.none
                            return true
                        } else {
                            alertMessage = AlertMessages.passwordValidationMsg
                        }
                    } else {
                        alertMessage = AlertMessages.invalidEmailFormat
                    }
                } else {
                    alertMessage = AlertMessages.enterPassword
                }
            } else {
                alertMessage = AlertMessages.enterName
            }
        } else {
            alertMessage = AlertMessages.enterEmail
        }
        return false
    }
    
    private func isUserAlreadyExist(email: String, complition: @escaping (Bool)->()) {
        APIService.sendRequest(endpoint: AppURL.baseURL + AppURL.students, responseModel: [Student].self) { [weak self] result in
            switch result {
            case .success(let students):
                self?.alertMessage = AlertMessages.none
                let studentsWithThisEmail = students.filter({$0.userName == email})
                if studentsWithThisEmail.count > 0 {
                    self?.alertMessage = AlertMessages.emailAlreadyUsed
                    complition(true)
                } else {
                    complition(false)
                }
            case .failure(let error):
                self?.alertMessage = error.localizedDescription
                complition(true)
            }
        }
    }
    
    static private func checkForStudentRecordOnServer(student: Student, complition: @escaping (_ isStudentRecordPresent: Bool)->Void) {
        APIService.sendRequest(endpoint: AppURL.baseURL + AppURL.entryLogs, responseModel: [EntryLogs].self) { result in
            switch result{
            case .success(let entryLogs):
                DispatchQueue.main.async {
                    if let filteredLog = entryLogs.filter({$0.studentId == student.id}).first {
                        CommenFunctions.setLoggedUserCred(email: student.userName, password: student.password, studentId: student.id, entryLogId: filteredLog.id)
                        complition(true)
                    } else {
                        complition(false)
                    }
                }
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
                complition(false)
            }
        }
    }
    
    static func firstTimeSetUpEntryDetail(student: Student, complition: @escaping (_ isSuccess: Bool, _ message: String)->Void) {
        RegisterViewModel.checkForStudentRecordOnServer(student: student) { isStudentRecordPresent in
            if isStudentRecordPresent {
                complition(true, AlertMessages.none)
                return
            } else {
                let jsonBody: [String: Any] = [
                    "studentId": student.id ?? AppConstants.na,
                    "logDates": []
                ]
                APIService.sendRequest(endpoint: AppURL.baseURL + AppURL.entryLogs, responseModel: EntryLogs.self, httpMethod: .post, jsonBody: jsonBody) { result in
                    switch result{
                    case .success(let entryLog):
                        DispatchQueue.main.async {
                            CommenFunctions.setLoggedUserCred(email: student.userName, password: student.password, studentId: student.id, entryLogId: entryLog.id)
                            complition(true, AlertMessages.none)
                        }
                    case .failure(let error):
                        complition(false, error.localizedDescription)
                    }
                }
            }
        }
    }
    
    func registerStudent(name: String, email: String, password: String, age: String, studentClass: String, div: String, department: String, complition: @escaping (Bool)->()) {
        self.isUserAlreadyExist(email: email) { isEmailAlreadyExist in
            if !isEmailAlreadyExist {
                let body: [String: Any] = [
                    "name" : name,
                    "userName": email,
                    "password": password,
                    "gender": "Not-Set",
                    "age": age.isEmpty ? 0 : Int(age) ?? 0,
                    "studentClass": studentClass.isEmpty ? "Not-Set" : studentClass,
                    "div": div.isEmpty ? "Not-Set" : div,
                    "department": department.isEmpty ? "Not-Set" : department
                ]
                
                APIService.sendRequest(endpoint: AppURL.baseURL + AppURL.students, responseModel: Student.self, httpMethod: .post, jsonBody: body) { [weak self] result in
                    guard let self = self else{
                        complition(false)
                        return
                    }
                    switch result {
                    case .success(let student):
                        RegisterViewModel.firstTimeSetUpEntryDetail(student: student) { isSuccess, alertMsg in
                            self.alertMessage = alertMsg
                            complition(isSuccess)
                        }
                    case .failure(let error):
                        self.alertMessage = error.localizedDescription
                        complition(false)
                    }
                }
            } else {
                complition(false)
            }
        }
    }
}
