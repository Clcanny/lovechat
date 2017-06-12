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
    
    // abstract method
    func afterDownload(url: URL?, localUrl: URL, error: Any?) {
        fatalError()
    }
    
    let group = AsyncGroup()
    let mutex = Mutex()

//    let semaphore = DispatchSemaphore.init(value: 1)
    let storage = Storage.storage()
    
    init(message: URL, _ isReceiver: Bool) {
        super.init(isReceiver)
        self.message = message
        
        group.background {
            let reference = self.storage.reference(forURL: message.absoluteString)
            let filename = message.lastPathComponent
            let localUrl = FileManager.getUrl(filename: filename, isReceiver)
            self.message = localUrl
            if FileManager.isFileExist(filename: filename, isReceiver) {
                self.afterDownload(url: nil, localUrl: localUrl, error: nil)
            }
            else {
                print("begin")
//                self.semaphore.wait()
                _ = self.mutex.tryLock()
                _ = reference.write(toFile: localUrl) { (URL, error) -> Void in
                    self.group.background {
                        self.afterDownload(url: URL, localUrl: localUrl, error: error)
                        _ = self.mutex.unlock()
//                        self.semaphore.signal()
                    }
                }
            }
        }
    }
    
    public func getMessage() -> URL {
//        semaphore.wait()
        _ = mutex.tryLock()
        group.wait()
        _ = mutex.unlock()
        return message!
//        semaphore.signal()
    }
    
}
