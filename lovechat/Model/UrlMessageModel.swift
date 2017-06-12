//
//  UrlMessageModel.swift
//  lovechat
//
//  Created by Demons on 2017/6/11.
//  Copyright © 2017年 Demons. All rights reserved.
//

import Foundation
import UIKit
import Async
import Firebase

class UrlMessageModel: MessageModel {
    
    internal var message: URL?
    
    let NO_DATA = 1
    let GOT_DATA = 2
    var clock: NSConditionLock!
    
    // abstract method
    func afterDownload(url: URL?, localUrl: URL, error: Any?) {
        fatalError()
    }
    
    let storage = Storage.storage()
    
    init(message: URL, _ isReceiver: Bool) {
        super.init(isReceiver)
        self.message = message
        
        clock = NSConditionLock(condition: NO_DATA)
        Async.background {
            let reference = self.storage.reference(forURL: message.absoluteString)
            let filename = message.lastPathComponent
            let localUrl = FileManager.getUrl(filename: filename, isReceiver)
            self.message = localUrl
            if FileManager.isFileExist(filename: filename, isReceiver) {
                self.afterDownload(url: nil, localUrl: localUrl, error: nil)
            }
            else {
                _ = reference.write(toFile: localUrl) { (URL, error) -> Void in
                    Async.background {
                        self.afterDownload(url: URL, localUrl: localUrl, error: error)
                        self.clock.unlock(withCondition: self.GOT_DATA)
                    }
                }
            }
        }
    }
    
    public func getMessage() -> URL {
        clock.tryLock(whenCondition: NO_DATA)
        return message!
    }
    
}
