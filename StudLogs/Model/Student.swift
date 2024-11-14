//
//  Student.swift
//  StudLogs
//
//  Created by admin on 17/02/23.
//

import Foundation


struct Student: Codable {
    let lastUpdateAt: Int?
    let name: String?
    let userName: String?
    let password: String?
    let gender: String?
    let age: Int?
    let studentClass: String?
    let div: String?
    let department: String?
    let id: String?
    
    var ageInString: String? {
        if age != nil && age != 0 {
            return String(age!)
        } else {
            return "Not-Set"
        }
    }
}


struct EntryLogs: Codable, Equatable {
    
    let studentId: String?
    var logDates: [EntryDetails]?
    let id: String
}

struct EntryDetails: Codable, Equatable {
    var inDetails: String?
    var outDetails: String?
    var date: String?
    
    var isPunchedIn: Bool? {
        if ((self.inDetails != "") && (self.inDetails != "N/A") && (self.inDetails != nil)) {
            return true
        }
        return false
    }
    
    var isPunchedOut: Bool? {
        if ((self.outDetails != "") && (self.outDetails != "N/A") && (self.outDetails != nil)) {
            return true
        }
        return false
    }
    
    var isPresent: Bool? {
        if (isPunchedIn ?? false) || (isPunchedOut ?? false)  {
            return true
        } else {
            return false
        }
    }
    
}

struct StudentData: Hashable {
    var fullDate: String?
    var date: String?
    var day: String?
    var inDetails: String?
    var outDetails: String?
}
