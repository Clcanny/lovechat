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
    
    override func afterDownload(url: URL?, localUrl: URL, error: Any?) {
        if let err = error {
            print(err)
        }
        else {
            super.localUrl = localUrl
            let asset = AVURLAsset(url: localUrl)
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
        }
    }
    
    override init(message: URL, _ isReceiver: Bool) {
        super.init(message: message, isReceiver)
    }
    
    public func getPreview() -> UIImage {
        return preview!
    }
    
}
