//
//  PictureMessageModel.swift
//  lovechat
//
//  Created by Demons on 2017/6/4.
//  Copyright © 2017年 Demons. All rights reserved.
//

import Foundation
import IGListKit

class PictureMessageModel: NSObject {
    
    private var message: UIImage?
    private var isReceiver: Bool?
    
    init(message: UIImage, _ isReceiver: Bool) {
        self.message = message
        self.isReceiver = isReceiver
    }
    
    public func getMessage() -> UIImage {
        return message!
    }
    
    public func getLR() -> Bool {
        return isReceiver!
    }
    
}
