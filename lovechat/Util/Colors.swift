//
//  Colors.swift
//  lovechat
//
//  Created by Demons on 2017/6/4.
//  Copyright © 2017年 Demons. All rights reserved.
//

import Foundation
import UIKit

func opaqueColor(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
    return UIColor(red: red / 255.0, green: green / 255.0 , blue: blue / 255.0 , alpha: 1)
}

let pastelGreenColor = opaqueColor(red: 130, green: 240, blue: 119)
let robinEggColor = opaqueColor(red: 144, green: 218, blue: 245)
let ivoryColor = opaqueColor(red: 255, green: 255, blue: 241)
let icebergColor = opaqueColor(red: 200, green: 213, blue: 219)
let babyBlueColor = opaqueColor(red: 191, green: 220, blue: 229)
