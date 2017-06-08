//
//  ExtensionNSObject.swift
//  lovechat
//
//  Created by Demons on 2017/6/8.
//  Copyright © 2017年 Demons. All rights reserved.
//

import Foundation
import UIKit
import IGListKit

extension NSObject: ListDiffable {
    
    public func diffIdentifier() -> NSObjectProtocol {
        return self
    }
    
    public func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        return isEqual(object)
    }
    
}
