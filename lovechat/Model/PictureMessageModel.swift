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
            reference.getData(maxSize: 10 * 1024 * 1024) { (data, error) -> Void in
                if error != nil {
                    // Uh-oh, an error occurred!
                    print("fuck")
                    print(error)
                } else {
                    self.setImage(image: UIImage(data: data!)!)
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
