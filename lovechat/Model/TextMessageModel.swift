//
//  TextMessageModel.swift
//  lovechat
//
//  Created by Demons on 2017/6/4.
//  Copyright © 2017年 Demons. All rights reserved.
//

import Foundation
import IGListKit

class TextMessageModel: NSObject {
    
    private var message: String?
    private var isReceiver: Bool?
    
    init(message: String, _ isReceiver: Bool) {
        self.message = message
        self.isReceiver = isReceiver
    }
    
    public func getMessage() -> String {
        return message!
    }
    
    public func getLR() -> Bool {
        return isReceiver!
    }
    
}

extension NSObject: ListDiffable {
    
    public func diffIdentifier() -> NSObjectProtocol {
        return self
    }
    
    public func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        return isEqual(object)
    }
    
}
