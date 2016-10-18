//
//  ViewController.swift
//  AdvancedAnimation
//
//  Created by Kiran Kunigiri on 10/11/16.
//  Copyright © 2016 Kiran. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var uploaderView: SVUploader!
    var percent = 0
    var timer: Timer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let uploaderFrame = CGRect(x: 0, y: 0, width: 100, height: 100)
        uploaderView = SVUploader(frame: uploaderFrame)
//        uploaderView = SVUploader(lineColor: UIColor.blue, lineWidth: 15, useBlur: true, useShadow: false)
        uploaderView.frame = uploaderFrame
        uploaderView.frame.size = CGSize(width: 200, height: 200)
        uploaderView.center = self.view.center
        self.view.addSubview(uploaderView)
        
        uploaderView.image = UIImage(named: "profile")
    }

    @IBAction func uploadButtonPressed(_ sender: UIButton) {
        uploaderView.startUpload()
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(time), userInfo: nil, repeats: true)
    }
    
    func time() {
        self.uploaderView.progress += 0.003
        if self.uploaderView.progress == 1 {
            self.timer.invalidate()
            self.uploaderView.endUpload(success: true, message: "Success!")
        }
    }

}
