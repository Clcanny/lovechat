//
//  VoiceMessageModel.swift
//  lovechat
//
//  Created by Demons on 2017/6/5.
//  Copyright © 2017年 Demons. All rights reserved.
//

import Foundation
import UIKit

class VoiceMessageModel: MessageModel {
    
    private var message: URL?
    private var time: Int?
    
    init(message: URL, time: Int, _ isReceiver: Bool) {
        super.init(isReceiver)
        self.message = message
        self.time = time
    }
    
    public func getMessage() -> URL {
        return message!
    }
    
    public func getTime() -> Int {
        return time!
    }
    
}
