//
//  SoundPlayer.swift
//  BTrivia
//
//  Created by Isabela Karen Louli on 19.07.22.
//

import Foundation
import AVFoundation
import UIKit

protocol SoundPlayerDelegate: AnyObject {
    func audioPlayerDidFinishPlaying()
}

final class SoundPlayer: UIViewController, AVAudioPlayerDelegate {
    
    weak var delegate: SoundPlayerDelegate?
    var player: AVAudioPlayer?
    
    func playSound(songName: String) {
        guard let url = Bundle.main.url(forResource: songName, withExtension: "mp3") else { return }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)

            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            
            guard let player = player else { return }
            
            self.player?.delegate = self
            player.play()

        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        self.player?.stop()
        self.player = nil
        delegate?.audioPlayerDidFinishPlaying()
    }
}
