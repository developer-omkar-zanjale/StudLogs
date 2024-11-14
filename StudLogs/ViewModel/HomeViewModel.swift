//
//  HomeViewModel.swift
//  StudLogs
//
//  Created by admin on 23/02/23.
//

import Foundation
import SwiftUI

class HomeViewModel: ObservableObject {
    var thisMonthDates: [DateModel] = []
    var studData: EntryLogs?
    var alertMessage = AlertMessages.none
    var menus = ["Profile", "Logout"]
    @Published var selectedDateIndex = 0
    @Published var selectedDateEntryLog: EntryDetails?
    @Published var absentGraphData: Double = 0
    @Published var presentGraphData: Double = 0
    @Published var loggedStudent: Student?
        
    init() {
        self.thisMonthDates.removeAll()
        let dates = getCurrentMonthDates()
        for (index,date) in dates.enumerated() {
            let model = DateModel(fullDate: date, date: Date.getOnlyDateFrom(dateStr: date), day: Date.getWeekDayFrom(dateStr: date))
            self.thisMonthDates.append(model)
            if model.day == AppConstants.today {
                self.selectedDateIndex = index
            }
            print("Fulldate: \(model.fullDate ?? "-") : Date: \(model.date ?? "-") : Day: \(model.day ?? "-")")
            print("---------------------------------------------------")
        }
    }
    
    func getCurrentMonthDates() -> [String] {
        let date = Date()
        var startDate = date.startOfMonth()
        let endOfMonth = date.endOfMonth()
        
        var thisMonthDates:[String] = []
        print("----------------------getCurrentMonthDates-----------------------------")
        print("Start of month : \(Calendar.current.date(byAdding: .day, value: 1, to: startDate) ?? Date())")
        print("End of month : \(endOfMonth)")
        while startDate < endOfMonth {
            let convertedDate = Date.dateFormatter().string(from: startDate)
            thisMonthDates.append(convertedDate)
            if let iteratedDate = Calendar.current.date(byAdding: .day, value: 1, to: startDate) {
                startDate = iteratedDate
            }
        }
        print("This Month Dates", thisMonthDates)
        print("---------------------------------------------------")
        return thisMonthDates
    }
    //
    //MARK: fetch Graph Data
    //
    private func fetchLastMonthGraphData() {
        guard var lastMonthAnyDate = Date().onlyDate else {return}
        
        if let date = lastMonthAnyDate.startOfMonth().yesterday.yesterday.onlyDate {
            lastMonthAnyDate = date
        }
        guard let lastMonthStartDate = lastMonthAnyDate.startOfMonth().tomorrow.onlyDate else {return}
        guard let lastMonthEndDate = lastMonthStartDate.endOfMonth().tomorrow.onlyDate else {return}
        print("---------------------fetchLastMonthGraphData--------------------------")
        print("Last month Start: \(lastMonthStartDate)")
        print("Last month End: \(lastMonthEndDate)")
        let totalNumberOfDays = Date.getDaysCountExcludingSunday(from: lastMonthStartDate, to: lastMonthEndDate)
        print("Last month total number Of working days : \(totalNumberOfDays)")
        let lastMonthRecords = studData?.logDates?.compactMap { entrylog in
            if let date = Date.dateFormatter().date(from: entrylog.date ?? "")?.tomorrow.onlyDate {
                print("Log Date: ",date)
                if date >= lastMonthStartDate && date <= lastMonthEndDate {
                    if Date.getWeekDayFrom(dateStr: entrylog.date ?? "") != AppConstants.sun {
                        if entrylog.isPresent ?? false {
                            print("Last month present date: ",entrylog.date ?? "")
                            return entrylog
                        }
                    }
                }
            }
            return nil
        } ?? []
        print("Last month total present days count: \(lastMonthRecords.count)")
        let absentDaysCount = Double(totalNumberOfDays - lastMonthRecords.count)
        print("Last month total absent days count: \(absentDaysCount)")
        
        absentGraphData = (absentDaysCount / Double(totalNumberOfDays))
        presentGraphData = (Double(lastMonthRecords.count) / Double(totalNumberOfDays))
        print("Absent Graph data: \(absentGraphData)")
        print("Present Graph data: \(presentGraphData)")
        
        print("-----------------------------------------------")
    }
    
    private func fetchThisMonthGraphData() {
        let startDateStr = thisMonthDates.first?.fullDate ?? ""
        let endDateStr = thisMonthDates.last?.fullDate ?? ""
        if let startDate = Date.dateFormatter().date(from: startDateStr)?.tomorrow.onlyDate, let endDate = Date.dateFormatter().date(from: endDateStr)?.tomorrow.onlyDate {
            print("---------------------fetchThisMonthGraphData--------------------------")
            print("This month Start: \(startDate)")
            print("This month End: \(endDate)")
            let today = Date().tomorrow.onlyDate ?? Date()
            let totalNumberOfDays = Date.getDaysCountExcludingSunday(from: startDate, to: today)
            let thisMonthRecords = studData?.logDates?.compactMap { entrylog in
                if let date = Date.dateFormatter().date(from: entrylog.date ?? "")?.tomorrow.onlyDate {
                    print("Log Date: ",date)
                    if date >= startDate && date <= endDate && date <= today {
                        if Date.getWeekDayFrom(dateStr: entrylog.date ?? "") != AppConstants.sun {
                            if entrylog.isPresent ?? false {
                                print("This month present date \(date)")
                                return entrylog
                            }
                        }
                    }
                }
                return nil
            } ?? []
            print("Total Working Days: \(totalNumberOfDays)")
            print("This month present days count till today: \(thisMonthRecords.count)")
            
            let absentDaysCount = Double(totalNumberOfDays - thisMonthRecords.count)
            print("This month absent days count till today: \(absentDaysCount)")
            
            absentGraphData = (absentDaysCount / Double(totalNumberOfDays))
            presentGraphData = (Double(thisMonthRecords.count) / Double(totalNumberOfDays))
            print("Absent Graph data: \(absentGraphData)")
            print("Present Graph data: \(presentGraphData)")
            
            print("-----------------------------------------------")
        }
    }
    
    private func fetchLastWeekGraphData() {
        print("-----------------------fetchLastWeekGraphData------------------------")
        let today = Date().tomorrow.onlyDate ?? Date()
        guard let startOfThisWeek = today.startOfWeek?.tomorrow.onlyDate else {return}
        //Uses tomorrow to get start of week from monday
        if let anyDateOfLastWeek = startOfThisWeek.yesterday.yesterday.yesterday.onlyDate, let startOfLastWeek = anyDateOfLastWeek.startOfWeek?.tomorrow.onlyDate {
            guard let endOfLastWeek = startOfLastWeek.endOfWeek?.onlyDate else {return}
            print("startOfLastWeek: ", startOfLastWeek)
            print("endOfLastWeek: ", endOfLastWeek)
            let totalNumberOfDays = Date.getDaysCountExcludingSunday(from: startOfLastWeek, to: endOfLastWeek)
            
            let lastWeekRecords = self.studData?.logDates?.compactMap { entryDetail in
                if let date = Date.dateFormatter().date(from: entryDetail.date ?? "")?.tomorrow.onlyDate {
                    if date >= startOfLastWeek && date <= endOfLastWeek {
                        if Date.getWeekDayFrom(dateStr: entryDetail.date) != AppConstants.sun {
                            if entryDetail.isPresent ?? false {
                                return entryDetail
                            }
                        }
                    }
                }
                return nil
            } ?? []
            print("Last week total present days count: \(lastWeekRecords.count)")
            let absentDaysCount = Double(totalNumberOfDays - lastWeekRecords.count)
            print("Last week total absent days count: \(absentDaysCount)")
            
            absentGraphData = (absentDaysCount / Double(totalNumberOfDays))
            presentGraphData = (Double(lastWeekRecords.count) / Double(totalNumberOfDays))
            print("Absent Graph data: \(absentGraphData)")
            print("Present Graph data: \(presentGraphData)")
            
            print("-----------------------------------------------")
        }
    }
    
    func fetchChartData(forType type: GraphSelectionType.RawValue) {
        self.presentGraphData = 0.0
        self.absentGraphData = 0.0
        switch type {
        case GraphSelectionType.thisMonth.rawValue:
            self.fetchThisMonthGraphData()
        case GraphSelectionType.lastMonth.rawValue:
            self.fetchLastMonthGraphData()
        case GraphSelectionType.lastWeek.rawValue:
            self.fetchLastWeekGraphData()
        default:
            print("-")
        }
    }
    //
    //MARK: Get Selected Date Data
    //
    func fetchLogDataForSelectedIndex(withDate date: Date? = nil) {
        var convertedDate = thisMonthDates[selectedDateIndex].fullDate ?? "--"
        if let date = date {
            convertedDate = date.getCurrentDateConverted()
        }
        let logForSelectedIndex = studData?.logDates?.filter({ $0.date == convertedDate}).first
        print("---------------------fetchLogDataForSelectedIndex--------------------------")
        print("In: \(logForSelectedIndex?.inDetails ?? "-") : Out: \(logForSelectedIndex?.outDetails ?? "-")")
        print("-----------------------------------------------")
        self.selectedDateEntryLog = logForSelectedIndex
    }
    
    
    func fetchLogData(forDate date: Date) {
        let convertedDate = date.getCurrentDateConverted()
        let logForSelectedIndex = studData?.logDates?.filter({ $0.date == convertedDate}).first
        print("---------------------fetchLogDataForSelectedIndex--------------------------")
        print("In: \(logForSelectedIndex?.inDetails ?? "-") : Out: \(logForSelectedIndex?.outDetails ?? "-")")
        print("-----------------------------------------------")
        self.selectedDateEntryLog = logForSelectedIndex
    }
}
//
//MARK: API Calls
//
extension HomeViewModel {
        
    func uploadEntryData(forDate: Date? = nil, isForPunchIn: Bool = true, complition: @escaping (_ isSuccess: Bool)->()) {
        print("--------------------uploadEntryData---------------------------")
        var selectedConvertedDate = thisMonthDates[selectedDateIndex].fullDate ?? Date().getCurrentDateConverted()
        let currentTime = Date().getCurrentTime()
        if let forDate = forDate {
            selectedConvertedDate = forDate.getCurrentDateConverted()
        }
    
        if let selectedDate = Date.dateFormatter().date(from: selectedConvertedDate)?.tomorrow {
            if selectedDate > Date().tomorrow.onlyDate! {
                self.alertMessage = isForPunchIn ? AlertMessages.cannotPunchInForFutureDate : AlertMessages.cannotPunchOutForFutureDate
                complition(false)
                return
            }
        }
        print("Current Time: \(currentTime) : Date: \(selectedConvertedDate)")
        let todaysLog: EntryDetails
        if isForPunchIn {
            if let index = studData?.logDates?.firstIndex(where: {$0.date == selectedConvertedDate}) {
                if index < studData?.logDates?.count ?? 0 {
                    let logDetail = studData?.logDates?[index]
                    studData?.logDates?[index] = EntryDetails(inDetails: currentTime, outDetails: logDetail?.outDetails, date: logDetail?.date)
                } else {
                    print("Unable to upload data.")
                    self.alertMessage = isForPunchIn ? AlertMessages.failedToPunchIn : AlertMessages.failedToPunchOut
                    complition(false)
                    return
                }
            } else {
                todaysLog = EntryDetails(inDetails: currentTime, outDetails: AppConstants.na, date: selectedConvertedDate)
                studData?.logDates?.append(todaysLog)
            }
            
        } else {
            if let index = studData?.logDates?.firstIndex(where: {$0.date == selectedConvertedDate}) {
                if index < studData?.logDates?.count ?? 0 {
                    let logDetail = studData?.logDates?[index]
                    studData?.logDates?[index] = EntryDetails(inDetails: logDetail?.inDetails, outDetails: currentTime, date: logDetail?.date)
                } else {
                    print("Unable to upload data.")
                    self.alertMessage = isForPunchIn ? AlertMessages.failedToPunchIn : AlertMessages.failedToPunchOut
                    complition(false)
                    return
                }
            } else {
                todaysLog = EntryDetails(inDetails: AppConstants.na, outDetails: currentTime, date: selectedConvertedDate)
                studData?.logDates?.append(todaysLog)
            }
        }
        do {
            let request = try JSONEncoder().encode(studData)
            print("Encoded data: ")
            print(String(decoding: request, as: UTF8.self))
            let entryLogId = CommenFunctions.getLoggedUserCred().entryLogId
            print("Sending log for ID : \(entryLogId)")
            APIService.sendRequest(endpoint: AppURL.baseURL + AppURL.entryLogs + entryLogId, request: request, responseModel: EntryLogs.self, httpMethod: .put) { [weak self] result in
                switch result {
                case .success(_):
                    self?.alertMessage = AlertMessages.none
                    print("Data uploaded successfully.")
                    self?.getEntryLogs {
                        complition(true)
                    }
                case .failure(let error):
                    self?.alertMessage = error.localizedDescription
                    complition(false)
                    self?.getEntryLogs {}
                }
            }
        } catch {
            print("Unable to uploaded data.")
            self.alertMessage = isForPunchIn ? AlertMessages.failedToPunchIn : AlertMessages.failedToPunchOut
            print(error.localizedDescription)
            self.getEntryLogs {}
            complition(false)
        }
    }
    
    func getEntryLogs(complition: @escaping ()->Void) {
        studData = nil
        APIService.sendRequest(endpoint: AppURL.baseURL + AppURL.entryLogs, responseModel: [EntryLogs].self) {[weak self] result in
            do {
                let studentID = CommenFunctions.getLoggedUserCred().studentId
                print("Fetching log for studentID : \(studentID)")
                let data = try result.get()
                self?.studData = data.filter({$0.studentId == studentID}).first
                DispatchQueue.main.async {
                    self?.fetchLogDataForSelectedIndex()
                    self?.alertMessage = AlertMessages.none
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        complition()
                    }
                }
            } catch {
                self?.alertMessage = error.localizedDescription
                print(error.localizedDescription)
                complition()
            }
        }
    }
    
    func getCurrentUserData(complition: @escaping (_ isSuccess: Bool)->Void) {
        let studentID = CommenFunctions.getLoggedUserCred().studentId
        APIService.sendRequest(endpoint: AppURL.baseURL + AppURL.students + studentID, responseModel: Student.self) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let student):
                    self?.alertMessage = AlertMessages.none
                    self?.loggedStudent = student
                    complition(true)
                case .failure(let error):
                    self?.alertMessage = error.localizedDescription
                    complition(false)
                }
            }
        }
    }
}
