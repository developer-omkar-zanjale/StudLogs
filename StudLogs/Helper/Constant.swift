//
//  Constant.swift
//  StudLogs
//
//  Created by admin on 24/05/23.
//

import SwiftUI

enum UserDefaultConstants: String {
    case email = "STUDENT-EMAIL"
    case password = "STUDENT-PASSWORD"
    case studentId = "STUDENT-ID"
    case entryLogId = "ENTRYLOG-ID"
}


enum GraphSelectionType: String, CaseIterable {
    case thisMonth = "This Month"
    case lastMonth = "Last Month"
    case lastWeek = "Last Week"
    static var allCases: [String] = [GraphSelectionType.thisMonth.rawValue, GraphSelectionType.lastMonth.rawValue, GraphSelectionType.lastWeek.rawValue]
}

struct AppURL {
    static let baseURL = "https://63e5ea8a83c0e85a86890ac7.mockapi.io/api/"
    static let students = "Students/"
    static let entryLogs = "EntryLogs/"
}

struct AlertMessages {
    static let invalidEmailFormat = "Invalid email format!"
    static let enterPassword = "Enter Password!"
    static let enterEmail = "Enter Email!"
    static let passwordValidationMsg = "Password must be 8-16 Characters & must contain Uppercase, Number, Special Character & no White Spaces"
    static let invalidURL = "Invalid URL"
    static let somethingWentWrong = "Something went wrong! try again!"
    static let enterName = "Enter Name!"
    static let invalidCred = "Invalid Credentials!"
    static let none = ""
    static let failedToAutoLogin = "Failed to auto login! Please Login again."
    static let emailAlreadyUsed = "Email already used! try with different email."
    static let failedToPunchIn = "Failed to Punch-in"
    static let failedToPunchOut = "Failed to Punch-out"
    static let cannotPunchInForFutureDate = "Can't Punch-in for future date!"
    static let cannotPunchOutForFutureDate = "Can't Punch-out for future date!"
    static let cannotPunchInForPastDate = "Can't Punch-in for past date!"
    static let cannotPunchOutForPastDate = "Can't Punch-out for past date!"
}

struct AppConstants {
    static let sun = "Sun"
    static let na = "N/A"
    static let today = "Today"
}

struct AppColors {
    static let background = Color("background")
    static let topAppearrance = Color("top-appearrance")
    static let buttons = Color("buttons")
    static let middlePanel = Color("middle-panel")
    static let buttonText = Color("buttons-label")
    static let primaryText = Color("primary-text")
    static let darkBlueWhiteLight = Color("dark-blue-white-light")
}
