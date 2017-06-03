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
    
    private var text: String?
    
    private var tsize: CGSize?
    
    init(text: String) {
        self.text = text
        super.init()
        inset = UIEdgeInsets(top: 0, left: 0, bottom: 5, right: 0)
    }
    
    override func numberOfItems() -> Int {
        return 1
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        guard let context = collectionContext, let str = text else {
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
        cell.text = text
        cell.textSize = tsize!
        cell.keepRight()
        return cell
    }
    
}
