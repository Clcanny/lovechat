//
//  LoginViewController.swift
//  lovechat
//
//  Created by Demons on 2017/6/11.
//  Copyright © 2017年 Demons. All rights reserved.
//

import UIKit
import TextFieldEffects

class LoginViewController: UIViewController {
    
    let usernameTextField = { () -> HoshiTextField in
        let textField = HoshiTextField()
        textField.placeholderColor = .darkGray
        textField.font = usernameInputFont
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    var keyboardIsShown = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(LoginViewController.keyboardWillShow(notification:)),
            name: NSNotification.Name.UIKeyboardWillShow, object: view.window)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(LoginViewController.keyboardWillHide(notification:)),
            name: NSNotification.Name.UIKeyboardWillHide, object: view.window)
        
        view.addSubview(usernameTextField)
        usernameTextField.snp.makeConstraints {
            (make) -> Void in
            make.left.bottom.right.equalTo(view)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
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

extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        
        let nextTag = textField.tag + 1
        let nextResponder = textField.superview?.viewWithTag(nextTag)
        
        if (nextResponder != nil ) {
            nextResponder?.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
    }
    
}

extension LoginViewController: UIScrollViewDelegate {
    
}

// keyboard
extension LoginViewController {
    
    func keyboardWillShow(notification: Notification) {
        if (keyboardIsShown) {
            return
        }
        if let keyboardSize = notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? CGRect {
            usernameTextField.snp.remakeConstraints {
                (make) -> Void in
                make.left.right.equalTo(view)
                make.top.equalTo(view.frame.height -
                    keyboardSize.height - usernameTextField.frame.size.height - CGFloat(50)
                )
            }
        }
        keyboardIsShown = true
    }
    
    func keyboardWillHide(notification: Notification) {
    }
    
}
