//
//  VideoMessageModel.swift
//  lovechat
//
//  Created by Demons on 2017/6/10.
//  Copyright © 2017年 Demons. All rights reserved.
//

import Foundation
import UIKit
import Async
import AVFoundation

class VideoMessageModel: UrlMessageModel {
    
    private var preview: UIImage?
    
    let semaphore = DispatchSemaphore(value: 1)
    
    override func afterDownload(url: URL?, localUrl: URL, error: Any?) {
        if let err = error {
            print(err)
        }
        else {
            print("testVideo")
            message = localUrl
//            let asset = AVURLAsset(url: self.message!)
//            let generator = AVAssetImageGenerator(asset: asset)
//            generator.appliesPreferredTrackTransform = true
//            let timestamp = CMTime(seconds: 2, preferredTimescale: 60)
//            do {
//                let imageRef = try generator.copyCGImage(at: timestamp, actualTime: nil)
//                self.preview = UIImage(cgImage: imageRef)
//                
//            }
//            catch {
//                fatalError()
//            }
        }
    }
    
    override init(message: URL, _ isReceiver: Bool) {
        semaphore.wait()
        super.init(message: message, isReceiver)
        print("lock")
        semaphore.signal()
    }
    
    public func getPreview() -> UIImage {
        mutex.tryLock()
        semaphore.wait()
//        group.background {
//        if preview == nil {
//            let asset = AVURLAsset(url: self.message!)
//            let generator = AVAssetImageGenerator(asset: asset)
//            generator.appliesPreferredTrackTransform = true
//            let timestamp = CMTime(seconds: 2, preferredTimescale: 60)
//            do {
//                let imageRef = try generator.copyCGImage(at: timestamp, actualTime: nil)
//                self.preview = UIImage(cgImage: imageRef)
//            }
//            catch {
//                fatalError()
//            }
//        }
////        }
        group.wait()
//        let p = preview!
        let asset = AVURLAsset(url: self.message!)
        print(self.message!)
        let generator = AVAssetImageGenerator(asset: asset)
        generator.appliesPreferredTrackTransform = true
        let timestamp = CMTime(seconds: 2, preferredTimescale: 60)
        do {
            let imageRef = try generator.copyCGImage(at: timestamp, actualTime: nil)
            self.preview = UIImage(cgImage: imageRef)
        }
        catch {
            print(error)
            fatalError()
        }
        mutex.unlock()
        semaphore.signal()
        return preview!
    }
    
}
