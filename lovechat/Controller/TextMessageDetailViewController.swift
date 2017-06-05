//
//  TextMessageDetailViewController.swift
//  lovechat
//
//  Created by Demons on 2017/6/5.
//  Copyright © 2017年 Demons. All rights reserved.
//

import UIKit

class TextMessageDetailViewController: UIViewController {

    @IBOutlet weak var textLabel: UITextView!
    
    @IBAction func returnToChatViewController(_ sender: UITapGestureRecognizer) {
        dismiss(animated: false, completion: nil)
    }
    
    public var text: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        textLabel.font = AppFont(size: 24)
        textLabel.textAlignment = .center
        textLabel.text = text
        textLabel.isEditable = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
