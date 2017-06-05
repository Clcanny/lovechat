//
//  ExtensionUIImage.swift
//  lovechat
//
//  Created by Demons on 2017/6/4.
//  Copyright © 2017年 Demons. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {

    func getPixelColor(pos: CGPoint) -> (CGFloat, CGFloat, CGFloat, CGFloat) {
        let pixelData = self.cgImage!.dataProvider!.data
        let data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)
        
        let pixelInfo: Int = ((Int(self.size.width) * Int(pos.y)) + Int(pos.x)) * 4
        
        let r = CGFloat(data[pixelInfo])
        let g = CGFloat(data[pixelInfo + 1])
        let b = CGFloat(data[pixelInfo + 2])
        let a = CGFloat(data[pixelInfo + 3])
        return (r, g, b, a)
    }

}
