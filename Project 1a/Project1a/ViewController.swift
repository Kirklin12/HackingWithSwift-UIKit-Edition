//
//  ViewController.swift
//  Project1a
//
//  Created by Mike on 2019-02-13.
//  Copyright © 2019 Mike. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    var pictures = [Picture]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Storm Viewer"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        performSelector(inBackground: #selector(fetchPictures), with: nil)
        
        let defaults = UserDefaults.standard
        //defaults.removeObject(forKey: "pictures")
        
        if let savedData = defaults.object(forKey: "pictures") as? Data {
            let jsonDecoder = JSONDecoder()

            do {
                pictures = try jsonDecoder.decode([Picture].self, from: savedData)
            } catch {
                print("Failed to load count data.")
            }
        }
    }
    
    @objc func fetchPictures() {
        let fm = FileManager.default
        let path = Bundle.main.resourcePath! // "tell me where I can find all those images I added to my app."
        let items = try! fm.contentsOfDirectory(atPath: path)
        
        for item in items {
            if item.hasPrefix("nssl") {
                var flag = false
                for picture in pictures {
                    if item == picture.name {
                        flag = true
                        break
                    }
                }
                if !flag {
                    let picture = Picture(name: item, views: 0)
                    pictures.append(picture)
                }
            }
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pictures.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Picture", for: indexPath)
        cell.textLabel?.text = pictures[indexPath.row].name + " (views: \(pictures[indexPath.row].views))"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            vc.selectedImage = pictures[indexPath.row].name
            vc.selectedPictureNumber = indexPath.row
            vc.totalPictures = pictures.count
            navigationController?.pushViewController(vc, animated: true)
        }
        
        pictures[indexPath.row].views += 1
        save()
        
        tableView.reloadData()
    }
    
    func save() {
        let jsonEncoder = JSONEncoder()

        if let saveData = try? jsonEncoder.encode(pictures) {
            let defaults = UserDefaults.standard
            defaults.set(saveData, forKey: "pictures")
        } else {
            print("Failed to save data.")
        }
    }
}
