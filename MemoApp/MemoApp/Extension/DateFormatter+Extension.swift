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
    
    /*
    추가 작업 필요: 날짜 포맷 형태를 3가지 케이스로 나누기
     */
    static func date2String(date: Date) -> String {
        let dateformatter = DateFormatter.customFormatter
        return dateformatter.string(from: date)        
    }
}


