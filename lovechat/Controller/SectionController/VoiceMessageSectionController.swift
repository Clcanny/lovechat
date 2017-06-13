//
//  VoiceMessageSectionController.swift
//  lovechat
//
//  Created by Demons on 2017/6/5.
//  Copyright © 2017年 Demons. All rights reserved.
//

import UIKit
import IGListKit

class VoiceMessageSectionController: ListSectionController {
    
    private var voiceMessageModel: VoiceMessageModel?

    init(voiceMessageModel: VoiceMessageModel) {
        super.init()
        self.voiceMessageModel = voiceMessageModel
        inset = UIEdgeInsets(top: 0, left: 0, bottom: 5, right: 0)
    }
    
    override func numberOfItems() -> Int {
        return 1
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        return CGSize(
            width: collectionContext!.containerSize.width,
            height: VoiceMessageCollectionViewCell.radius * 2
        )
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        let cell = collectionContext!.dequeueReusableCell(
            of: VoiceMessageCollectionViewCell.self,
            for: self, at: index
            ) as! VoiceMessageCollectionViewCell
        
        cell.gesture?.isEnabled = false
        cell.isLeft = voiceMessageModel?.getLR()
        voiceMessageModel?.loadData(completion: {
            (messageModel) -> Void in
            let voiceMessageModel = messageModel as! VoiceMessageModel
            cell.url = voiceMessageModel.localUrl
            cell.gesture?.isEnabled = true
        }, observer: { (p) -> Void in return })
        cell.addWidth = CGFloat(voiceMessageModel!.getTime()) * 2
        
        if (voiceMessageModel!.getLR()) {
            cell.keepRight()
        }
        else {
            cell.keepLeft()
        }
        return cell
    }

}
