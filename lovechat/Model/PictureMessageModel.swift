//
//  PictureMessageModel.swift
//  lovechat
//
//  Created by Demons on 2017/6/4.
//  Copyright © 2017年 Demons. All rights reserved.
//

import Foundation
import UIKit
import Async
import Firebase

class PictureMessageModel: UrlMessageModel {
    
    private var image: UIImage?
    
    let group = AsyncGroup()
    let mutex = Mutex()
    let storage = Storage.storage()
    
    override func afterDownload(url: URL?, localUrl: URL, error: Any?) {
        if let err = error {
            print(err)
        }
        else {
            let data = try? Data(contentsOf: localUrl)
            self.image = UIImage(data: data!)
        }
        print("downloaded image complete.")
    }
    
    override init(message: URL, _ isReceiver: Bool) {
        super.init(message: message, isReceiver)
        group.background {
            let reference = self.storage.reference(forURL: message.absoluteString)
            let filename = message.lastPathComponent
            let localUrl = FileManager.getUrl(filename: filename, isReceiver)
            super.message = localUrl
            if FileManager.isFileExist(filename: filename, isReceiver) {
                let data = try? Data(contentsOf: localUrl)
                self.image = UIImage(data: data!)
                print("image have been download.")
            }
            else {
                print("begin to download image.")
                _ = self.mutex.lock()
                _ = reference.write(toFile: localUrl) { (URL, error) -> Void in
                    self.group.background {
                        self.afterDownload(url: URL, localUrl: localUrl, error: error)
                        _ = self.mutex.unlock()
                        //                        print("downloaded image complete.")
                    }
                }
                //                print("begin to download image.")
                //                _ = self.mutex.lock()
                //                _ = reference.write(toFile: localUrl) { (URL, error) -> Void in
                //                    self.group.background {
                //                        if let err = error {
                //                            print(err)
                //                        }
                //                        else {
                //                            let data = try? Data(contentsOf: localUrl)
                //                            self.image = UIImage(data: data!)
                //                        }
                ////                        print("downloaded image complete.")
                //                        _ = self.mutex.unlock()
                //                    }
            }
        }
    }
    
    public func setImage(image: UIImage) {
        self.image = image
    }
    
    public func getImage() -> UIImage {
        _ = mutex.lock()
        group.wait()
        _ = mutex.unlock()
        return image!
    }
    
}
