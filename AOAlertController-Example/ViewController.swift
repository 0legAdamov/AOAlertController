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
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                self.withoutActions()
            case 1:
                self.showWithOneAction()
            default:
                break
            }
        case 1:
            test()
        default: break
        }
        
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    
    func test() {
        let alert = UIAlertController(title: "Title", message: "Message", preferredStyle: UIAlertControllerStyle.Alert)
        let action1 = UIAlertAction(title: "Action 1", style: UIAlertActionStyle.Default, handler: nil)
        alert.addAction(action1)
        let action2 = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Destructive, handler: nil)
        alert.addAction(action2)
        let action3 = UIAlertAction(title: "Action 3", style: UIAlertActionStyle.Default, handler: nil)
        alert.addAction(action3)
        self.navigationController?.presentViewController(alert, animated: false, completion: nil)
    }
    
    func withoutActions() {
        let alert = AOAlertController(title: "No actions", message: "Tap around the alert", style: .Alert)
        self.navigationController?.presentViewController(alert, animated: false, completion: nil)
    }
    
    
    func showWithOneAction() {
        let alert = AOAlertController(title: "Title", message: "Message", style: .Alert)
        let action = AOAlertAction(title: "Done", style: .Default) {
            print("! action 1 pressed")
        }
        alert.addAction(action)
        self.navigationController?.presentViewController(alert, animated: false, completion: nil)
    }
    
}

