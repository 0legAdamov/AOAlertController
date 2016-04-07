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
                self.showDefault()
            default:
                break
            }
        }
    }
    
    
    func showDefault() {
        let alert = AOAlertController()
        alert.presentOn(self)
    }
    
}

