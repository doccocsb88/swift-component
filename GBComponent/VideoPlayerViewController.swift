//
//  VideoPlayerViewController.swift
//  GBComponent
//
//  Created by macbook on 9/29/16.
//  Copyright © 2016 macbook. All rights reserved.
//

import Foundation
import UIKit
class VideoPlayerViewController: UIViewController {
    
    @IBOutlet weak var videoContainer: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        if let videoView = UIView.loadFromNibNamed("GBVideoPlayerView", bundle: NSBundle.mainBundle()) as? GBVideoPlayerView{
            videoView.frame = videoContainer.bounds
            videoContainer.addSubview(videoView)
        }
    }
    
    @IBAction func pressedBack(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}
extension UIView {
    class func loadFromNibNamed(nibNamed: String, bundle : NSBundle? = nil) -> UIView? {
        return UINib(
            nibName: nibNamed,
            bundle: bundle
            ).instantiateWithOwner(nil, options: nil)[0] as? UIView
    }
}