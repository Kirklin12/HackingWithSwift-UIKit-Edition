//
//  ViewController.swift
//  Project32
//
//  Created by Mike on 2020-05-07.
//  Copyright © 2020 Mike. All rights reserved.
//

import CoreSpotlight
import MobileCoreServices
import SafariServices
import UIKit

class ViewController: UITableViewController {
    var projects = [Project]()
    var favorites = [Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        projects.append(Project(name: "Project 1: Storm Viewer", desc: "Constants and variables, UITableView, UIImageView, FileManager, storyboards"))
        projects.append(Project(name: "Project 2: Guess the Flag", desc: "Asset catalogs, UIButton, CALayer, UIColor, UIAlertController"))
        projects.append(Project(name: "Project 3: Social Media", desc: "UIBarButtonItem, UIActivityViewController, URL"))
        projects.append(Project(name: "Project 4: Easy Browser", desc: "loadView(), WKWebView, URLRequest, UIToolbar, UIProgressView, key-value observing"))
        projects.append(Project(name: "Project 5: Word Scramble", desc: "Closures, method return values, booleans, NSRange"))
        projects.append(Project(name: "Project 6: Auto Layout", desc: "NSLayoutConstraint, Visual Format Language, layout anchors"))
        projects.append(Project(name: "Project 7: Whitehouse Petitions", desc: "JSON, Data, UITabBarController"))
        projects.append(Project(name: "Project 8: 7 Swifty Words", desc: "addTarget(), enumerated(), count(), index(of:), joined(), property observers, range operators"))
        
        let defaults = UserDefaults.standard
        if let savedFavorites = defaults.object(forKey: "favorites") as? [Int] {
            favorites = savedFavorites
        }
        
        tableView.isEditing = true
        tableView.allowsSelectionDuringEditing = true
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return projects.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let project = projects[indexPath.row]
        cell.textLabel?.attributedText = makeAttributedString(title: project.name, subtitle: project.desc)
        
        if favorites.contains(indexPath.row) {
            cell.editingAccessoryType = .checkmark
        } else {
            cell.editingAccessoryType = .none
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showTutorial(indexPath.row)
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        if favorites.contains(indexPath.row) {
            return .delete
        } else {
            return .insert
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .insert {
            favorites.append(indexPath.row)
            index(item: indexPath.row)
        } else {
            if let index = favorites.index(of: indexPath.row) {
                favorites.remove(at: index)
                deindex(item: indexPath.row)
            }
        }

        let defaults = UserDefaults.standard
        defaults.set(favorites, forKey: "favorites")

        tableView.reloadRows(at: [indexPath], with: .none)
    }
    
    func index(item: Int) {
        let project = projects[item]
        
        let attributeSet = CSSearchableItemAttributeSet(itemContentType: kUTTypeText as String)
        attributeSet.title = project.name
        attributeSet.contentDescription = project.desc
        
        let item = CSSearchableItem(uniqueIdentifier: "\(item)", domainIdentifier: "com.hackingwithswift", attributeSet: attributeSet)
        item.expirationDate = Date.distantFuture
        
        CSSearchableIndex.default().indexSearchableItems([item]) { error in
            if let error = error {
                print("Indexing error: \(error.localizedDescription)")
            } else {
                print("Search item successfully indexed!")
            }
        }
    }
    
    func deindex(item: Int) {
        CSSearchableIndex.default().deleteSearchableItems(withIdentifiers: ["\(item)"]) { error in
            if let error = error {
                print("Deindexing error: \(error.localizedDescription)")
            } else {
                print("Search item succesfully removed!")
            }
        }
    }
    
    func makeAttributedString(title: String, subtitle: String) -> NSAttributedString {
        let titleAttributes = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .headline), NSAttributedString.Key.foregroundColor: UIColor.purple]
        let subtitleAttributes = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .subheadline)]
        
        let titleString = NSMutableAttributedString(string: "\(title)\n", attributes: titleAttributes)
        let subtitleString = NSAttributedString(string: subtitle, attributes: subtitleAttributes)
        
        titleString.append(subtitleString)
        
        return titleString
    }
    
    func showTutorial(_ which: Int) {
        if let url = URL(string: "https://www.hackingwithswift.com/read/\(which + 1)") {
            let config = SFSafariViewController.Configuration()
            config.entersReaderIfAvailable = true
            
            let vc = SFSafariViewController(url: url, configuration: config)
            present(vc, animated: true)
        }
    }
}
