//
//  ViewController.swift
//  Voice2Text
//
//  Created by pat pataranutaporn on 11/24/18.
//  Copyright © 2018 pat pataranutaporn. All rights reserved.
//

import UIKit
import Speech

class ViewController: UIViewController, SFSpeechRecognizerDelegate {
    
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var detectedTextLabel: UITextField!
    
    
    let audioEngine = AVAudioEngine()
    let speechRecognizer: SFSpeechRecognizer? = SFSpeechRecognizer()
    let request = SFSpeechAudioBufferRecognitionRequest()
    var recognitionTask: SFSpeechRecognitionTask?
    var isRecording = false
    var silence_duration = 2.0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func stopRecording()
    {
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
        recognitionTask?.cancel()
        isRecording = false
        startButton.backgroundColor = UIColor.gray
    }
    
    func recordAndRecognizeSpeech() {
        let node = audioEngine.inputNode
        let recordingFormat = node.outputFormat(forBus: 0)
        node.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
            self.request.append(buffer)
        }
        
        audioEngine.prepare()
        do{
            try audioEngine.start()
        } catch{
            return print(error)
        }
        
        guard let myRecognizer = SFSpeechRecognizer() else {return}
        if !myRecognizer.isAvailable {
            return
        }
        var silence_timer = Timer.scheduledTimer(withTimeInterval: self.silence_duration, repeats: false) { timer in
            self.stopRecording()
            
        }
            
        
        recognitionTask = speechRecognizer?.recognitionTask(with: request, resultHandler: { result, error in
            if let result = result{
                let bestString = result.bestTranscription.formattedString
                self.detectedTextLabel.text = bestString
                
                silence_timer.invalidate()
                silence_timer = Timer.scheduledTimer(withTimeInterval: self.silence_duration, repeats: false) { timer in
                    self.stopRecording()}
                
            } else if let error = error {
                print(error)
            }
            
        })
        
    }
    

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func tapping(_ sender: Any) {
        if isRecording == true {
            stopRecording()
        } else {
            self.recordAndRecognizeSpeech()
            isRecording = true
            startButton.backgroundColor = UIColor.red
        }
    }
    
    
    
    
}
