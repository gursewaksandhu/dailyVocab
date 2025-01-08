//
//  WordViewModel.swift
//  Daily Vocab
//
//  Created by Gursewak Sandhu on 2025-01-06.
//

import Foundation
import AVFoundation

class WordViewModel: ObservableObject {
    @Published var word: Word?
    private var audioPlayer: AVPlayer?
    private let synthesizer = AVSpeechSynthesizer()

    func fetchWord() {
        guard let randomWordURL = URL(string: "https://random-word-api.herokuapp.com/word") else { return }

        URLSession.shared.dataTask(with: randomWordURL) { [weak self] data, response, error in
            guard let self = self, error == nil, let data = data else {
                print("Failed to fetch random word: \(error?.localizedDescription ?? "Unknown error")")
                return
            }

            do {
                let wordArray = try JSONDecoder().decode([String].self, from: data)
                guard let randomWord = wordArray.first else { return }

                self.fetchWordDetails(for: randomWord)
            } catch {
                print("Failed to decode random word: \(error.localizedDescription)")
            }
        }.resume()
    }

    private func fetchWordDetails(for word: String) {
        guard let dictionaryURL = URL(string: "https://api.dictionaryapi.dev/api/v2/entries/en/\(word)") else { return }

        URLSession.shared.dataTask(with: dictionaryURL) { [weak self] data, response, error in
            guard let self = self, error == nil, let data = data else {
                print("Failed to fetch word details: \(error?.localizedDescription ?? "Unknown error")")
                return
            }

            do {
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]]
                guard let firstEntry = json?.first,
                      let word = firstEntry["word"] as? String,
                      let meanings = firstEntry["meanings"] as? [[String: Any]] else {
                    print("Failed to parse word details")
                    return
                }

                let definitions = meanings.compactMap { meaning in
                    (meaning["definitions"] as? [[String: Any]])?.compactMap { $0["definition"] as? String }.joined(separator: "\n")
                }.joined(separator: "\n")

                let synonyms = meanings.compactMap { meaning in
                    (meaning["synonyms"] as? [String])?.joined(separator: ", ")
                }.joined(separator: ", ")

                let audio = (firstEntry["phonetics"] as? [[String: Any]])?.first?["audio"] as? String

                DispatchQueue.main.async {
                    self.word = Word(word: word, definitions: definitions, synonyms: synonyms, audio: audio)
                }
            } catch {
                print("Failed to decode word details: \(error.localizedDescription)")
            }
        }.resume()
    }

    func playAudio() {
        if let urlString = word?.audio, let url = URL(string: urlString) {
            audioPlayer = AVPlayer(url: url)
            audioPlayer?.play()
        } else if let wordToSpeak = word?.word {
            let utterance = AVSpeechUtterance(string: wordToSpeak)
            utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
            synthesizer.speak(utterance)
        }
    }
}
