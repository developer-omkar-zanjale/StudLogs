//
//  Extensions.swift
//  StudLogs
//
//  Created by admin on 10/02/23.
//

import SwiftUI

extension View {
    func border(width: CGFloat, edges: [Edge], color: Color) -> some View {
        overlay(EdgeBorder(width: width, edges: edges).foregroundColor(color))
    }
    
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        ModifiedContent(content: self, modifier: CornerRadiusStyle(radius: radius, corners: corners))
    }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

extension View {
    @ViewBuilder func hidden(_ shouldHide: Bool) -> some View {
        switch shouldHide {
        case true: self.hidden()
        case false: self
        }
    }
}

extension Date {
    
    func days(from date: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: date, to: self).day ?? 0
    }
    
    var isDateInWeekend: Bool {
        return Calendar.current.isDateInWeekend(self)
    }
    var tomorrow: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: self)!
    }
    
    var yesterday: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: self)!
    }
    
    var noon: Date {
        return Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self)!
    }
    
    var onlyDate: Date? {
        get {
            let calender = Calendar.current
            var dateComponents = calender.dateComponents([.year, .month, .day], from: self)
            dateComponents.timeZone = NSTimeZone.system
            return calender.date(from: dateComponents)
        }
    }
    
    var startOfWeek: Date? {
        let gregorian = Calendar(identifier: .gregorian)
        guard let sunday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)) else { return nil }
        return gregorian.date(byAdding: .day, value: 1, to: sunday)
    }

    var endOfWeek: Date? {
        let gregorian = Calendar(identifier: .gregorian)
        guard let sunday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)) else { return nil }
        return gregorian.date(byAdding: .day, value: 7, to: sunday)
    }
    
    static func coutDays(from start: Date, to end: Date) -> (weekendDays: Int, workingDays: Int) {
        guard start < end else { return (0,0) }
        var weekendDays = 0
        var workingDays = 0
        var date = start.noon
        repeat {
            if date.isDateInWeekend {
                weekendDays +=  1
            } else {
                workingDays += 1
            }
            date = date.tomorrow
        } while date < end
        return (weekendDays, workingDays)
    }
    
    func getCurrentTime() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "hh:mm a"
        formatter.amSymbol = "AM"
        formatter.pmSymbol = "PM"
        let currentTime = formatter.string(from: self)
        return currentTime
    }
    
    func getCurrentDateConverted(toFormat: String = "dd/MM/yyyy") -> String {
        let formatter = Date.dateFormatter(format: toFormat)
        return formatter.string(from: self)
    }
    
    static func getDaysCountExcludingSunday(from start: Date, to end: Date) -> Int {
        guard start < end else { return 0 }
        var weekendDays = 0
        var workingDays = 0
        print("-------------------getDaysCountExcludingSunday------------------------")
        var date = start
        print("Start date: \(date)")
        repeat {
            let dateStr = Date.dateFormatter().string(from: date.yesterday)
            let day = Date.getWeekDayFrom(dateStr: dateStr)
            if day == "Sun" {
                weekendDays +=  1
            } else {
                workingDays += 1
            }
            date = date.tomorrow.onlyDate!
        } while date <= end
        print("End date: \(end)")
        print("Sundays: \(weekendDays)")
        print("Days Excluding Sunday: \(workingDays)")
        print("-------------------------------------------")
        return workingDays
    }
    
    static func dateFormatter(format: String = "dd/MM/yyyy") -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = format
        return dateFormatter
    }
    
//    func startOfWeek() -> Date {
//        
//        let calendar = Calendar.current
//        var components = calendar.dateComponents([.weekday,.month,.day,.year], from: self)
//        components.day = (components.day! - (components.weekday! - 1))
//        return calendar.date(from: components)!
//    }
//    
//    func endOfWeek() -> Date {
//        
//        let calendar = Calendar.current
//        var components = calendar.dateComponents([.weekday,.month,.day,.year], from: self)
//        components.day = (components.day! + (7 - components.weekday!))
//        components.hour = 23
//        components.minute = 59
//        components.second = 59
//        return calendar.date(from: components)!
//    }
//    
    func startOfMonth() -> Date {
        
        let calendar = Calendar.current
        let components = calendar.dateComponents([.month,.year], from: self)
        return calendar.date(from: components)!
    }
    
    func endOfMonth() -> Date {
        
        let calendar = Calendar.current
        var components = calendar.dateComponents([.month,.year], from: self)
        let dayRange = calendar.range(of: .day, in: .month, for: self)
        components.day = dayRange?.count
        components.hour = 23
        components.minute = 59
        components.second = 59
        return calendar.date(from: components)!
    }
    
    static func getWeekDayFrom(dateStr: String?) -> String {
        if let dateStr = dateStr {
            let today = Date.dateFormatter().string(from: Date())
            if today == dateStr {
                return "Today"
            }
            if let date = Date.dateFormatter().date(from: dateStr) {
                let dayOfTheWeekString = Date.dateFormatter(format: "E").string(from: date)
                return dayOfTheWeekString
            }
        }
        return "-"
    }
    
    static func getOnlyDateFrom(dateStr: String?) -> String {
        if let dateStr = dateStr {
            if dateStr.count >= 2 {
                return String(dateStr.prefix(2))
            }
        }
        return "-"
    }
}

