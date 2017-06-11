//
//  Mutex.swift
//  lovechat
//
//  Created by Demons on 2017/6/12.
//  Copyright © 2017年 Demons. All rights reserved.
//

import Foundation

class Mutex {
    
    private let _mutex = UnsafeMutablePointer<pthread_mutex_t>.allocate(capacity: 1)
    
    init() {
        pthread_mutex_init(_mutex, nil)
    }
    
    func lock() -> Int32 {
        return pthread_mutex_lock(_mutex)
    }
    
    func unlock() -> Int32 {
        return pthread_mutex_unlock(_mutex)
    }
    
    func tryLock() -> Int32 {
        return pthread_mutex_trylock(_mutex)
    }
    
    deinit {
        pthread_mutex_destroy(_mutex)
        _mutex.deallocate(capacity: 1)
    }
    
}
