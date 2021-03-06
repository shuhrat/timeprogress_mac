//
//  CustomDeadline.swift
//  Time Progress
//
//  Created by Brian Valente on 11/27/18.
//  Copyright © 2018 Brian Valente. All rights reserved.
//

import Foundation

class CustomDeadline {
    
    static var from: Date? {
        get {
            let timeFrom = UserDefaults.standard.string(forKey: "customdeadline.time.from") ?? "08:00:00"
            let formatter = DateFormatter()
            
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            
            let nowObj = Date()
            let calendar = Calendar.current
            let day = calendar.component(Calendar.Component.day, from: nowObj)
            let month = calendar.component(Calendar.Component.month, from: nowObj)
            let year = calendar.component(Calendar.Component.year, from: nowObj)
            
            guard
                let fromObj = formatter.date(from: "\(year)-\(month)-\(day) \(timeFrom)")
                else {
                    return nil
            }
            
            return fromObj
        }
        set {
            guard let time = newValue else {
                return
            }
            
            let calendar = Calendar.current
            let hour = calendar.component(Calendar.Component.hour, from: time)
            let minute = calendar.component(Calendar.Component.minute, from: time)
            let second = calendar.component(Calendar.Component.second, from: time)
            
            let string = "\(hour):\(minute):\(second)"
            UserDefaults.standard.setValue(string, forKey: "customdeadline.time.from")
        }
    }
    
    static var to: Date? {
        get {
            let timeTo = UserDefaults.standard.string(forKey: "customdeadline.time.to") ?? "17:00:00"
            
            let formatter = DateFormatter()
            
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            
            let nowObj = Date()
            let calendar = Calendar.current
            let day = calendar.component(Calendar.Component.day, from: nowObj)
            let month = calendar.component(Calendar.Component.month, from: nowObj)
            let year = calendar.component(Calendar.Component.year, from: nowObj)
            
            guard
                let toObj = formatter.date(from: "\(year)-\(month)-\(day) \(timeTo)"),
                let fromObj = CustomDeadline.from
                else {
                    return nil
            }
            
            if (fromObj.timeIntervalSince1970 > toObj.timeIntervalSince1970) {
                return toObj.dayAfter
            }
            
            return toObj
        } set {
            guard let time = newValue else {
                return
            }
            
            let calendar = Calendar.current
            let hour = calendar.component(Calendar.Component.hour, from: time)
            let minute = calendar.component(Calendar.Component.minute, from: time)
            let second = calendar.component(Calendar.Component.second, from: time)
            
            let string = "\(hour):\(minute):\(second)"
            UserDefaults.standard.setValue(string, forKey: "customdeadline.time.to")
        }
    }
    
    static var stringValue: String {
        let percentage = self.percentage
        
        if (percentage == 100) {
            return "Finished!"
        } else if (percentage == -1) {
            return "Not yet!"
        }
        
        return String(percentage) + "%"
    }
    
    static var percentage: Int {
        guard
            let timeFrom = CustomDeadline.from,
            let timeTo = CustomDeadline.to
            else {
                return -1
        }
        
        let from = timeFrom.timeIntervalSince1970
        let to = timeTo.timeIntervalSince1970
        let now = Date().timeIntervalSince1970
        
        var percentage = ((now - from) * 100) / (to - from)
        
        if (percentage > 100) {
            percentage = 100
        } else if (percentage < 0) {
            percentage = -1
        }
        
        return Int(percentage)
    }
    
    static var name: String {
        get {
            if let name = UserDefaults.standard.string(forKey: "customdeadline.name"), !name.isEmpty {
                return name
            } else {
                return "Work 💻"
            }
        }
        
        set {
            UserDefaults.standard.setValue(newValue, forKey: "customdeadline.name")
        }
    }
}
