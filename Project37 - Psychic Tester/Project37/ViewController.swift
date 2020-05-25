//
//  ViewController.swift
//  Project37
//
//  Created by Mike on 2020-05-25.
//  Copyright © 2020 Mike. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var cardContainer: UIView!
    
    var allCards = [CardViewController]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCards()
    }

    @objc func loadCards() {
        for card in allCards {
            card.view.removeFromSuperview()
            card.removeFromParent()
        }
        
        allCards.removeAll(keepingCapacity: true)
        
        let positions = [
            CGPoint(x: 75, y: 85),
            CGPoint(x: 185, y: 85),
            CGPoint(x: 295, y: 85),
            CGPoint(x: 405, y: 85),
            CGPoint(x: 75, y: 235),
            CGPoint(x: 185, y: 235),
            CGPoint(x: 295, y: 235),
            CGPoint(x: 405, y: 235)
        ]
        
        let circle = UIImage(named: "cardCircle")!
        let cross = UIImage(named: "cardCross")!
        let lines = UIImage(named: "cardLines")!
        let square = UIImage(named: "cardSquare")!
        let star = UIImage(named: "cardStar")!
        
        var images = [circle, circle, cross, cross, lines, lines, square, star]
        images.shuffle()
        
        for (index, position) in positions.enumerated() {
            let card = CardViewController()
            card.delegate = self
            
            // view controller containment
            addChild(card)
            cardContainer.addSubview(card.view)
            card.didMove(toParent: self)
            
            card.view.center = position
            card.front.image = images[index]
            
            // mark star as the correct answer
            if card.front.image == star {
                card.isCorrect = true
            }
            
            allCards.append(card)
        }
    }
}

