//
//  ViewController.swift
//  AOAlertController-Example
//
//  Created by Олег Адамов on 08.04.16.
//  Copyright © 2016 Oleg Adamov. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0:
                self.withoutActions()
            case 1:
                self.showDefault()
            default:
                break
            }
        }
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    
    func withoutActions() {
        let alert = AOAlertController(title: "No actions", message: "Tap around the alert", style: .Alert)
        self.navigationController?.presentViewController(alert, animated: false, completion: nil)
    }
    
    
    func showDefault() {
        let alert = AOAlertController(title: "Title", message: "Message", style: .Alert)
        let action1 = AOAlertAction(title: "One") {
            print("! action 1 pressed")
        }
        let action2 = AOAlertAction(title: "Two") {
            print("! action 2 pressed")
        }
        let action3 = AOAlertAction(title: "Two") {
            print("! action 3 pressed")
        }
        alert.addAction(action1)
        alert.addAction(action2)
        alert.addAction(action3)
        self.navigationController?.presentViewController(alert, animated: false, completion: nil)
    }
    
}

