//
//  UrlMessageModel.swift
//  lovechat
//
//  Created by Demons on 2017/6/11.
//  Copyright © 2017年 Demons. All rights reserved.
//

import Foundation
import UIKit

class UrlMessageModel: MessageModel {
    
    internal var message: URL?
    
    init(message: URL, _ isReceiver: Bool) {
        super.init(isReceiver)
        self.message = message
    }
    
    public func getMessage() -> URL {
        return message!
    }
    
}
