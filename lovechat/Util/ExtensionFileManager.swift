//
//  ExtensionFileManager.swift
//  lovechat
//
//  Created by Demons on 2017/6/10.
//  Copyright © 2017年 Demons. All rights reserved.
//

import Foundation

extension FileManager {
    
    static func getUrlByCurrentTime(suffix: String) -> URL {
        let paths = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask
        )
        let currentTime = Date().timeIntervalSince1970
        let fileUrl = paths[0].appendingPathComponent(String(currentTime) + "." + suffix)
        return fileUrl
    }
    
}
