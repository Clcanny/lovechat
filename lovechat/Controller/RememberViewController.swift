//
//  RememberViewController.swift
//  lovechat
//
//  Created by Demons on 2017/6/14.
//  Copyright © 2017年 Demons. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class RememberViewController: UIViewController {
    
    var remembers: [RememberModel] = []
    var database = Database.database().reference()
    var companionId: String?
    let uid = Auth.auth().currentUser!.uid
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // no lines where there aren't cells
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.backgroundColor = .clear
        tableView.separatorEffect = .none
        tableView.separatorColor = .clear
        
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = backgroundImageView.bounds
        backgroundImageView.addSubview(blurView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        
        observeDataChange()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier! {
        case "segueToAddRemberItem":
            break
        case "segueToRememberDetailView":
            guard let rememberDetailViewController = segue.destination
                as? RememberDetailViewController else {
                    fatalError()
            }
            guard let selectedRememberCell = sender as? RememberTableViewCell else {
                fatalError()
            }
            guard let indexPath = tableView.indexPath(for: selectedRememberCell) else {
                fatalError()
            }
            let selectedRemember = remembers[indexPath.row]
            rememberDetailViewController.rememberModel = selectedRemember
        default:
            fatalError()
        }
    }
    
}

extension RememberViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    // number of rows in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.remembers.count
    }
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    func tableView(
        _ tableView: UITableView,
        editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        // action one
        let untilAfterAction = UITableViewRowAction(style: .default, title: "Until\nAfter", handler: { (action, indexPath) in
            self.remembers[indexPath.row].showAfterDays = !self.remembers[indexPath.row].showAfterDays
            tableView.reloadRows(at: [indexPath], with: .automatic)
        })
        
        // action two
        let deleteAction = UITableViewRowAction(style: .default, title: "Del", handler: { (action, indexPath) in
            self.remembers.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        })
        deleteAction.backgroundColor = UIColor.red
        
        return [untilAfterAction, deleteAction]
    }
    
    @IBAction func unwindToRemeberViewController(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? RememberDetailViewController {
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                let rememberModel = sourceViewController.rememberModel!
                updateRememberModel(rememberModel)
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            }
            else {
                let rememberModel = sourceViewController.rememberModel!
                pushRememberModel(rememberModel)
            }
        }
    }
    
}

extension RememberViewController: UITableViewDataSource {
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // create a new cell if needed or reuse an old one
        let cell: RememberTableViewCell = tableView.dequeueReusableCell(
            withIdentifier: "RememberTableViewCell") as! RememberTableViewCell
        
        // set the text from the data model
        cell.titleLabel.text = remembers[indexPath.row].title
        cell.beginDayLabel.text = remembers[indexPath.row].formatDateString
        cell.untilAfterDaysLabel.text = remembers[indexPath.row].dayDiff
        cell.untilAfterDaysLabel.sizeToFit()
        
        cell.backgroundColor = UIColor.clear
        cell.contentView.backgroundColor = UIColor(white: 1, alpha: 0.3)
        
        return cell
    }
    
}

extension RememberViewController {
    
    func observeDataChange() {
        database.child("users/\(uid)/remembers").observe(
            DataEventType.childAdded, with: { (snapshot) -> Void in
                if let value = snapshot.value as? NSDictionary {
                    let model = RememberModel(
                        title: value.object(forKey: "title") as! String,
                        year: value.object(forKey: "year") as! Int,
                        month: value.object(forKey: "month") as! Int,
                        day: value.object(forKey: "day") as! Int
                    )
                    model.key = (value.object(forKey: "key") as! String)
                    self.remembers.append(model)
                    self.tableView.reloadData()
                }
        })
    }
    
    func loadCompanionId(completion: @escaping () -> ()) {
        if companionId == nil {
            database.child("users/\(uid)/companionId").observeSingleEvent(
                of: DataEventType.value, with: { (snapshot) -> Void in
                    let value = snapshot.value
                    let companionId = value as! String
                    self.companionId = companionId
                    completion()
            })
        }
        else {
            completion()
        }
    }
    
    func updateRememberModel(_ rememberModel: RememberModel) {
        loadCompanionId {
            let key = rememberModel.key!
            let msg = [
                "key": key,
                "title" : rememberModel.title,
                "year": rememberModel.getYear(),
                "month": rememberModel.getMonth(),
                "day": rememberModel.getDay()
                ] as [String : Any]
            let childUpdates = [
                "users/\(self.uid)/remembers/\(key)": msg,
                "users/\(self.companionId!)/remembers/\(key)": msg
            ]
            self.database.updateChildValues(childUpdates)
        }
    }
    
    func pushRememberModel(_ rememberModel: RememberModel) {
        loadCompanionId {
            let key = self.database.child("users/\(self.uid)/remembers").childByAutoId().key
            let msg = [
                "key": key,
                "title" : rememberModel.title,
                "year": rememberModel.getYear(),
                "month": rememberModel.getMonth(),
                "day": rememberModel.getDay()
                ] as [String : Any]
            let childUpdates = [
                "users/\(self.uid)/remembers/\(key)": msg,
                "users/\(self.companionId!)/remembers/\(key)": msg
            ]
            self.database.updateChildValues(childUpdates)
        }
    }
    
}
