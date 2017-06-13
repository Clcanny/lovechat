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

class PictureMessageSectionController: PVCommonSectionController {
    
    init(pictureMessageModel: PictureMessageModel) {
        super.init(messageModel: pictureMessageModel)
    }
    
    override func loadImage(model: UrlMessageModel) {
        let pictureMessageModel = model as! PictureMessageModel
        super.image = pictureMessageModel.getImage()
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        let cell = collectionContext!.dequeueReusableCell(
            of: PictureMessageCollectionViewCell.self,
            for: self, at: index
            ) as! PictureMessageCollectionViewCell
        
        // The order is important.
        cell.isLeft = messageModel!.getLR()
        if psize != nil {
            cell.pictureSize = psize!
            cell.setPicture(url: messageModel!.localUrl)
            cell.loadTo(precentage: 1.1)
        }
        else {
            loadData(observer: {
                (percentage) -> Void in
                cell.loadTo(precentage: percentage)
            })
        }
        if (messageModel!.getLR()) {
            cell.keepRight()
        }
        else {
            cell.keepLeft()
        }
        
        cell.delegate = delegate
        return cell
    }
    
}
