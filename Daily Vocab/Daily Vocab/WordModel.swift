//
//  WordModel.swift
//  Daily Vocab
//
//  Created by Gursewak Sandhu on 2025-01-06.
//

import Foundation

struct Word: Decodable {
    let word: String
    let definitions: String
    let synonyms: String
    let audio: String?

    enum CodingKeys: String, CodingKey {
        case word
        case definitions
        case synonyms
        case audio
    }
}
