//
//  TableViewController.swift
//  Extension
//
//  Created by Mike on 2020-04-17.
//  Copyright © 2020 Mike. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    var userScripts = [UserScript]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        title = "User Scripts"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userScripts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = userScripts[indexPath.row].title
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = ActionViewController()
        let switchViewController = self.navigationController?.viewControllers[0] as! ActionViewController
        
        vc.userScriptToShow = userScripts[indexPath.row].text!
        switchViewController.userScriptToShow = userScripts[indexPath.row].text!
        
        self.navigationController?.popToRootViewController(animated: true)
    }
}
