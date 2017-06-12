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

class VideoMessageSctionController: ListSectionController {
    
    private var videoMessageModel: VideoMessageModel?
    
    private var psize: CGSize?
    
    private var image: UIImage?
    
    public var delegate: SegueFromCellProtocol?
    
    init(videoMessageModel: VideoMessageModel) {
        super.init()
        self.videoMessageModel = videoMessageModel
        inset = UIEdgeInsets(top: 0, left: 0, bottom: 5, right: 0)
    }
    
    override func numberOfItems() -> Int {
        return 1
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        guard let context = collectionContext else {
            return .zero
        }
        
        if image == nil {
            let pictureHeight = VideoMessageCollectionViewCell.maxWidth
            Async.background {
                self.image = self.videoMessageModel?.getPreview()
                }.main {
                    self.collectionContext?.performBatch(animated: false, updates: { (batchContext) in
                        batchContext.reload(self)
                    }, completion: nil)
            }
            return CGSize(
                width: context.containerSize.width,
                height: pictureHeight
            )
        }
        else {
            psize = pictureSize(
                maxWidth: VideoMessageCollectionViewCell.maxWidth,
                picture: self.image!
            )
            return CGSize(
                width: context.containerSize.width,
                height: psize!.height
            )
        }
//        image = videoMessageModel?.getPreview()
//        psize = pictureSize(
//            maxWidth: TextMessageCollectionViewCell.maxWidth,
//            picture: self.image!
//        )
//        return CGSize(
//            width: context.containerSize.width,
//            height: psize!.height
//        )
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        let cell = collectionContext!.dequeueReusableCell(
            of: VideoMessageCollectionViewCell.self,
            for: self, at: index
            ) as! VideoMessageCollectionViewCell
        
        // The order is important.
        if psize != nil {
            cell.pictureSize = psize!
        }
        if image != nil {
            cell.image = image!
        }
//        cell.pictureSize = psize!
//        cell.image = image
        if (videoMessageModel!.getLR()) {
            cell.keepRight()
        }
        else {
            cell.keepLeft()
        }
        cell.url = videoMessageModel?.getMessage()
        cell.delegate = delegate
        return cell
    }
    
}
