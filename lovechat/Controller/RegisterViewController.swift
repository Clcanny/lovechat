//
//  RegisterViewController.swift
//  lovechat
//
//  Created by Demons on 2017/6/13.
//  Copyright © 2017年 Demons. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class RegisterViewController: UIViewController {
    
    var isFieldEditing: Bool = false
    
    let database = Database.database().reference()
    
    @IBOutlet weak var NameTextField: AnimatableTextField!
    @IBOutlet weak var EmailTextField: AnimatableTextField!
    @IBOutlet weak var PasswordTextField: AnimatableTextField!
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBOutlet weak var registerComplete: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        NameTextField.delegate = self
        EmailTextField.delegate = self
        PasswordTextField.delegate = self
        
        NotificationCenter.default.addObserver(
            self, selector: #selector(RegisterViewController.keyboardWillShow(notification:)),
            name: Notification.Name.UIKeyboardWillShow,
            object: view.window
        )
        NotificationCenter.default.addObserver(
            self, selector: #selector(RegisterViewController.keyboardWillHide(notification:)),
            name: Notification.Name.UIKeyboardWillHide,
            object: view.window
        )
        
        NameTextField.text = userA.companionEmail
        EmailTextField.text = userA.userEmail
        PasswordTextField.text = userA.password
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "segueToLoginViewController" {
        }
        else {
            fatalError()
        }
    }
    
}

extension RegisterViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        
        let nextTag = textField.tag + 1
        let nextResponder = textField.superview?.viewWithTag(nextTag)
        
        if (nextResponder != nil ) {
            nextResponder?.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
            register()
        }
        
        return true
    }
    
    // textFieldDidBeginEditing -> keyboardWillShow -> keyBoardWillHide -> textFieldDidEndEditing
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.tag == 2 {
            isFieldEditing = true
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.tag == 2 {
            isFieldEditing = false
        }
    }
    
}

// keyboard
extension RegisterViewController {
    
    @objc func keyboardWillShow(notification: Notification) {
        if isFieldEditing {
            return
        }
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            view.bounds.origin.y = keyboardSize.height
        }
        else {
            fatalError()
        }
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        if isFieldEditing {
            view.bounds.origin.y = 0
        }
    }
    
}

extension RegisterViewController {
    
    func register() {
        if let email = EmailTextField.text, let pwd = PasswordTextField.text {
            view.isUserInteractionEnabled = false
            registerComplete.startAnimating()
            Auth.auth().createUser(withEmail: email, password: pwd, completion: {
                (user: AuthDataResult?, error) in
                if let err = error {
                    self.present(UIAlertController.defaultErrorController(
                        title: "Register failed",
                        error: err.localizedDescription,
                        completion: {
                            self.view.isUserInteractionEnabled = true
                            self.registerComplete.stopAnimating()
                    }), animated: true)
                }
                else {
                    self.addUserInfo()
                }
            })
        }
    }
    
    func addUserInfo() {
        let email = EmailTextField.text!.replacingOccurrences(of: ".", with: "-")
        let uid = Auth.auth().currentUser!.uid
        let childUpdates = [
            "email2uid/\(email)/": uid,
            "uid2email/\(uid)": email,
            "users/\(uid)/companionId": NameTextField.text!.replacingOccurrences(of: ".", with: "-"),
            "users/\(uid)/confirm": false
            ] as [String : Any]
        
        database.updateChildValues(childUpdates, withCompletionBlock: {
            (error, reference) -> Void in
            if let err = error {
                print(err)
            }
            self.registerComplete.stopAnimating()
            self.performSegue(withIdentifier: "segueToLoginViewController", sender: nil)
        })
    }
    
}
