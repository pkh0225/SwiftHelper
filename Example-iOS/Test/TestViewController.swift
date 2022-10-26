//
//  ViewController.swift
//  Test
//
//  Created by pkh on 2018. 8. 14..
//  Copyright © 2018년 pkh. All rights reserved.
//

import UIKit

class TestViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func assembleModule(identifier: String) -> UIViewController {
        
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: identifier)
        return vc
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(UITableViewCell.self, for: indexPath)
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = "UIView AutoLayout Extensions"
        case 1:
            cell.textLabel?.text = "Closure Queue"
        default:
            break
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            let vc = assembleModule(identifier: AutoLayoutController.className)
            self.navigationController?.pushViewController(vc, animated: true)
            
        case 1:
            let vc = assembleModule(identifier: ClosureQueueController.className)
            self.navigationController?.pushViewController(vc, animated: true)
            
        default:
            break
        }
    }
}

