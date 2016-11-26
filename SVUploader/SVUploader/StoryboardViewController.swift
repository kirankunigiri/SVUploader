//
//  StoryboardViewController.swift
//  SVUploader
//
//  Created by Kiran Kunigiri on 11/26/16.
//  Copyright © 2016 Kiran. All rights reserved.
//

import UIKit


/**
 STORYBOARD EXAMPLE
 
 This class is an example that shows how to create an SVUploader view from Storyboard.
 Check out the storyboard to see how it works. All you have to do is drag in a UIView and change its class to SVUploader.
 */

class StoryboardViewController: UIViewController {
    
    @IBOutlet weak var uploaderView: SVUploader!
    var percent = 0
    var timer: Timer!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Set the image
        uploaderView.image = UIImage(named: "galaxy")
    }
    
    @IBAction func uploadButtonPressed(_ sender: UIButton) {
        uploaderView.startUpload()
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(time), userInfo: nil, repeats: true)
    }
    
    // Updates the progress bar of the uploader view. In reality you would want to connect this to your backend and update it.
    func time() {
        self.uploaderView.progress += 0.003
        if self.uploaderView.progress == 1 {
            self.timer.invalidate()
            self.uploaderView.endUpload(success: true)
        }
    }
}
