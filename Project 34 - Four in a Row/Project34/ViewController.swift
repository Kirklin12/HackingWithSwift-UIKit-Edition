//
//  ViewController.swift
//  Project34
//
//  Created by Mike on 2020-05-14.
//  Copyright © 2020 Mike. All rights reserved.
//

import GameplayKit
import UIKit

enum ChipColor: Int {
    case none = 0
    case red
    case black
}

class ViewController: UIViewController {
    @IBOutlet var columnButtons: [UIButton]!
    
    var placedChips = [[UIView]]()
    var board: Board!
    var strategist: GKMinmaxStrategist!
    var isAI = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gameMode = UIBarButtonItem(title: "Game Mode", style: .plain, target: self, action: #selector(gameModeAlert))
        let difficulty = UIBarButtonItem(title: "Difficulty", style: .plain, target: self, action: #selector(difficultyAlert))
        
        navigationItem.rightBarButtonItems = [difficulty, gameMode]
        
        for _ in 0 ..< Board.width {
            placedChips.append([UIView]())
        }
        
        strategist = GKMinmaxStrategist()
        strategist.maxLookAheadDepth = 5
        strategist.randomSource = nil
  
        resetBoard()
    }
    
    @IBAction func makeMove(_ sender: UIButton) {
        let column = sender.tag
        
        if let row = board.nextEmptySlot(in: column) {
            board.add(chip: board.currentPlayer.chip, in: column)
            addChip(inColumn: column, row: row, color: board.currentPlayer.color)
            continueGame()
        }
    }
    
    func makeAIMove(in column: Int) {
        columnButtons.forEach { $0.isEnabled = true }
        navigationItem.leftBarButtonItem = nil
        
        if let row = board.nextEmptySlot(in: column) {
            board.add(chip: board.currentPlayer.chip, in: column)
            addChip(inColumn: column, row: row, color: board.currentPlayer.color)
            
            continueGame()
        }
    }
    
    // game modes
    @objc func gameModeAlert() {
        let ac = UIAlertController(title: "Game Modes", message: nil, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Player vs AI", style: .default, handler: gameSettings))
        ac.addAction(UIAlertAction(title: "Player vs Player", style: .default, handler: gameSettings))
        present(ac, animated: true)
    }
    
    func gameSettings(action: UIAlertAction) {
        if action.title == "Player vs AI" {
            isAI = true
        }
        
        if action.title == "Player vs Player" {
            isAI = false
        }
        
        if action.title == "Easy" {
            strategist.maxLookAheadDepth = 1
        }
        
        if action.title == "Medium" {
            strategist.maxLookAheadDepth = 5
        }

        if action.title == "Hard" {
            strategist.maxLookAheadDepth = 7
        }
        
        resetBoard()
    }
    
    // difficulty
    @objc func difficultyAlert() {
        let ac = UIAlertController(title: "Difficulty", message: nil, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Easy", style: .default, handler: gameSettings))
        ac.addAction(UIAlertAction(title: "Medium", style: .default, handler: gameSettings))
        ac.addAction(UIAlertAction(title: "Hard", style: .default, handler: gameSettings))
        present(ac, animated: true)
    }
        
    func resetBoard() {
        board = Board()
        strategist.gameModel = board
        
        updateUI()
        
        for i in 0 ..< placedChips.count {
            for chip in placedChips[i] {
                chip.removeFromSuperview()
            }
            
            placedChips[i].removeAll(keepingCapacity: true)
        }
    }
    
    func addChip(inColumn column: Int, row: Int, color: UIColor) {
        let button = columnButtons[column]
        let size = min(button.frame.width, button.frame.height / 6)
        let rect = CGRect(x: 0, y: 0, width: size, height: size)
        
        // custom images
        if (placedChips[column].count < row + 1) {
            let newChip = UIImageView()
            
            newChip.contentMode = .scaleAspectFit
            newChip.frame = rect
            newChip.isUserInteractionEnabled = false
            
            if color == .red {
                newChip.image = UIImage(named: "banana")
            }

            if color == .black {
                newChip.image = UIImage(named: "cherry")
            }

            newChip.center = positionForChip(inColumn: column, row: row)
            newChip.transform = CGAffineTransform(translationX: 0, y: -800)
            view.addSubview(newChip)
            
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn, animations: {
                newChip.transform = CGAffineTransform.identity
            })
            
            placedChips[column].append(newChip)
        }
    }
    
    func positionForChip(inColumn column: Int, row: Int) -> CGPoint {
        let button = columnButtons[column]
        let size = min(button.frame.width, button.frame.height / 6)
        
        let xOffset = button.frame.midX
        var yOffset = button.frame.maxY - size / 2
        yOffset -= size * CGFloat(row)
        return CGPoint(x: xOffset, y: yOffset)
    }
    
    func updateUI() {
        title = "\(board.currentPlayer.name)'s Turn"
        
        if board.currentPlayer.chip == .black && isAI {
            startAImove()
        }
    }
    
    func continueGame() {
        var gameOverTitle: String? = nil
        
        if board.isWin(for: board.currentPlayer) {
            gameOverTitle = "\(board.currentPlayer.name) Wins!"
        } else if board.isFull() {
            gameOverTitle = "Draw!"
        }
        
        if gameOverTitle != nil {
            let alert = UIAlertController(title: gameOverTitle, message: nil, preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "Play Again", style: .default) { [unowned self] (action) in
                self.resetBoard()
            }
            
            alert.addAction(alertAction)
            present(alert, animated: true)
            
            return
        }
        
        board.currentPlayer = board.currentPlayer.opponent
        updateUI()
    }
    
    func columnForAIMove() -> Int? {
        if let aiMove = strategist.bestMove(for: board.currentPlayer) as? Move {
            return aiMove.column
        }
        
        return nil
    }
    
    func startAImove() {
        columnButtons.forEach { $0.isEnabled = false }
        
        let spinner = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
        spinner.startAnimating()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: spinner)
        
        DispatchQueue.global().async { [unowned self] in
            let strategistTime = CFAbsoluteTimeGetCurrent()
            guard let column = self.columnForAIMove() else { return }
            let delta = CFAbsoluteTimeGetCurrent() - strategistTime
            
            let aiTimeCeiling = 1.0
            let delay = aiTimeCeiling - delta
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                self.makeAIMove(in: column)
            }
        }
    }
}
