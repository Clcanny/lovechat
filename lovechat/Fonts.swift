//
//  Fonts.swift
//  lovechat
//
//  Created by Demons on 2017/6/3.
//  Copyright © 2017年 Demons. All rights reserved.
//

import Foundation
import SnapKit

func AppFont(size: CGFloat = 18) -> UIFont {
    return UIFont.systemFont(ofSize: size)
}

let textMessageFont = AppFont()
let timeStampFont = AppFont(size: 8)
