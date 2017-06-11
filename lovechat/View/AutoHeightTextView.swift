//
//  AutoHeightTextView.swift
//  lovechat
//
//  Created by Demons on 2017/6/11.
//  Copyright © 2017年 Demons. All rights reserved.
//

import UIKit

class AutoHeightTextView: UITextView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    var minHeight: CGFloat!
    var maxHeight: CGFloat!
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        let width = bounds.width
        let height = textSize(maxWidth: width, text: text, font: inputFont).height
        if height < minHeight {
            return CGSize(width: width, height: minHeight)
        }
        else if height < maxHeight {
            return CGSize(width: width, height: height)
        }
        else {
            return CGSize(width: width, height: maxHeight)
        }
    }

}
