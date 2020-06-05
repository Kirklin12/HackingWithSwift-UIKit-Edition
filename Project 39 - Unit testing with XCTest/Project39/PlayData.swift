//
//  PlayData.swift
//  Project39
//
//  Created by Mike on 2020-06-04.
//  Copyright © 2020 Mike. All rights reserved.
//

import Foundation

class PlayData {
    var allWords = [String]()
    var wordCounts = [String: Int]()
    
    init() {
        if let path = Bundle.main.path(forResource: "plays", ofType: "txt") {
            if let plays = try? String(contentsOfFile: path) {
                allWords = plays.components(separatedBy: CharacterSet.alphanumerics.inverted)
                allWords = allWords.filter { $0 != "" }
                
                for word in allWords {
                    wordCounts[word, default: 0] += 1
                }
                
                allWords = Array(wordCounts.keys)
            }
        }
    }
}
