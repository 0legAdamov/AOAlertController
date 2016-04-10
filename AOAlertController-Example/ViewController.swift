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
                self.showWithOneAction()
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
    
    
    func showWithOneAction() {
        let alert = AOAlertController(title: "Title", message: "Message", style: .Alert)
        let action = AOAlertAction(title: "Done") {
            print("! action 1 pressed")
        }
        alert.addAction(action)
        self.navigationController?.presentViewController(alert, animated: false, completion: nil)
    }
    
}

