//
//  RememberModel.swift
//  lovechat
//
//  Created by Demons on 2017/6/14.
//  Copyright © 2017年 Demons. All rights reserved.
//

import Foundation

class RememberModel {
    
    var title: String
    var key: String?
    var dateComponent: DateComponents
    
    var showAfterDays = true
    
    init(title: String, dateComponent: DateComponents) {
        self.title = title
        self.dateComponent = dateComponent
    }
    
    convenience init(
        title: String = "An important day",
        year: Int = 2017,
        month: Int = 6,
        day: Int = 15) {
        let dc: DateComponents = DateComponents(year: year, month: month, day: day);
        self.init(title: title, dateComponent: dc);
    }
    
    func getYear() -> Int {
        return dateComponent.year!
    }
    
    func getMonth() -> Int {
        return dateComponent.month!
    }
    
    func getDay() -> Int {
        return dateComponent.day!
    }
    
    private let userCalendar = Calendar.current
    private let formatter = DateFormatter()
    var formatDateString: String {
        get {
            let date = userCalendar.date(from: dateComponent)
            formatter.dateStyle = .long
            return formatter.string(from: date!)
        }
    }
    
    var afterDays: String {
        get {
            let currentDate = Date()
            let calendar = Calendar.current
            let currentDateComponent = calendar.dateComponents([.year, .month, .day], from: currentDate)
            
            let dayDiff = calendar.dateComponents([.day], from: dateComponent, to: currentDateComponent)
            return String(dayDiff.day!)
        }
    }
    
    var untilDays: String {
        get {
            let currentDate = Date()
            let calendar = Calendar.current
            let currentDateComponent = calendar.dateComponents([.year, .month, .day], from: currentDate)
            
            var futureDateComponent = dateComponent
            while !(futureDateComponent >= currentDateComponent) {
                futureDateComponent.year = futureDateComponent.year! + 1
            }
            
            let dayDiff = calendar.dateComponents(
                [.day], from: currentDateComponent, to: futureDateComponent
            )
            return String(dayDiff.day!)
        }
    }
    
    var dayDiff: String {
        if showAfterDays {
            return afterDays;
        }
        else {
            return untilDays;
        }
    }

}
