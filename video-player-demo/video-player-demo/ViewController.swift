//
//  ViewController.swift
//  video-player-demo
//
//  Created by pat pataranutaporn on 10/5/19.
//  Copyright © 2019 pat pataranutaporn. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class ViewController: UIViewController {    var player: AVPlayer?
    @IBOutlet weak var videoView: UIView!
    
    override func viewDidLoad() {
        
        playBackgoundVideo(video_name: "t-rex")
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
    
    private func playBackgoundVideo(video_name: String) {
        if let filePath = Bundle.main.path(forResource: video_name, ofType:"mov") {
            let filePathUrl = NSURL.fileURL(withPath: filePath)
            player = AVPlayer(url: filePathUrl)
            let playerLayer = AVPlayerLayer(player: player)
            playerLayer.frame = self.videoView.bounds
            
            playerLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill

            NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: self.player?.currentItem, queue: nil, using:loopVideo)
            
            print("video start")
            self.videoView.layer.addSublayer(playerLayer)
            player?.play()
          
            
        }
    }
    
    func videoEnd(notification: Notification) {
        print("video end")
    }
    
    func loopVideo(notification: Notification) {
        player?.seek(to: CMTime.zero)
        player?.play()
       }
    

}

