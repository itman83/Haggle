//
//  Date+Countdown.swift
//  Haggle
//
//  Created by Aamahd Walker on 8/6/17.
//  Copyright © 2017 Aamahd Walker. All rights reserved.
//


import Foundation


extension Date {
    
    
    func hours(from date: Date) -> Int? {
        
        let difference = Calendar.current.dateComponents([.hour], from: self, to: date)
        
        guard let hours = difference.hour else {
            return nil
        }
        
        return -hours
    }
    
    
    // Get time until expiration date.
    func countdown(to date: Date) -> CountdownResponse {
    
        let difference = Calendar.current.dateComponents([.day, .hour, .minute, .second], from: self, to: date)
        
        guard let day = difference.day, let hour = difference.hour, let minute = difference.minute, let second = difference.second else {
            return .error(message: "One or more date components are nil.")
        }
        
        if day <= 0 && hour <= 0 && minute <= 0 && second <= 0 {
            return .isFinished
        }
        
        let days = displayableText(from: difference.day)
        let hours = displayableText(from: difference.hour)
        let minutes = displayableText(from: difference.minute)
        let seconds = displayableText(from: difference.second)
    
        let timeRemaining = "\(days) : \(hours) : \(minutes) : \(seconds)"

        return .result(time: timeRemaining)
    }
    
    
    // - output a decimal number in 2 digits filling with zeros.
    private func displayableText(from number: Int?) -> String {
        guard let number = number else {
            return String(format: "%02d", 0)
        }
        return String(format: "%02d", number)
    }
}


