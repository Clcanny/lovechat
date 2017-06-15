//
//  RememberDetailViewController.swift
//  lovechat
//
//  Created by Demons on 2017/6/14.
//  Copyright © 2017年 Demons. All rights reserved.
//

import UIKit
import FSCalendar

class RememberDetailViewController: UIViewController {
    
    var rememberModel: RememberModel?

    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    @IBOutlet weak var calendar: FSCalendar!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            return
        }
        rememberModel = RememberModel()
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        if rememberModel == nil{
            print("dismiss")
            dismiss(animated: true, completion: nil)
        }
        else if let owningNavigationController = navigationController {
            print("navigation")
            owningNavigationController.popViewController(animated: true)
        }
        else {
            fatalError()
        }
    }

}

extension RememberDetailViewController: FSCalendarDelegate {
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let calendar = Calendar.current
        let dateComponent = calendar.dateComponents([.year, .month, .day], from: date)
        print(date)
    }
    
}

extension RememberDetailViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
//        titleTextField.text = textField.text
    }
    
}
