//
//  MessageModel.swift
//  lovechat
//
//  Created by Demons on 2017/6/8.
//  Copyright © 2017年 Demons. All rights reserved.
//

import Foundation

class MessageModel: NSObject {
    
    private var isReceiver: Bool?
    
    public init(_ isReceiver: Bool) {
        self.isReceiver = isReceiver
    }
    
    public func getLR() -> Bool {
        return !isReceiver!
    }
    
}
