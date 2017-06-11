//
//  LoginViewController.swift
//  lovechat
//
//  Created by Demons on 2017/6/11.
//  Copyright © 2017年 Demons. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class LoginViewController: UIViewController {
    
    let databse = Database.database().reference()
    
    var isFieldEditing: Bool = false
    
    @IBOutlet weak var registerComplete: UIActivityIndicatorView!
    @IBOutlet weak var userField: AnimatableTextField!
    @IBOutlet weak var passField: AnimatableTextField!
    
    let database = Database.database().reference()
    
    override func viewDidAppear(_ animated: Bool) {
        if Auth.auth().currentUser?.uid != nil {
            print("User already logged in!")
//            self.performSegue(withIdentifier: "toChatViewController", sender: nil)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        userField.text = nil
        passField.text = nil
        registerComplete.isHidden = true
        
        NotificationCenter.default.removeObserver(self)
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        registerComplete.isHidden = true
        userField.delegate = self
        passField.delegate = self
        
        NotificationCenter.default.addObserver(
            self, selector: #selector(LoginViewController.keyboardWillShow(notification:)),
            name: Notification.Name.UIKeyboardWillShow,
            object: view.window
        )
        NotificationCenter.default.addObserver(
            self, selector: #selector(LoginViewController.keyboardWillHide(notification:)),
            name: Notification.Name.UIKeyboardWillHide,
            object: view.window
        )
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func signInPressed(_ sender: UIButton) {
        registerComplete.isHidden = false
        registerComplete.startAnimating()
        view.isUserInteractionEnabled = false
        
        guard let email = userField.text, let pass = passField.text else {
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: pass, completion: {
            (user, error) in
            if error != nil {
                print(error!)
                self.registerComplete.stopAnimating()
                self.registerComplete.isHidden = true
                self.view.isUserInteractionEnabled = true
            }
            else {
                self.database.child("email2uid").observeSingleEvent(of: DataEventType.value, with: { (snapshot) -> Void in
                    var hasFound = false
                    let value = snapshot.value as? NSDictionary
                    let email = user!.email!.replacingOccurrences(of: ".", with: "-")
                    let uid = value?[email] as? String
                    if (uid == user?.uid) {
                        hasFound = true
                        print("We found user's email in database.")
                    }
                    if (!hasFound) {
                        print("We can't find user's email in database.")
                        let email = user!.email!.replacingOccurrences(of: ".", with: "-")
                        self.database.child("email2uid").updateChildValues([email : user!.uid])
                    }
                })
                
                self.database.child("uid2email").observeSingleEvent(of: DataEventType.value, with: { (snapshot) -> Void in
                    let value = snapshot.value as? NSDictionary
                    let uid = user!.uid
                    let email = value?[uid] as? String
                    if (email == user?.email) {
                        print("We found user's id in database.")
                    } else {
                        print("We can't find user's id in database.")
                        self.database.child("uid2email").updateChildValues([user!.uid : user!.email!])
                    }
                })
                
                self.performSegue(withIdentifier: "toChatViewController", sender: nil)
            }
        })
    }
    
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
    
    // textFieldDidBeginEditing -> keyboardWillShow -> keyBoardWillHide -> textFieldDidEndEditing
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.tag == 1 {
            isFieldEditing = true
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.tag == 1 {
            isFieldEditing = false
        }
    }
    
}

// keyboard
extension LoginViewController {
    
    func keyboardWillShow(notification: Notification) {
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
    
    func keyboardWillHide(notification: Notification) {
        if isFieldEditing {
            view.bounds.origin.y = 0
        }
    }
    
}
