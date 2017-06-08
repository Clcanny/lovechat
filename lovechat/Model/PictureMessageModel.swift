//
//  PictureMessageModel.swift
//  lovechat
//
//  Created by Demons on 2017/6/4.
//  Copyright © 2017年 Demons. All rights reserved.
//

import Foundation
import UIKit

class PictureMessageModel: MessageModel {
    
    private var message: UIImage?
    
    init(message: UIImage, _ isReceiver: Bool) {
        super.init(isReceiver)
        self.message = message
    }
    
    public func getMessage() -> UIImage {
        return message!
    }
    
}
