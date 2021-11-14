import Foundation

extension DateFormatter {

    static var customFormatter: DateFormatter {
     
        get {
            let dateFormatter = DateFormatter()
            dateFormatter.locale = .autoupdatingCurrent
            dateFormatter.timeZone = .autoupdatingCurrent
            dateFormatter.dateFormat = "yyyy. MM. dd a HH:mm"
            print(dateFormatter)
            
            return dateFormatter
        }
        
    }
    
    static func date2String(date: Date) -> String {
        let dateformatter = DateFormatter.customFormatter
        let calendar = Calendar.autoupdatingCurrent
        
        let isToday = calendar.isDateInToday(date)
        if isToday {
            dateformatter.dateFormat = "a HH:mm"
        }
        
        if calendar.compare(calendar.startOfWeek(for: date)!, to: date, toGranularity: .day) == .orderedAscending &&
            calendar.compare(calendar.endOfWeek(for: date)!, to: date, toGranularity: .day) == .orderedAscending {
            dateformatter.dateFormat = "EEEE"
        }
        
        return dateformatter.string(from: date)        
    }
}

extension Calendar {
    
    func intervalOfWeek(for date: Date) -> DateInterval? {
        dateInterval(of: .weekOfYear, for: date)
    }

    func startOfWeek(for date: Date) -> Date? {
        intervalOfWeek(for: date)?.start
    }
    
    func endOfWeek(for date: Date) -> Date? {
        intervalOfWeek(for: date)?.end
    }
}
