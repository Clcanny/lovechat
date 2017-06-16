//
//  EmojiKeyboardDelegate.swift
//  lovechat
//
//  Created by Demons on 2017/6/15.
//  Copyright © 2017年 Demons. All rights reserved.
//

import Foundation
import UIKit

protocol EmojiKeyboardViewDelegate {
    
    func fun(emojiKeyBoardView: EmojiKeyboardView, didUseEmoji emoji: String) -> Void
    func fun(emojiKeyBoardViewDidPressBackSpace emojiKeyBoardView: EmojiKeyboardView) -> Void
    
}
