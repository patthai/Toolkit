//
//  ViewController.swift
//  Text2Voice
//
//  Created by pat pataranutaporn on 11/24/18.
//  Copyright © 2018 pat pataranutaporn. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var textToSpeech: UIButton!
    
    let synth = AVSpeechSynthesizer()
    var myUtterance = AVSpeechUtterance(string: "")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        let speechVoices = AVSpeechSynthesisVoice.speechVoices()
        for voice in speechVoices{
            print("\(voice.identifier) \(voice.name) \(voice.quality) \(voice.language)")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func textToSpeech(_ sender: Any) {
        myUtterance = AVSpeechUtterance(string: textView.text)
        myUtterance.rate = 0.3
        myUtterance.pitchMultiplier = 2.0
        myUtterance.voice = AVSpeechSynthesisVoice(identifier: "com.apple.ttsbundle.Sin-Ji-compact")
        synth.speak(myUtterance)
    }
    

}

