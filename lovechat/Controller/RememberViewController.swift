//
//  RememberViewController.swift
//  lovechat
//
//  Created by Demons on 2017/6/14.
//  Copyright © 2017年 Demons. All rights reserved.
//

import UIKit

class RememberViewController: UIViewController {
    
    var remembers: [RememberModel] = [RememberModel(), RememberModel()]
    let cellSpacingHeight: CGFloat = 5
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
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
    
    // number of rows in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.remembers.count
    }
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \(indexPath.row).")
        //        print(self.remembers[indexPath.row].untilDays);
        //        print(self.remembers[indexPath.row].afterDays);
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
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return cellSpacingHeight
    }
    
    @IBAction func unwindToRemeberViewController(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? RememberDetailViewController {
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                let rememberModel = sourceViewController.rememberModel!
                remembers[selectedIndexPath.row] = rememberModel
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            }
            else {
                let rememberModel = sourceViewController.rememberModel!
                let newIndexPath = IndexPath(row: remembers.count, section: 0)
                remembers.append(rememberModel)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
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
        
        return cell
    }
}
