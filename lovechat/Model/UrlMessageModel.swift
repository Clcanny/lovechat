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
import FirebaseStorage

class UrlMessageModel: MessageModel {
    
    internal var message: URL!
    internal var localUrl: URL!
    
    let NO_DATA = 1
    let GOT_DATA = 2
    var clock: NSConditionLock!
    
    // abstract method
    func afterDownload(url: URL?, localUrl: URL, error: Any?) {
        fatalError()
    }
    
    func loadData(completion: @escaping (UrlMessageModel) -> (), observer: @escaping (Double) -> ()) {
        Async.background {
            let reference = self.storage.reference(forURL: self.message.absoluteString)
            let filename = self.message.lastPathComponent
            let localUrl = FileManager.getUrl(filename: filename, self.isReceiver)
            self.localUrl = localUrl
            if FileManager.isFileExist(filename: filename, self.isReceiver) {
                self.afterDownload(url: nil, localUrl: localUrl, error: nil)
                Async.main {
                    completion(self)
                }
            }
            else {
                let downloadTask = reference.write(toFile: localUrl) { (URL, error) -> Void in
                    if let err = error {
                        print(err)
                    }
                    Async.background {
                        self.afterDownload(url: URL, localUrl: localUrl, error: error)
                        }.main {
                            completion(self)
                    }
                }
                downloadTask.observe(.progress) {
                    (snapshot) -> Void in
                    if let progress = snapshot.progress {
                        let completed = progress.completedUnitCount
                        let total = progress.totalUnitCount
                        if total != 0 {
                            observer(Double(completed) / Double(total))
                        }
                    }
                }
                downloadTask.observe(.success) { (snapshot) -> Void in
                    // Download completed successfully
                    observer(1.1)
                    downloadTask.removeAllObservers()
                }
            }
        }
    }
    
    let storage = Storage.storage()
    
    init(message: URL, _ isReceiver: Bool) {
        super.init(isReceiver)
        self.message = message
    }
    
    public func getMessage() -> URL {
        return message!
    }
    
}
