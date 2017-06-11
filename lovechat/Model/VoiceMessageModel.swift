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
    
    override func afterDownload(url: URL?, localUrl: URL, error: Any?) {
//        if let err = error {
//            print(err)
//        }
//        else {
//            message = url
//        }
    }
    
    init(message: URL, time: Int, _ isReceiver: Bool) {
        super.init(message: message, isReceiver)
        self.time = time
    }
    
    public func getTime() -> Int {
        return time!
    }
    
}
