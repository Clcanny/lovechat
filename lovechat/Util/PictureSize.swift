//
//  PictureSize.swift
//  lovechat
//
//  Created by Demons on 2017/6/4.
//  Copyright © 2017年 Demons. All rights reserved.
//

import Foundation
import UIKit

func pictureSize(maxWidth: CGFloat, picture: UIImage) -> CGSize {
    let pictureWidth: CGFloat = picture.size.width
    let pictureHeight: CGFloat = picture.size.height
    
    if (pictureWidth <= maxWidth) {
        return CGSize(width: pictureWidth, height: pictureWidth)
    }
    else {
        return CGSize(width: maxWidth, height: pictureHeight * (maxWidth / pictureWidth))
    }
}
