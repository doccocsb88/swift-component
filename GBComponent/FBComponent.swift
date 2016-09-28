//
//  FBComponent.swift
//  GBComponent
//
//  Created by macbook on 9/28/16.
//  Copyright © 2016 macbook. All rights reserved.
//

import Foundation
import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import FBSDKShareKit

class FBComponent: UIViewController {
    var btnFBLogin: FBSDKLoginButton?
    @IBOutlet weak var btnFBSend: UIButton!
    @IBOutlet weak var btnFBShare: UIButton!
    @IBOutlet weak var lbFBId: UILabel!
    @IBOutlet weak var lbFBUsername: UILabel!
    @IBOutlet weak var lbFBEmail: UILabel!
    @IBOutlet weak var tbFriendList: UITableView!
    
    
    var facebookid : String?
    var fbusername : String?
    var fbuserEmail : String?
    var btnShare: FBSDKShareButton?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        btnFBLogin = FBSDKLoginButton(frame: CGRectMake(0, self.view.frame.size.height - 100, self.view.frame.size.width,50))
        btnFBLogin?.readPermissions = ["email","user_friends","user_photos"]
        btnFBLogin?.publishPermissions = ["publish_actions"]
        self.view.addSubview(btnFBLogin!)
        
        btnShare = FBSDKShareButton()
        btnShare?.frame = CGRectMake((UIScreen.mainScreen().bounds.width - 100) * 0.5, 50, 100, 25)
        self.view.addSubview(btnShare!)
        //
        if let loginResult = FBSDKAccessToken.currentAccessToken(){
            print("has access token \(loginResult.tokenString)")
            if  loginResult.hasGranted("user_friends") {
                print("has publish_action")
                let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath:  "me", parameters: ["fields":"id,name,link,first_name, last_name,friendlists,friends"])
                graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
                    
                    if ((error) != nil)
                    {
                        // Process error
                        print("Error: \(error)")
                    }
                    else
                    {
                        self.facebookid = result.valueForKey("id") as? String
                        self.fbusername = result.valueForKey("name") as? String
                        self.fbuserEmail = result.valueForKey("email") as? String
                        print("facebookInfo : \(self.facebookid)")
                        self.lbFBId.text = self.facebookid
                        self.lbFBUsername.text = self.fbusername
                        self.lbFBEmail.text = self.fbuserEmail
//                        let friends = result.valueForKey("friends") as? NSDictionary
//                        print("friendList : \(friends)")
                        print("result : \(result)")
                    }
                })
                //
                let friendRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath:  "/me/friends", parameters: ["fields":"name"])
                friendRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
                    
                    if ((error) != nil)
                    {
                        // Process error
                        print("Error: \(error)")
                    }
                    else
                    {
                    
                        let friends = result.valueForKey("friends") as? NSDictionary
                        print("friendList : \(friends?.objectForKey("data"))")
                        print("result : \(result)")
                    }
                })
                //========================

                let permissionRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath:  "/me/permissions", parameters: nil)
                permissionRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
                    
                    if ((error) != nil)
                    {
                        // Process error
                        print("Error: \(error)")
                    }
                    else
                    {
          
                        print("result : \(result)")
                    }
                })
                //========================
                let infoRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath:  "/638010846359309", parameters: ["fields":"friendlists,friends"])
                infoRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
                    
                    if ((error) != nil)
                    {
                        // Process error
                        print("infoRequest Error: \(error)")
                    }
                    else
                    {
                        
                        print("infoRequest result : \(result)")
                    }
                })
            }else{
                print("do not have permission")
            }
        }else{
        //
            print("do not have access token")
        }
        //
//        let content : FBSDKShareLinkContent = FBSDKShareLinkContent()
//        content.contentURL = NSURL(string: "<INSERT STRING HERE>")
//        content.contentTitle = "<INSERT STRING HERE>"
//        content.contentDescription = "<INSERT STRING HERE>"
//        content.imageURL = NSURL(string: "http://www.brianjcoleman.com/icons/Classix-Icon.png")
//        
//       
    }
}
extension FBComponent : UITableViewDelegate, UITableViewDataSource{
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("fbFriendCell", forIndexPath: indexPath)
        
        return cell
    }
}
extension FBComponent{

    @IBAction func pressedFBShare(sender: AnyObject) {

        sharePhoto()
        
    }
    
    @IBAction func pressedFBSend(sender: AnyObject) {
        postToWall()
    }
    
    func sharePhoto(){
        let photo : FBSDKSharePhoto = FBSDKSharePhoto()
        photo.image = UIImage.init(named: "ic_five_star_normal")
        photo.userGenerated = true
        
        let content : FBSDKSharePhotoContent = FBSDKSharePhotoContent()
        content.photos = [photo]
        
        FBSDKShareAPI.shareWithContent(content, delegate: nil)
        FBSDKShareDialog.showFromViewController(self, withContent: content, delegate: nil)
        btnShare?.shareContent = content
    }
    func shareLink(){
        let content : FBSDKShareLinkContent = FBSDKShareLinkContent()
        content.contentURL = NSURL(string: "<INSERT STRING HERE>")
        content.contentTitle = "<INSERT STRING HERE>"
        content.contentDescription = "<INSERT STRING HERE>"
        content.imageURL = NSURL(string: "http://www.brianjcoleman.com/icons/Classix-Icon.png")
        content.contentURL = NSURL(string: "http://www.brianjcoleman.com/icons/Classix-Icon.png")
        //
        let dialog = FBSDKShareDialog.init()
        dialog.fromViewController = self
        dialog.shareContent = content
        dialog.mode = .ShareSheet
        dialog.show()
    }
    
    func postToWall(){
        //
        
//        let permissionRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath:  "/me/permissions", parameters: nil)
//        permissionRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
//            
//            if ((error) != nil)
//            {
//                // Process error
//                print("Error: \(error)")
//            }
//            else
//            {
//                
//                print("result : \(result)")
//            }
//        })
        let linkData = ["link": "http://www.example.com","message" : "User provided message"]

        let postRequest: FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me/feed", parameters: linkData, HTTPMethod: "POST")
                postRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
        
                    if ((error) != nil)
                    {
                        // Process error
                        print("Error: \(error)")
                    }
                    else
                    {
        
                        print("result : \(result)")
                    }
                })
    }
    
}
class FBFriendViewCell: UITableViewCell{
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}