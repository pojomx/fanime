//
//  Date+Extension.swift
//  FANime
//
//  Created by Alan Milke on 09/04/25.
//
import Foundation

extension Date {
    
    func convertDateTimeZone(fromTimeZone: TimeZone, toTimeZone: TimeZone) -> Date? {
        let sourceFormatter = DateFormatter()
        sourceFormatter.timeZone = fromTimeZone
        sourceFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

        let targetFormatter = DateFormatter()
        targetFormatter.timeZone = toTimeZone
        targetFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

        let dateString = sourceFormatter.string(from: self)
        return targetFormatter.date(from: dateString)
    }
    
}
