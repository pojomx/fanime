//
//  Date+extension.swift
//  FANime
//
//  Created by Alan Milke on 15/04/25.
//
import Foundation

extension Date {
    func getYear () -> Int {
        let calendar = Calendar.current
        return calendar.component(.year, from: self)
    }
    
    func getMonth() -> Int {
        let calendar = Calendar.current
        return calendar.component(.month, from: self)
    }
}
