//
//  PictureMessageModel.swift
//  lovechat
//
//  Created by Demons on 2017/6/4.
//  Copyright © 2017年 Demons. All rights reserved.
//

import Foundation
import UIKit

class PictureMessageModel: MessageModel {
    
    private var message: URL?
    
    private var image: UIImage?
    
    init(message: URL, _ isReceiver: Bool) {
        super.init(isReceiver)
        self.message = message
    }
    
    public func getMessage() -> URL {
        return message!
    }
    
    public func setImage(image: UIImage) {
        self.image = image
    }
    
    public func getImage() -> UIImage {
        return image!
    }
    
}
