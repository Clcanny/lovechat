//
//  PictureMessageSectionController.swift
//  lovechat
//
//  Created by Demons on 2017/6/4.
//  Copyright © 2017年 Demons. All rights reserved.
//

import UIKit
import IGListKit
import Async

class PictureMessageSectionController: ListSectionController {
    
    private var pictureMessageModel: PictureMessageModel?
    
    private var psize: CGSize?
    
    public var delegate: SegueFromCellProtocol?
    
    private let asyncGroup = AsyncGroup()
    private var image: UIImage?
    
    init(pictureMessageModel: PictureMessageModel) {
        super.init()
        self.pictureMessageModel = pictureMessageModel
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
            let pictureHeight = PictureMessageCollectionViewCell.maxWidth
            //            Async.background {
            //                self.image = self.pictureMessageModel?.getImage()
            //                }.main {
            //                    self.collectionContext?.performBatch(animated: false, updates: { (batchContext) in
            //                        batchContext.reload(self)
            //                    }, completion: nil)
            //            }
            pictureMessageModel?.loadData(completion: {
                (model) -> Void in
                let pictureMessageModel = model as! PictureMessageModel
                self.image = pictureMessageModel.getImage()
                self.collectionContext?.performBatch(
                    animated: false,
                    updates: {
                        (batchContext) -> Void in
                        batchContext.reload(self) },
                    completion: nil
                )
            })
            return CGSize(
                width: context.containerSize.width,
                height: pictureHeight
            )
        }
        else {
            psize = pictureSize(
                maxWidth: TextMessageCollectionViewCell.maxWidth,
                picture: self.image!
            )
            return CGSize(
                width: context.containerSize.width,
                height: psize!.height
            )
        }
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        let cell = collectionContext!.dequeueReusableCell(
            of: PictureMessageCollectionViewCell.self,
            for: self, at: index
            ) as! PictureMessageCollectionViewCell
        
        // The order is important.
        if psize != nil {
            cell.pictureSize = psize!
        }
        if image != nil {
            cell.setPicture(url: pictureMessageModel!.localUrl)
        }
        if (pictureMessageModel!.getLR()) {
            cell.keepRight()
        }
        else {
            cell.keepLeft()
        }
        cell.delegate = delegate
        return cell
    }
    
}
