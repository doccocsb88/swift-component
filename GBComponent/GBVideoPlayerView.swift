//
//  GBVideoPlayerView.swift
//  GBComponent
//
//  Created by macbook on 9/29/16.
//  Copyright © 2016 macbook. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
protocol GBVideoPlayerDelegate{
    func didPlay()
    func didStop()
    func didPause()
}
class GBVideoPlayerView: UIView {
    
    @IBOutlet weak var loadingView: UIActivityIndicatorView!
    @IBOutlet weak var btnPlay: UIButton!
    @IBOutlet weak var lbCurrentTime: UILabel!
    @IBOutlet weak var lbRemainTime: UILabel!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var playerControlView: UIView!
    
    @IBOutlet weak var playerView: UIView!
    var isShowingController: Bool = true
    var delegate:GBVideoPlayerDelegate?
    //
    var playerLayer: AVPlayerLayer?
    var player: AVPlayer?
    var duration: Float?
    private var timeObserverToken: AnyObject?

    //
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override init(frame: CGRect) {
        super.init(frame: frame)

    }
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
        setupPlayer()

    }
    func setupView(){
        slider.setThumbImage(UIImage.init(), forState: .Normal)
       loadingView.startAnimating()
        //add target
        btnPlay.addTarget(self, action: #selector(pressedPlay(_:)), forControlEvents: .TouchUpInside)
        let pan = UIPanGestureRecognizer(target: self, action: #selector(gestureHandle(_:)))
        pan.maximumNumberOfTouches = 1
        pan.minimumNumberOfTouches = 1
        self.addGestureRecognizer(pan)
    }
    func setupPlayer(){
        

        let path =  NSBundle.mainBundle().pathForResource("toystory", ofType: "mp4")
        let url =   NSURL(fileURLWithPath: path!)
        
        self.player = AVPlayer(URL: url)
        self.player?.actionAtItemEnd = AVPlayerActionAtItemEnd.None
        self.playerLayer = AVPlayerLayer(player: self.player)
        self.playerLayer?.videoGravity = AVVideoScalingModeFit
        let viewWidth = CGRectGetWidth(UIScreen.mainScreen().bounds)
        self.playerLayer?.frame = CGRectMake(0, 0, viewWidth , viewWidth * 2 / 3 )
        self.playerLayer?.backgroundColor = UIColor.yellowColor().CGColor
        self.playerView.layer.addSublayer(self.playerLayer!)
        self.playerView.backgroundColor = UIColor.blueColor()
        player?.currentItem?.addObserver(self, forKeyPath: "status", options: NSKeyValueObservingOptions.New, context: nil)
        player?.addObserver(self, forKeyPath: "rate", options: NSKeyValueObservingOptions.New, context: nil)
        let interval = 0.1
        timeObserverToken = player?.addPeriodicTimeObserverForInterval(CMTimeMakeWithSeconds(1, 1), queue: dispatch_get_main_queue()) { [unowned self] time in
            
            if self.player?.currentItem?.status == .ReadyToPlay {
                self.updateSlider()
            }
            
        }
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(itemDidFinishPlaying(_:)), name: AVPlayerItemDidPlayToEndTimeNotification, object: player?.currentItem)
        
        
        self.player?.play()
    }
    //MARK
    func isPlaying() ->Bool{
        return self.player?.rate > 0.0;
    }
    func play(){
       self.player?.play()
    }
    func pause(){
        self.player?.pause()
        showController()
    }
    func stop(){
        self.player?.pause()
        let seekTime : CMTime = CMTimeMake(0, 1000)
        self.player?.seekToTime(seekTime)
        showController()
    }
    func itemDidFinishPlaying(notif:NSNotification){
        stop()
    }
    //
    func togglePlayer(){
        if isPlaying() {
            pause()
        }else{
            play()
        }

    }
    func toggleController(){
        print("toggle controller")
        if  isShowingController {
        //hide controller
            hideController()
        }else{
            //shode controller
            showController()
        }
    }
    func hideController(){
        UIView.animateWithDuration(1.0, animations: {
            self.playerControlView.alpha = 0.0
            }, completion: { finished in
                self.isShowingController = false
        })
    }
    func showController(){
        UIView.animateWithDuration(1.0, animations: {
            self.playerControlView.alpha = 1.0
            }, completion: { finished in
                self.isShowingController = true
                if self.isPlaying(){
                    NSTimer.scheduledTimerWithTimeInterval(3.0, target: self, selector: #selector(self.hideController), userInfo: nil, repeats: false)
                }
        })

    }
    func resetController(){
        lbCurrentTime.text = "0:00"
        lbRemainTime.text = "0:00"
        slider.value = 0.0
    }
    func bindDataToController(){
        lbRemainTime.text = String(format: "%.2f",duration!)
    }
    func updateSlider(){
        let time = self.player?.currentTime()
        let timeNow = Float((time?.value)!) / Float((time?.timescale)!)
        let timeRemain = duration! - timeNow
        //
        var currentMins = timeNow / 60
        var currentSec = timeNow % 60
        print("timeNow \(timeNow)")
        
        let strduration: String = String(format: "%2.0f:%2.0f",currentMins,currentSec)
        
         currentMins = timeRemain / 60
         currentSec = timeRemain % 60
        let strTimeRemain = String(format: "%2.0f:%2.0f",currentMins, currentSec)
        
        //
        self.lbCurrentTime.text = strduration
        self.lbRemainTime.text = strTimeRemain
        self.slider.value = Float(timeNow/duration!)
    }
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        toggleController()
        togglePlayer()
    }
    // catch changes to status
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if keyPath == "rate"{
            if ((self.player) != nil) {
                let rate = self.player?.rate
                if (rate > 0) {
                    print("play di em")
                    
                }
            }
        }else if keyPath == "status"{
            print("status")
//            print("obsrved \(keyPath) \(player?.currentItem?.status.rawValue)")
      
            
            if player?.currentItem?.status == AVPlayerItemStatus.ReadyToPlay{
                self.loadingView.stopAnimating()
            }
            if let dr = self.player?.currentItem?.asset.duration {
                duration =  Float(CMTimeGetSeconds(dr))
                print("duration \(duration)")
            }else{
                duration = 0.0
            }
            self.bindDataToController()
            self.showController()
        }
    }
    
    //MARK
    func gestureHandle(gesture: UIPanGestureRecognizer){
        if gesture.state == UIGestureRecognizerState.Ended{
            toggleController()
        }
    }
    func pressedPlay(sender:UIButton){
        togglePlayer()
    }
    
    deinit{

        NSNotificationCenter.defaultCenter().removeObserver(self, name: AVPlayerItemDidPlayToEndTimeNotification, object: nil)
        player?.currentItem?.removeObserver(self, forKeyPath: "status", context: nil)
        player?.removeObserver(self, forKeyPath: "rate", context: nil)
        if let timeObserverToken = timeObserverToken {
            player?.removeTimeObserver(timeObserverToken)
            self.timeObserverToken = nil
        }
    }
}