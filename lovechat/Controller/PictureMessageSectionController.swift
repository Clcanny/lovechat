//
//  PictureMessageSectionController.swift
//  lovechat
//
//  Created by Demons on 2017/6/4.
//  Copyright © 2017年 Demons. All rights reserved.
//

import UIKit
import IGListKit

class PictureMessageSectionController: ListSectionController {
    
    private var pictureMessageModel: PictureMessageModel?
    
    private var psize: CGSize?

    init(pictureMessageModel: PictureMessageModel) {
        super.init()
        self.pictureMessageModel = pictureMessageModel
        inset = UIEdgeInsets(top: 0, left: 0, bottom: 5, right: 0)
    }
    
    override func numberOfItems() -> Int {
        return 1
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        guard let context = collectionContext, let picture = pictureMessageModel?.getMessage() else {
            return .zero
        }
        
        psize = pictureSize(
            maxWidth: TextMessageCollectionViewCell.maxWidth,
            picture: picture
        )
        let pictureHeight = psize!.height
        
        return CGSize(
            width: context.containerSize.width,
            height: pictureHeight
        )
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        let cell = collectionContext!.dequeueReusableCell(
            of: PictureMessageCollectionViewCell.self,
            for: self, at: index
            ) as! PictureMessageCollectionViewCell
        cell.picture = pictureMessageModel!.getMessage()
        cell.pictureSize = psize!
        if (pictureMessageModel!.getLR()) {
            cell.keepRight()
        }
        else {
            cell.keepLeft()
        }
        return cell
    }

}
