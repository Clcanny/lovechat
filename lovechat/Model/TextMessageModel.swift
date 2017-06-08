//
//  TextMessageModel.swift
//  lovechat
//
//  Created by Demons on 2017/6/4.
//  Copyright © 2017年 Demons. All rights reserved.
//

import Foundation
import UIKit

class TextMessageModel: MessageModel {
    
    private var message: String?
    
    init(message: String, _ isReceiver: Bool) {
        super.init(isReceiver)
        self.message = message
    }
    
    public func getMessage() -> String {
        return message!
    }
    
}
