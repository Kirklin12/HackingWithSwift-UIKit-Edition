//
//  ViewController.swift
//  Project10
//
//  Created by Mike on 2019-04-21.
//  Copyright © 2019 Mike. All rights reserved.
//

import LocalAuthentication
import UIKit

class ViewController: UICollectionViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var people = [Person]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewPerson))
        
        // 28.3
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(lock), name: UIApplication.willResignActiveNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(authenticate), name: UIApplication.didBecomeActiveNotification, object: nil)
        
        let defaultPerson = Person(name: "John Smith", image: "empty")
        people.append(defaultPerson)
        
        KeychainWrapper.standard.set("password123", forKey: "Password")
        lock()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return people.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Person", for: indexPath) as? PersonCell else {
            fatalError("Unable to dequeue PersonCell.")
        }
        
        let person = people[indexPath.item]
        
        cell.name.text = person.name
        cell.name.textColor = .black
        
        let path = getDocumentsDirectory().appendingPathComponent(person.image)
        cell.imageView.image = UIImage(contentsOfFile: path.path)
        
        cell.imageView.layer.borderColor = UIColor(white: 0, alpha: 0.3).cgColor
        cell.imageView.layer.borderWidth = 2
        cell.imageView.layer.cornerRadius = 3
        cell.layer.cornerRadius = 7
        
        return cell
    }
    
    @objc func addNewPerson() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            let ac = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Library", style: .default) { _ in
                picker.sourceType = .photoLibrary
                self.present(picker, animated: true)
            })
            ac.addAction(UIAlertAction(title: "Camera", style: .default) { _ in
                picker.sourceType = .camera
                self.present(picker, animated: true)
            })
            
            present(ac, animated: true)
        } else {
            present(picker, animated: true)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        let imageName = UUID().uuidString
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)
        if let jpegData = image.jpegData(compressionQuality: 0.8) {
            try? jpegData.write(to: imagePath)
        }
        
        let person = Person(name: "Unknown", image: imageName)
        people.append(person)
        collectionView.reloadData()
        
        dismiss(animated: true)
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let person = people[indexPath.item]
        
        let acRename = UIAlertController(title: "Rename a person", message: nil, preferredStyle: .alert)
        acRename.addTextField()
        acRename.addAction(UIAlertAction(title: "OK", style: .default) { [weak self, weak acRename] _ in
            guard let newName = acRename?.textFields?[0].text else { return }
            person.name = newName
            self?.collectionView.reloadData()
        })
        acRename.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        let acRemove = UIAlertController(title: "Remove \(person.name)?", message: nil, preferredStyle: .alert)
        acRemove.addAction(UIAlertAction(title: "Remove", style: .default) {_ in
            self.people.remove(at: indexPath.item)
            self.collectionView.reloadData()
        })
        acRemove.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        let ac = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Rename", style: .default) { _ in
            self.present(acRename, animated: true)
        })
        ac.addAction(UIAlertAction(title: "Remove", style: .default) { _ in
            self.present(acRemove, animated: true)
        })
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(ac, animated: true)
    }
    
    // 28.3
    @objc func authenticate(_ sender: Any) {
        guard collectionView.isHidden == true else { return }
        let context = LAContext()
        var error: NSError?
        
        if context .canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Identify yourself!"
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { [weak self] success, authenticationError in
                DispatchQueue.main.async {
                    if success {
                        self?.unlock()
                    } else {
                        let ac = UIAlertController(title: "Authentication failed", message: "You could not be verified; please try again.", preferredStyle: .alert)
                        ac.addAction(UIAlertAction(title: "OK", style: .default))
                        self?.present(ac, animated: true)
                    }
                }
            }
        } else {
            let ac = UIAlertController(title: "Biometry unavailable", message: "Your device is not configured for biometric authentication. Please, use password instead.", preferredStyle: .alert)
            ac.addTextField(configurationHandler: {(textField: UITextField!) -> Void in
                textField.isSecureTextEntry = true
            })
            
            let unlockAction = UIAlertAction(title: "Unlock", style: .default) {
                [weak self, weak ac] action in
                guard let password = ac?.textFields?[0].text else { return }
                self?.submitPassword(password)
            }
            
            ac.addAction(unlockAction)
            present(ac, animated: true)
        }
    }
    
    func submitPassword(_ password: String) {
        if password == KeychainWrapper.standard.string(forKey: "Password") {
            unlock()
        } else {
            let ac = UIAlertController(title: "Authentication failed", message: "Password incorrect; please try again.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Retry", style: .default, handler: authenticate))
            present(ac, animated: true)
        }
    }
    
    @objc func lock() {
        collectionView.isHidden = true
    }
    
    func unlock() {
        collectionView.isHidden = false
    }
}
