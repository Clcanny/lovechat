//
//  VideoMessageSctionController.swift
//  lovechat
//
//  Created by Demons on 2017/6/10.
//  Copyright © 2017年 Demons. All rights reserved.
//

import UIKit
import IGListKit
import Async

class VideoMessageSctionController: PVCommonSectionController {
    
    init(videoMessageModel: VideoMessageModel) {
        super.init(messageModel: videoMessageModel)
    }
    
    override func loadImage(model: UrlMessageModel) {
        let videoMessageModel = model as! VideoMessageModel
        self.image = videoMessageModel.getPreview()
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        let cell = collectionContext!.dequeueReusableCell(
            of: VideoMessageCollectionViewCell.self,
            for: self, at: index
            ) as! VideoMessageCollectionViewCell
        
        // The order is important.
        if psize != nil {
            cell.pictureSize = psize!
            cell.image = image!
        }
        
        if (messageModel!.getLR()) {
            cell.keepRight()
        }
        else {
            cell.keepLeft()
        }
        
        cell.url = messageModel?.localUrl
        cell.delegate = delegate
        return cell
    }
    
}
