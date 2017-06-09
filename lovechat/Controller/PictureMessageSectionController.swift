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
        image = pictureMessageModel.getImage()
//        asyncGroup.background {
//            self.image = UIImage(contentsOfFile: pictureMessageModel.getMessage().path)!
//            }
    }
    
    override func numberOfItems() -> Int {
        return 1
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        guard let context = collectionContext else {
            return .zero
        }
        
//        asyncGroup.wait()
        psize = pictureSize(
            maxWidth: TextMessageCollectionViewCell.maxWidth,
            picture: image!
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
        // The order is important.
        cell.pictureSize = psize!
//        asyncGroup.wait()
        cell.picture = image!
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
