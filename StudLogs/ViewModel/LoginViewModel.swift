//
//  LoginViewModel.swift
//  StudLogs
//
//  Created by admin on 13/02/23.
//

import Foundation
import Combine

class LoginViewModel {
    
    var alertMessage = AlertMessages.none
    private var cancellables = Set<AnyCancellable>()
    
    func checkAllowLogin(userName: String, password: String) -> Bool {
        if !userName.isEmpty {
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
            alertMessage = AlertMessages.enterEmail
        }
        return false
    }
    
    func isUserAvailable(email: String, password: String, complitionResult: @escaping(Bool)->()) {
        guard let url = URL(string: AppURL.baseURL + AppURL.students) else {
            print("Invalid URL")
            self.alertMessage = AlertMessages.invalidURL
            complitionResult(false)
            return
        }
        
        URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { (data, response) -> Data in
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    dump(response)
                    throw URLError(.badServerResponse)
                }
                return data
            }
            .decode(type: [Student].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink { [weak self]complition in
                switch complition {
                case .failure(let error):
                    print("Error while decoding Transactions: ",error.localizedDescription)
                    self?.alertMessage = AlertMessages.somethingWentWrong
                    complitionResult(false)
                case .finished:
                    print("Decoding transaction finished.")
                }
            } receiveValue: { [weak self] result in
                guard let self = self else{
                    complitionResult(false)
                    return
                }
                let student = result.filter({$0.userName == email && $0.password == password}).first
                if let student = student {
                    RegisterViewModel.firstTimeSetUpEntryDetail(student: student) { isSuccess, alertMsg in
                        self.alertMessage = alertMsg
                        complitionResult(isSuccess)
                    }
                } else {
                    self.alertMessage = AlertMessages.invalidCred
                    complitionResult(false)
                }
            }
            .store(in: &cancellables)
    }
    
    func checkAutoLogin(complition: @escaping(Bool?)->Void) {
        let loggedCred = CommenFunctions.getLoggedUserCred()
        if loggedCred.studentId != "" {
            APIService.sendRequest(endpoint: AppURL.baseURL+AppURL.students+loggedCred.studentId, responseModel: Student.self) { [weak self] result in
                switch result {
                case .success(let student):
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        if student.userName == loggedCred.email && student.password == loggedCred.password {
                            complition(true)
                        } else {
                            self?.alertMessage = AlertMessages.failedToAutoLogin
                            complition(false)
                        }
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                    self?.alertMessage = AlertMessages.failedToAutoLogin
                    complition(false)
                }
            }
        } else {
            self.alertMessage = AlertMessages.none
            complition(nil)
        }
    }
    
}
