//
//  ViewController.swift
//  Project9
//
//  Created by Mike on 2019-04-01.
//  Copyright © 2019 Mike. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    var petitions = [Petition]()
    var filteredPetitions = [Petition]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Credits", style: .plain, target: self, action: #selector(openTappedCredits))
        
        let filter = UIBarButtonItem(title: "Filter", style: .plain, target: self, action: #selector(openTappedFilter))
        let refresh = UIBarButtonItem(title: "Rerfresh", style: .plain, target: self, action: #selector(refreshApp))
  
        navigationItem.leftBarButtonItems = [filter, refresh]
        
        performSelector(inBackground: #selector(fetchJSON), with: nil) // run fetchJSON method in the background
    }
    
    @objc  func fetchJSON() {
        let urlString: String
        
        if navigationController?.tabBarItem.tag == 0 {
            urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
        } else {
            urlString = "https://www.hackingwithswift.com/samples/petitions-2.json"
        }
        
        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url) {
                parse(json: data)
                return
            }
        }
        
        performSelector(onMainThread: #selector(showError), with: nil, waitUntilDone: false)
    }
    
    @objc func showError() {
        let ac = UIAlertController(title: "Loading error", message: "There was a problem loading the feed; please check your connection and try again.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "ok", style: .default))
        present(ac, animated: true)
    }
    
    func parse(json: Data) {
        let decoder = JSONDecoder()
        
        if let jsonPetitions = try? decoder.decode(Petitions.self, from: json) {
            petitions = jsonPetitions.results
            filteredPetitions = petitions
            tableView.performSelector(onMainThread: #selector(UITableView.reloadData), with: nil, waitUntilDone: false)
        } else {
            performSelector(onMainThread: #selector(showError), with: nil, waitUntilDone: false)
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredPetitions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let petition = filteredPetitions[indexPath.row]
        cell.textLabel?.text = petition.title
        cell.detailTextLabel?.text = petition.body
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.detailItem = filteredPetitions[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func openTappedCredits() {
        let ac = UIAlertController(title: "Credits", message: "The data comes from the 'We The People API of the Whitehouse.'", preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "OK", style: .cancel))
        ac.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(ac, animated: true)
    }
    
    @objc func openTappedFilter() {
        let ac = UIAlertController(title: "Filter by word", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) {
            [weak self, weak ac] action in
            guard let keyword = ac?.textFields?[0].text else { return }
            self?.submit(keyword)
            return
        }
        
        ac.addAction(submitAction)
        present(ac, animated: true)
    }
    
    func submit (_ keyword: String) {
        filteredPetitions.removeAll()
        
        for petition in petitions {
            if petition.title.contains(keyword) || petition.body.contains(keyword) {
                filteredPetitions.append(petition)
            }
        }
        tableView.reloadData()
    }
    
     @objc func refreshApp() {
        filteredPetitions = petitions
        tableView.reloadData()
    }
}

