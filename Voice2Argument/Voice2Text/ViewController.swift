//
//  ViewController.swift
//  Voice2Text
//
//  Created by pat pataranutaporn on 11/24/18.
//  Copyright © 2018 pat pataranutaporn. All rights reserved.
//

import UIKit
import Speech

struct Global{
    
    static var processed_response = "..."
    static var premise_check = "..."
}

class ViewController: UIViewController, SFSpeechRecognizerDelegate {
    
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var detectedTextLabel: UITextField!
    
    
    let audioEngine = AVAudioEngine()
    let speechRecognizer: SFSpeechRecognizer? = SFSpeechRecognizer()
    let request = SFSpeechAudioBufferRecognitionRequest()
    var recognitionTask: SFSpeechRecognitionTask?
    var isRecording = false
    var silence_duration = 4.0
    
    
    var argument = ""
    var noPremiseAlert = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        analyzeArgument()
        print (Global.processed_response)
        print (Global.premise_check)
    }
    
    func analyzeArgument(){
        //let (analyzedArgument, alert)  = postAction(argument: String)
        postAction(argument: argument) {  //@escaping efforts - function runs but that's it
            (returnString) in             //@escaping efforts - content doesn't run
            print("got back: \(returnString)") //@escaping efforts - content doesn't run
            
        }
        //print("JKkn", analyzedArgument)
        //argument = analyzedArgument
        //noPremiseAlert = alert
        
        //print(argument)
    }
    
    func stopRecording()
    {
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
        recognitionTask?.cancel()
        isRecording = false
        startButton.backgroundColor = UIColor.gray
        
        //initiate analysis
        analyzeArgument()
        
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
                self.argument = bestString
                
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
