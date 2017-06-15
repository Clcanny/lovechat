//
//  ExtensionDateComponents.swift
//  lovechat
//
//  Created by Demons on 2017/6/15.
//  Copyright © 2017年 Demons. All rights reserved.
//

import Foundation

extension DateComponents {
    
    static func >= (left: DateComponents, right: DateComponents) -> Bool {
        let leftY = left.year!, leftM = left.month!, leftD = left.day!
        let rightY = right.year!, rightM = right.month!, rightD = right.day!
        
        if (leftY > rightY) {
            return true;
        }
        else if (leftY == rightY && leftM > rightM) {
            return true;
        }
        else if (leftY == rightY && leftM == rightM && leftD >= rightD) {
            return true;
        }
        else {
            return false;
        }
    }
    
}
