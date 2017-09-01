//
//  Weeks.swift
//  Haggle
//
//  Created by Aamahd Walker on 8/25/17.
//  Copyright © 2017 Aamahd Walker. All rights reserved.
//

import Foundation

// Countdown folder seemed like the most appropriate place to add this file.
// Typically enums are singular to make each case self-evident, but using plural form in this case reads better in my opinion.
// Expiration date of an item can be 1-3 weeks out from current date.

enum Weeks: Int  {
    case one
    case two
    case three
}


extension Weeks {
    
    var timeInterval: Double? {
        
        let currentDate = Date()
        var expirationDate: Date?
        let calendar = Calendar.current
        
        switch self {
        case .one: expirationDate = calendar.date(byAdding: .day, value: 7, to: currentDate)
        case .two: expirationDate = calendar.date(byAdding: .day, value: 14, to: currentDate)
        case .three: expirationDate = calendar.date(byAdding: .day, value: 21, to: currentDate)
        }
        
        if let expirationDate = expirationDate {
            return expirationDate.timeIntervalSince1970 as Double
        }else {
            return nil
        }
    }
    
}
