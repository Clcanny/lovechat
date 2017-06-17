//
//  PVCommonSectionController.swift
//  lovechat
//
//  Created by Demons on 2017/6/13.
//  Copyright © 2017年 Demons. All rights reserved.
//

import UIKit
import IGListKit

class PVCommonSectionController: ListSectionController {
    
    var messageModel: UrlMessageModel?
    
    var psize: CGSize?
    
    public var delegate: SegueFromCellProtocol?
    
    var image: UIImage?
    
    init(messageModel: UrlMessageModel) {
        super.init()
        self.messageModel = messageModel
        inset = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
    }
    
    override func numberOfItems() -> Int {
        return 1
    }
    
    // abstract method
    func loadImage(model: UrlMessageModel) {
        fatalError()
    }
    
    func loadData(observer: @escaping (Double) -> ()) {
        messageModel?.loadData(completion: {
            (model) -> Void in
            self.loadImage(model: model)
            self.collectionContext?.performBatch(
                animated: false,
                updates: {
                    (batchContext) -> Void in
                    batchContext.reload(self) },
                completion: nil
            )
        }, observer: observer)
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        guard let context = collectionContext else {
            return .zero
        }
        
        if image == nil {
            return CGSize(
                width: context.containerSize.width,
                height: PVCommonCollectionViewCell.maxWidth
            )
        }
        else {
            psize = pictureSize(
                maxWidth: PVCommonCollectionViewCell.maxWidth,
                picture: self.image!
            )
            return CGSize(
                width: context.containerSize.width,
                height: psize!.height
            )
        }
    }

    
}
