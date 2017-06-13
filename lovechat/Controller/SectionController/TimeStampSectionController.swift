//
//  TimeStampSectionController.swift
//  lovechat
//
//  Created by Demons on 2017/6/4.
//  Copyright © 2017年 Demons. All rights reserved.
//

import UIKit
import IGListKit

class TimeStampSectionController: ListSectionController {

    private var timeStamp: String?
    
    private var tsize: CGSize?
    
    init(timeStamp: String?) {
        super.init()
        self.timeStamp = timeStamp
        inset = UIEdgeInsets(top: 0, left: 0, bottom: 3, right: 0)
    }
    
    override func numberOfItems() -> Int {
        return 1
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        guard let context = collectionContext, let str = timeStamp else {
            return .zero
        }
        
        tsize = textSize(
            maxWidth: context.containerSize.width,
            text: str,
            font: timeStampFont
        )
        let height = tsize!.height
        
        return CGSize(
            width: context.containerSize.width,
            height: height
        )
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        let cell = collectionContext!.dequeueReusableCell(
            of: TimeStampCollectionViewCell.self,
            for: self, at: index
            ) as! TimeStampCollectionViewCell
        cell.timeStamp = timeStamp
        cell.timeStampSize = tsize!
        return cell
    }
    
}
