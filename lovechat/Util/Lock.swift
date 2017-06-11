//
//  Lock.swift
//  lovechat
//
//  Created by Demons on 2017/6/12.
//  Copyright © 2017年 Demons. All rights reserved.
//

import Foundation

func lock(obj: AnyObject, blk:() -> ()) {
    objc_sync_enter(obj)
    blk()
    objc_sync_exit(obj)
}
