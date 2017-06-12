//
//  PictureMessageModel.swift
//  lovechat
//
//  Created by Demons on 2017/6/4.
//  Copyright © 2017年 Demons. All rights reserved.
//

import Foundation
import UIKit

class PictureMessageModel: UrlMessageModel {
    
    private var image: UIImage?
    
    override func afterDownload(url: URL?, localUrl: URL, error: Any?) {
        if let err = error {
            print(err)
        }
        else {
            let data = try? Data(contentsOf: localUrl)
            self.image = UIImage(data: data!)
        }
    }
    
    override init(message: URL, _ isReceiver: Bool) {
        super.init(message: message, isReceiver)
    }
    
    public func setImage(image: UIImage) {
        self.image = image
    }
    
    public func getImage() -> UIImage {
        clock.tryLock(whenCondition: NO_DATA)
        return image!
    }
    
}
