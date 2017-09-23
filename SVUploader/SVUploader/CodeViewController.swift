//
//  ViewController.swift
//  SVUploader
//
//  Created by Kiran Kunigiri on 10/11/16.
//  Copyright © 2016 Kiran. All rights reserved.
//

import UIKit


/**
 CODE EXAMPLE
 
 This class is an example that shows how to create an SVUploader view from code. 
 It has multiple initializers that you can uncomment and play around with.
 */

class CodeViewController: UIViewController {
    
    var uploaderView: SVUploader!
    var percent = 0
    var timer: Timer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create the frame for the uploader view
        let uploaderFrame = CGRect(x: 0, y: 0, width: 200, height: 200)
        
        // Example of the default initializer setup
        uploaderView = SVUploader(frame: uploaderFrame)
        
        // Example of the common initialzer setup
        // let customLineColor = UIColor(red:0.30, green:0.49, blue:0.95, alpha:1.0)
        // uploaderView = SVUploader(lineColor: customLineColor, lineWidth: 15)
        
        // Example of the detailed initializer setup
        // uploaderView = SVUploader(lineColor: customLineColor, lineWidth: 12, borderColor: UIColor.lightGray, borderWidth: 5)
        
        // Example of the initializer-only variable setup.
        // uploaderView = SVUploader(useBlur: true, useShadow: true, useSmoothAnimation: true)
        
        // Set the frame, center the view, and add it to the superview
        uploaderView.frame = uploaderFrame
        uploaderView.center = self.view.center
        self.view.addSubview(uploaderView)
        
        // Set the image
        uploaderView.image = UIImage(named: "galaxy")
    }

    @IBAction func uploadButtonPressed(_ sender: UIButton) {
        if uploaderView.isAnimating { return }
        
        uploaderView.startUpload()
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(time), userInfo: nil, repeats: true)
    }
    
    // Updates the progress bar of the uploader view. In reality you would want to connect this to your backend and update it.
    @objc func time() {
        self.uploaderView.progress += 0.003
        if self.uploaderView.progress == 1 {
            self.timer.invalidate()
            self.uploaderView.endUpload(success: true)
        }
    }

}
