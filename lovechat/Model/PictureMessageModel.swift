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
    let storage = Storage.storage()
    
    override init(message: URL, _ isReceiver: Bool) {
        super.init(message: message, isReceiver)
        group.background {
            let reference = self.storage.reference(forURL: message.absoluteString)
            let filename = message.lastPathComponent
            let localUrl = FileManager.getUrl(filename: filename)
            super.message = localUrl
            if FileManager.isFileExist(filename: filename) {
                let data = try? Data(contentsOf: localUrl)
                self.image = UIImage(data: data!)
            }
            else {
                _ = reference.write(toFile: localUrl) { (URL, error) -> Void in
                    if let err = error {
                        print(err)
                    }
                    else {
                        let data = try? Data(contentsOf: localUrl)
                        self.image = UIImage(data: data!)
                    }
                }
            }
        }
    }
    
    public func setImage(image: UIImage) {
        self.image = image
    }
    
    public func getImage() -> UIImage {
        group.wait()
        return image!
    }
    
}
