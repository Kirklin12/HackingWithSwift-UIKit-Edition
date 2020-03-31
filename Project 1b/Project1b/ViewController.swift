//
//  ViewController.swift
//  Project1b
//
//  Created by Mike on 2019-02-13.
//  Copyright © 2019 Mike. All rights reserved.
//

import UIKit

class ViewController: UICollectionViewController {
    var pictures = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Storm Viewer"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let fm = FileManager.default
        let path = Bundle.main.resourcePath! // "tell me where I can find all those images I added to my app."
        let items = try! fm.contentsOfDirectory(atPath: path)
        
        for item in items {
            if item.hasPrefix("nssl") {
                pictures.append(item)
            }
        }
        
        pictures.sort()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        collectionView.reloadData()
        return pictures.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Image", for: indexPath) as? ImageCell else {
            fatalError("Unable to dequeue ImageCell.")
        }

        cell.name.text = pictures[indexPath.item]
        cell.layer.cornerRadius = 7
        
        cell.imageView.image = UIImage(named: pictures[indexPath.item])
        cell.imageView.layer.borderColor = UIColor(white: 0, alpha: 0.3).cgColor
        cell.imageView.layer.borderWidth = 2
        cell.imageView.layer.cornerRadius = 3
        
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            vc.selectedImage = pictures[indexPath.row]
            vc.selectedPictureNumber = indexPath.row
            vc.totalPictures = pictures.count
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
