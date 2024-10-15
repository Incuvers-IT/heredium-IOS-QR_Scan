//
//  PlayViewModel.swift
//  app
//
//  Created by Muune on 2023/03/09.
//

import Foundation
import AVFoundation

class PlayViewModel {
    
    private var audioPlayer: AVAudioPlayer!
    
    func play(fileNamed:String, type: String) {
        let sound = Bundle.main.path(forResource: fileNamed, ofType: type)
        
        audioPlayer?.prepareToPlay() //maybe not needed?  idk

        do {
            audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: sound!))
            audioPlayer?.play()
        } catch {
            print(error)
        }
    }
}
