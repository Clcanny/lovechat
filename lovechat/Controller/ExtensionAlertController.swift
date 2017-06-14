//
//  ExtensionAlertController.swift
//  lovechat
//
//  Created by Demons on 2017/6/14.
//  Copyright © 2017年 Demons. All rights reserved.
//

import Foundation
import UIKit

extension UIAlertController {
    
    static func defaultErrorController(
        title: String, error: String,
        completion: @escaping () -> ()) -> UIAlertController {
        let alertController = UIAlertController(
            title: title,
            message: error,
            preferredStyle: .alert
        )
        let okAction = UIAlertAction(title: "OK", style: .default) { action in
            completion()
        }
        alertController.addAction(okAction)
        return alertController
    }
    
}
