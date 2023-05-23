//
//  MusicController.swift
//  tower-bloxx
//
//  Created by Kezia Gloria on 23/05/23.
//

import SwiftUI
import AVFoundation

class MusicController: ObservableObject{
    @Published var audioPlayer: AVAudioPlayer?
    func playMusic() {
        guard let url = Bundle.main.url(forResource: "bgm", withExtension: "mp3") else { return }
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.numberOfLoops = -1
            audioPlayer?.play()
            audioPlayer?.setVolume(0.3, fadeDuration: 0.5)
            
        } catch let error {
            print(error.localizedDescription)
        }
    }
}
