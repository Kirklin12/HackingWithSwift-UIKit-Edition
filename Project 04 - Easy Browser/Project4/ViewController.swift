//
//  ViewController.swift
//  Project4
//
//  Created by Mike on 2019-03-19.
//  Copyright © 2019 Mike. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    var websites = [String]()
    //var websites = ["apple.com", "google.com"]
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Web Browser"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        if let listURL = Bundle.main.url(forResource: "list", withExtension: "txt") {
            if let listItems = try? String(contentsOf: listURL) {
                websites = listItems.components(separatedBy: "\n")
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return websites.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Website", for: indexPath)
        cell.textLabel?.text = websites[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            vc.websites = websites
            vc.currentWebsite = websites[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
