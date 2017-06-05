//
//  VoiceMessageModel.swift
//  lovechat
//
//  Created by Demons on 2017/6/5.
//  Copyright © 2017年 Demons. All rights reserved.
//

import Foundation
import IGListKit

class VoiceMessageModel: NSObject {
    
    private var message: URL?
    private var isReceiver: Bool?
    
    init(message: URL, _ isReceiver: Bool) {
        self.message = message
        self.isReceiver = isReceiver
    }
    
    public func getMessage() -> URL {
        return message!
    }
    
    public func getLR() -> Bool {
        return isReceiver!
    }
    
}
