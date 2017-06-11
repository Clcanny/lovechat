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
    
    static func getUrl(filename: String, _ isReceiver: Bool) -> URL {
        let paths = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask
        )
        var fileUrl: URL!
        if isReceiver {
            fileUrl = paths[0].appendingPathComponent("receiver").appendingPathComponent(filename)
        }
        else {
            fileUrl = paths[0].appendingPathComponent("sender").appendingPathComponent(filename)
        }
        print(fileUrl)
        return fileUrl
    }
    
    static func isFileExist(filename: String, _ isReceiver: Bool) -> Bool {
        let paths = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask
        )
        var fileUrl: URL!
        if isReceiver {
            fileUrl = paths[0].appendingPathComponent("receiver").appendingPathComponent(filename)
        }
        else {
            fileUrl = paths[0].appendingPathComponent("sender").appendingPathComponent(filename)
        }
        let fileExists = FileManager.default.fileExists(atPath: fileUrl.path)
        return fileExists
    }
    
}
