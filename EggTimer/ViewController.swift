//
//  ViewController.swift
//  EggTimer
//
//  Created by Angela Yu on 08/07/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//
import AVFoundation
import UIKit

class ViewController: UIViewController {
    let eggTimes:[String: Int] = ["Soft": 300, "Medium": 420, "Hard": 720]
    var timer = Timer()
    var secondsRemaining = 60
    var total = 60
    var player: AVAudioPlayer?
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBAction func hardnessSelected(_ sender: UIButton) {
        let hardness = sender.currentTitle
        if hardness != nil{
            timer.invalidate()
            titleLabel.text = hardness!
            total = eggTimes[hardness!]!
            secondsRemaining = eggTimes[hardness!]!
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        }
        
    }
    @objc func updateTimer(){
        if secondsRemaining > 0 {
            print("\(secondsRemaining) seconds.")
            progressBar.progress = Float(total - secondsRemaining)/Float(total)
            secondsRemaining -= 1
        }else{
            timer.invalidate()
            titleLabel.text = "Done!"
            alarm()
            progressBar.progress = 1.0
        }
    }
    func alarm(){
        guard let url = Bundle.main.url(forResource: "alarm_sound", withExtension: "mp3") else { return }

        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)

            /* The following line is required for the player to work on iOS 11. Change the file type accordingly*/
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)

            /* iOS 10 and earlier require the following line:
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileTypeMPEGLayer3) */

            guard let player = player else { return }

            player.play()

        } catch let error {
            print(error.localizedDescription)
        }
    }
    
}
