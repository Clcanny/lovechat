//
//  TextMessageSectionController.swift
//  lovechat
//
//  Created by Demons on 2017/6/3.
//  Copyright © 2017年 Demons. All rights reserved.
//

import UIKit
import IGListKit

class TextMessageSectionController: ListSectionController {
    
    public var delegate: SegueFromCellProtocol?
    
    private var textMessageModel: TextMessageModel?
    
    private var tsize: CGSize?
    
    init(textMessageModel: TextMessageModel) {
        super.init()
        self.textMessageModel = textMessageModel
        inset = UIEdgeInsets(top: 0, left: 0, bottom: 5, right: 0)
    }
    
    override func numberOfItems() -> Int {
        return 1
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        guard let context = collectionContext, let str = textMessageModel?.getMessage() else {
            return .zero
        }
        
        tsize = textSize(
            maxWidth: TextMessageCollectionViewCell.maxWidth,
            text: str,
            font: textMessageFont
        )
        let textHeight = tsize!.height
        
        return CGSize(
            width: context.containerSize.width,
            height: textHeight + TextMessageCollectionViewCell.padding * 2
        )
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        let cell = collectionContext!.dequeueReusableCell(
            of: TextMessageCollectionViewCell.self,
            for: self, at: index
        ) as! TextMessageCollectionViewCell
        cell.text = textMessageModel!.getMessage()
        cell.textSize = tsize!
        if (textMessageModel!.getLR()) {
            cell.keepRight()
        }
        else {
            cell.keepLeft()
        }
        cell.delegate = delegate
        return cell
    }
    
}
