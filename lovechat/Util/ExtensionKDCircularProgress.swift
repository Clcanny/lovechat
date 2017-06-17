//
//  ExtensionKDCircularProgress.swift
//  lovechat
//
//  Created by Demons on 2017/6/18.
//  Copyright © 2017年 Demons. All rights reserved.
//

import Foundation
import KDCircularProgress

extension KDCircularProgress {
    
    static func defaultProcessBar() -> KDCircularProgress {
        let progress = KDCircularProgress()
        progress.startAngle = -90
        progress.progressThickness = 0.2
        progress.trackThickness = 0.6
        progress.clockwise = true
        progress.gradientRotateSpeed = 2
        progress.roundedCorners = false
        progress.glowMode = .forward
        progress.glowAmount = 0.9
        progress.set(colors: UIColor.cyan ,UIColor.white, UIColor.magenta, UIColor.white, UIColor.orange)
        return progress
    }
    
}
