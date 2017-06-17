//
//  TimeStampInserter.swift
//  lovechat
//
//  Created by Demons on 2017/6/18.
//  Copyright © 2017年 Demons. All rights reserved.
//

import Foundation

class TimeStampInserter {
    
    var lastUpdateTime: Int!
    
    func update() -> String? {
        let date = Date()
        let currentTime = Int(date.timeIntervalSince1970)
        let interval = currentTime - lastUpdateTime
        lastUpdateTime = currentTime
        if interval > 120 {
            return String(interval / 60) + " minutes ago"
        }
        else if interval > 300 {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            return dateFormatter.string(from: date)
        }
        else {
            return nil
        }
    }
    
    init() {
        lastUpdateTime = Int(Date().timeIntervalSince1970)
    }
    
}
