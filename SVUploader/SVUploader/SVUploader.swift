//
//  SVUploader.swift
//  AdvancedAnimation
//
//  Created by Kiran Kunigiri on 10/16/16.
//  Copyright © 2016 Kiran. All rights reserved.
//

import Foundation
import UIKit

class SVUploader: UIView {
    
    // ==============================================================================================
    // MARK: - Properties
    // ==============================================================================================
    
    
    
    // ==============================================================================================
    // MARK: Views
    // ==============================================================================================
    
    // The container view will hold all views inside the circle
    var containerView = UIView()
    var contentView = UIView()
    var endView = UIView()
    var imageView = UIImageView()
    var overlayView = UIView()
    var loadingLabel = UILabel()
    
    // The circle is separate and is outside the container view
    var circlePathLayer = CAShapeLayer()
    
    /** The image of the uploader. Can be set to nil if an image is not being used. */
    var image: UIImage? {
        didSet {
            if image != nil {
                self.imageView.image = image
                self.imageView.isHidden = false
            } else {
                self.imageView.isHidden = true
            }
        }
    }
    
    
    
    // ==============================================================================================
    // MARK: Variables
    // ==============================================================================================
    
    /** The color of the circular loader */
    var lineColor = UIColor.red {
        didSet { circlePathLayer.strokeColor = lineColor.cgColor }
    }
    
    /** The width of the circular loader */
    var lineWidth: CGFloat = 10 {
        didSet { circlePathLayer.lineWidth = lineWidth }
    }
    
    /** The overlay opacity of the view during uploading */
    var overlayOpacity: CGFloat = 0.6
   
    /** The main font used. Changing this font will automatically change the font for all labels */
    var mainFont = UIFont(name: "Avenir-Medium", size: 30.0)! {
        didSet { loadingLabel.font = mainFont }
    }
    
    /* The progress loader. Set the percentage of upload complete as a decimal to update the loader */
    var progress: CGFloat {
        get {
            return circlePathLayer.strokeEnd
        }
        set {
            if (newValue > 1) {
                circlePathLayer.strokeEnd = 1
            } else if (newValue < 0) {
                circlePathLayer.strokeEnd = 0
            } else {
                circlePathLayer.strokeEnd = newValue
            }
            loadingLabel.text = "\(Int(circlePathLayer.strokeEnd*100))%"
        }
    }
    
    
    
    // ==============================================================================================
    // MARK: - Initializers
    // ==============================================================================================
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {
        // Add all views and layers
        self.addSubview(containerView)
        containerView.addSubview(contentView)
        containerView.addSubview(overlayView)
        containerView.addSubview(loadingLabel)
        containerView.addSubview(endView)
        contentView.addSubview(imageView)
        self.layer.addSublayer(circlePathLayer)
        
        // View setup
        containerView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        
        imageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        for view in containerView.subviews {
            view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        }
        
        // Overlay
        overlayView.backgroundColor = UIColor.black
        overlayView.alpha = 0
        
        // Loading Label
        loadingLabel.textColor = UIColor.white
        loadingLabel.textAlignment = .center
        loadingLabel.alpha = 0
        
        // End view
        endView.alpha = 0
        
        // Circle Path Layer
        circlePathLayer.strokeStart = 0
        circlePathLayer.strokeEnd = 0
        circlePathLayer.lineWidth = lineWidth
        circlePathLayer.strokeColor = lineColor.cgColor
        circlePathLayer.fillColor = UIColor.clear.cgColor
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Offset the ring by lineWidth/2
        self.circlePathLayer.frame = self.bounds
        let circleFrame = circlePathLayer.frame.insetBy(dx: lineWidth/2, dy: lineWidth/2)
        circlePathLayer.path = UIBezierPath(ovalIn: circleFrame).cgPath
        
        // Offset the content view by lineWidth
        containerView.frame = self.frame.insetBy(dx: lineWidth, dy: lineWidth)
        containerView.frame.center = self.bounds.center
        
        // Transform all views back into circles
        containerView.transformToCircle()
        
        // Scale font size
        mainFont = UIFont(name: mainFont.fontName, size: (30.0/150.0) * self.frame.width)!
    }
    
    
    
    // ==============================================================================================
    // MARK: - Methods
    // ==============================================================================================
    
    func startUpload() {
        progress = 0
        UIView.animate(withDuration: 0.5) { 
            self.overlayView.alpha = self.overlayOpacity
            self.loadingLabel.alpha = 1
        }
    }
    
    func endUpload(error: Bool, message: String) {
        UIView.animate(withDuration: 0.5) { 
            self.loadingLabel.alpha = 0
            self.endView.alpha = 1
        }
    }
    
}















// ==============================================================================================
// MARK: - Extensions
// ==============================================================================================
extension CGRect {
    
    /** The center point of the rectangle. It is mutable. */
    var center: CGPoint {
        get {
            return CGPoint(x: self.midX, y: self.midY)
        }
        set {
            self.origin.x = newValue.x - width/2
            self.origin.y = newValue.y - height/2
        }
    }
    
}

extension UIView {
    
    /** Caches a shadow to prevent lag */
    func cacheShadow() {
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.layer.cornerRadius).cgPath
    }
    
    /** Turns a square view into a circle by changing the corner radius */
    func transformToCircle() {
        self.layer.cornerRadius = self.frame.height/2
    }
}


