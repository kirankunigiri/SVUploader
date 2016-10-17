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
    var contentImageView = UIImageView()
    var endImageView = UIImageView()
    var overlayView = UIView()
    var loadingLabel = UILabel()
    
    // Image assets
    var successImage = UIImage(named: "Check")
    var errorImage = UIImage(named: "X")
    
    // The circle is separate and is outside the container view
    var circlePathLayer = CAShapeLayer()
    
    /** The image of the uploader. Can be set to nil if an image is not being used. */
    var image: UIImage? {
        didSet {
            if image != nil {
                self.contentImageView.image = image
                self.contentImageView.isHidden = false
            } else {
                self.contentImageView.isHidden = true
            }
        }
    }
    
    
    
    // ==============================================================================================
    // MARK: Variables
    // ==============================================================================================
    
    /** Whether or not the uploader is currently uploading */
    var isUploading: Bool = false
    
    /** The color of the circular loader */
    var lineColor = UIColor(red:0.40, green:0.47, blue:0.97, alpha:1.0) {
        didSet { circlePathLayer.strokeColor = lineColor.cgColor }
    }
    
    /** The width of the circular loader */
    var lineWidth: CGFloat = 10 {
        didSet { circlePathLayer.lineWidth = lineWidth }
    }
    
    /** The speed of the animation between progress value changes. This number should be changed depending on the length of intervals between each progress percentage update. For larger intervals, a lower speed is recommended for a smoother animation. For shorter intervals, a higher speed is recommended to prevent slow animation and lag. Default value = 1 */
    var progressAnimationSpeed: Float = 2 {
        didSet { circlePathLayer.speed = progressAnimationSpeed }
    }
    
    /** Whether the stroke animate or instantly changes. Cannot be changed back to smooth if it is set to false */
    var isSmoothAnimation: Bool = true {
        didSet {
            if !isSmoothAnimation {
                circlePathLayer.actions = ["strokeEnd" : NSNull()]
            }
        }
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
            if !isUploading {
                return
            }
            if (newValue > 1.0) {
                circlePathLayer.strokeEnd = 1
            } else if (newValue < 0) {
                circlePathLayer.strokeEnd = 0
            } else {
                circlePathLayer.strokeEnd = newValue
            }
            loadingLabel.text = "\(Int(circlePathLayer.strokeEnd*100))%"
        }
    }
    
    /** Set success to easily modify the endView properties */
    private var success: Bool = true {
        didSet {
            if success { endImageView.image = successImage }
            else { endImageView.image = errorImage }
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
        self.layer.addSublayer(circlePathLayer)

        self.addSubview(containerView)
        containerView.addSubview(contentView)
        containerView.addSubview(overlayView)
        containerView.addSubview(loadingLabel)
        containerView.addSubview(endView)
        contentView.addSubview(contentImageView)
        endView.addSubview(endImageView)
        
        // View setup
        containerView.clipsToBounds = true
        contentImageView.contentMode = .scaleAspectFill
        
        contentImageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
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
        endImageView.image = errorImage
        endImageView.contentMode = .scaleAspectFit
        endView.alpha = 0
        
        // Circle Path Layer
        circlePathLayer.strokeStart = 0
        circlePathLayer.strokeEnd = 0
        circlePathLayer.lineWidth = lineWidth
        circlePathLayer.strokeColor = lineColor.cgColor
        circlePathLayer.fillColor = UIColor.clear.cgColor
        circlePathLayer.speed = progressAnimationSpeed
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Important: To center a view, set its frame.center to superview!.bounds.center
        
        // Offset the ring by lineWidth/2
        self.circlePathLayer.frame = self.bounds
        let circleFrame = circlePathLayer.frame.insetBy(dx: lineWidth/2, dy: lineWidth/2)
        circlePathLayer.path = UIBezierPath(ovalIn: circleFrame).cgPath
        
        // Offset the content view by lineWidth
        containerView.frame = self.frame.insetBy(dx: lineWidth, dy: lineWidth)
        containerView.frame.center = containerView.superview!.bounds.center
        
        // Offset the image view
        endImageView.frame = containerView.frame.insetBy(dx: 60, dy: 60)
        endImageView.frame.center = endImageView.superview!.bounds.center
        
        // Transform container view back into a circle
        containerView.transformToCircle()
        
        // Scale font size
        mainFont = UIFont(name: mainFont.fontName, size: (30.0/150.0) * self.frame.width)!
    }
    
    
    
    // ==============================================================================================
    // MARK: - Methods
    // ==============================================================================================
    
    func startUpload() {
        // Set the initial properties
        isUploading = true
        progress = 0
        
        // Animate the loading views in
        UIView.animate(withDuration: 0.5) {
            self.circlePathLayer.isHidden = false
            self.overlayView.alpha = self.overlayOpacity
            self.loadingLabel.alpha = 1
        }
    }
    
    func endUpload(success: Bool, message: String) {
        // Set the initial properties
        isUploading = false
        self.success = success

        // Prepare the circle path for the animation
        let originalPath = circlePathLayer.path
        self.circlePathLayer.frame = self.bounds
        let circleFrame = circlePathLayer.frame.insetBy(dx: lineWidth*2, dy: lineWidth*2)
        let toPath = UIBezierPath(ovalIn: circleFrame).cgPath
        
        // Wrap animation in a CATransaction
        CATransaction.begin()
        // Use another CABasicAnimation in the completion block with a duration of 0 to change the frame back to the original, because changing the property itself does not work
        CATransaction.setCompletionBlock {
            let anim = CABasicAnimation(keyPath: "path")
            anim.toValue = originalPath
            anim.duration = 0
            anim.fillMode = kCAFillModeForwards
            anim.isRemovedOnCompletion = false
            self.circlePathLayer.add(anim, forKey: "path")
            self.circlePathLayer.isHidden = true
            self.circlePathLayer.strokeEnd = 0
        }
        
        // Shrink the path of the circle layer
        let anim = CABasicAnimation(keyPath: "path")
        anim.toValue = toPath
        anim.duration = 1
        anim.fillMode = kCAFillModeForwards
        anim.isRemovedOnCompletion = false
        circlePathLayer.add(anim, forKey: "path")
        CATransaction.commit()
        
        // Animate the endView out and return to the original state
        UIView.animate(withDuration: 1, animations: { 
            self.loadingLabel.alpha = 0
            self.endView.alpha = 1
        }) { (completion) in
            UIView.animate(withDuration: 1, delay: 2, options: [], animations: {
                self.overlayView.alpha = 0
                self.endView.alpha = 0
            }, completion: nil)
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


