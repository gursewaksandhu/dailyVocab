//
//  ContentView.swift
//  Daily Vocab
//
//  Created by Gursewak Sandhu on 2025-01-06.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = WordViewModel()

    var body: some View {
        VStack {
            if let word = viewModel.word {
                Text(word.word)
                    .font(.largeTitle)
                    .padding()
                Button(action: {
                    viewModel.playAudio()
                }) {
                    Image(systemName: "speaker.wave.2.fill")
                        .font(.title)
                        .padding()
                }
                TabView {
                    Text(word.definitions)
                        .padding()
                        .tabItem {
                            Label("Definitions", systemImage: "text.book.closed")
                        }
                    Text(word.synonyms)
                        .padding()
                        .tabItem {
                            Label("Synonyms", systemImage: "text.bubble")
                        }
                }
                .tabViewStyle(PageTabViewStyle())
            } else {
                ProgressView("Loading word...")
                    .onAppear {
                        viewModel.fetchWord()
                    }
            }
        }
        .padding()
    }
}
