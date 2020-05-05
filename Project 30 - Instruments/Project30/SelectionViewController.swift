//
//  SelectionViewController.swift
//  Project30
//
//  Created by TwoStraws on 20/08/2016.
//  Copyright (c) 2016 TwoStraws. All rights reserved.
//

import UIKit

class SelectionViewController: UITableViewController {
	var items = [String]() // this is the array that will store the filenames to load
    var images = [UIImage]() // 3
	var dirty = false

    override func viewDidLoad() {
        super.viewDidLoad()

		title = "Reactionist"

		tableView.rowHeight = 90
		tableView.separatorStyle = .none
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")

		// load all the JPEGs into our array
		let fm = FileManager.default

		if let tempItems = try? fm.contentsOfDirectory(atPath: Bundle.main.resourcePath!) {
			for item in tempItems {
				if item.range(of: "Large") != nil {
					items.append(item)
                    
                    // 3
                    let imageRootName = item.replacingOccurrences(of: "Large", with: "Thumb")
                    guard let path = Bundle.main.path(forResource: imageRootName, ofType: nil) else {
                        print("The resource was not found")
                        return
                    }
                    let original = UIImage(contentsOfFile: path)!
                    
                    let renderRect = CGRect(origin: .zero, size: CGSize(width: 90, height: 90))
                    let renderer = UIGraphicsImageRenderer(size: renderRect.size)

                    let rounded = renderer.image { ctx in
                        ctx.cgContext.addEllipse(in: renderRect)
                        ctx.cgContext.clip()

                        original.draw(in: renderRect)
                    }
                    
                    images.append(rounded)
				}
			}
		}
    }

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		if dirty {
			// we've been marked as needing a counter reload, so reload the whole table
			tableView.reloadData()
		}
	}

    // MARK: - Table view data source

	override func numberOfSections(in tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return items.count * 10
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

		// find the image for this cell, and load its thumbnail
        // 3
        cell.imageView?.image = images[indexPath.row % items.count]

		// give the images a nice shadow to make them look a bit more dramatic
        let renderRect = CGRect(origin: .zero, size: CGSize(width: 90, height: 90))
        
		cell.imageView?.layer.shadowColor = UIColor.black.cgColor
		cell.imageView?.layer.shadowOpacity = 1
		cell.imageView?.layer.shadowRadius = 10
		cell.imageView?.layer.shadowOffset = CGSize.zero
        cell.imageView?.layer.shadowPath = UIBezierPath(ovalIn: renderRect).cgPath

		// each image stores how often it's been tapped
        let currentImage = items[indexPath.row % items.count]
		let defaults = UserDefaults.standard
        
		cell.textLabel?.text = "\(defaults.integer(forKey: currentImage))"

		return cell
    }

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let vc = ImageViewController()
		vc.image = items[indexPath.row % items.count]
		vc.owner = self

		// mark us as not needing a counter reload when we return
		dirty = false

		navigationController!.pushViewController(vc, animated: true)
	}
}
