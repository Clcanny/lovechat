//
//  TextSize.swift
//  lovechat
//
//  Created by Demons on 2017/6/3.
//  Copyright © 2017年 Demons. All rights reserved.
//

import Foundation
import UIKit

func textSize(maxWidth: CGFloat, text: String, font: UIFont = AppFont()) -> CGSize {
    let label = UILabel(frame: CGRect(x: 0, y: 0, width: maxWidth, height: 99999))
    label.text = text
    label.font = font
    label.numberOfLines = 0
    label.lineBreakMode = NSLineBreakMode.byWordWrapping
    label.sizeToFit()
    return CGSize(width: label.frame.width, height: label.frame.height)
}
