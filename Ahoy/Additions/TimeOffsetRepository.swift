//
//  TimeOffsetRepository.swift
//  Ahoy
//
//  Created by Santiago Sanchez merino on 08/03/2020.
//  Copyright © 2020 Santiago Sanchez Merino. All rights reserved.
//

import Foundation

struct TimeOffset {
    let amount: Int
    let unit: Calendar.Component
}

final class TimeOffsetRepository {
    
    static let factory: TimeOffsetRepository = TimeOffsetRepository()
    
    private init() { }
    
    func getTimeOffset(dateToCompareString: String) -> TimeOffset {
        let MINUTES_MILLIS: Double = 60
        let HOUR_MILLIS: Double = MINUTES_MILLIS * 60
        let DAY_MILLIS = HOUR_MILLIS * 24
        let MONTH_MILLIS = DAY_MILLIS * 30
        let YEAR_MILLIS = MONTH_MILLIS * 12
        
        let current = Date().timeIntervalSince1970
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        
        guard let dateToCompare = dateFormatter.date(from: dateToCompareString) else {
            return TimeOffset(amount: 0, unit: Calendar.Component.minute)
        }
        
        let diff = current - dateToCompare.timeIntervalSince1970
        
        let years = Int(diff / YEAR_MILLIS)
        if (years > 0) { return TimeOffset(amount: years, unit: Calendar.Component.year) }
        
        let months = Int(diff / MONTH_MILLIS)
        if (months > 0) { return TimeOffset(amount: months, unit: Calendar.Component.month)}
        
        let days = Int(diff / DAY_MILLIS)
        if (days > 0) { return TimeOffset(amount: days, unit: Calendar.Component.day)}
        
        let hours = Int(diff / HOUR_MILLIS)
        if (hours > 0) { return TimeOffset(amount: hours, unit: Calendar.Component.hour)}
        
        let minutes = Int(diff / MINUTES_MILLIS)
        if (minutes > 0) { return TimeOffset(amount: minutes, unit: Calendar.Component.minute)}
        
        return TimeOffset(amount: 0, unit: Calendar.Component.minute)
    }
    
}
