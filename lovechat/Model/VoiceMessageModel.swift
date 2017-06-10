//
//  VoiceMessageModel.swift
//  lovechat
//
//  Created by Demons on 2017/6/5.
//  Copyright © 2017年 Demons. All rights reserved.
//

import Foundation
import UIKit

class VoiceMessageModel: UrlMessageModel {
    
    private var time: Int?
    
    init(message: URL, time: Int, _ isReceiver: Bool) {
        super.init(message: message, isReceiver)
        self.time = time
    }
    
    public func getTime() -> Int {
        return time!
    }
    
}
