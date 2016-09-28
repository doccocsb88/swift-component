//
//  ViewController.swift
//  GBComponent
//
//  Created by macbook on 9/27/16.
//  Copyright © 2016 macbook. All rights reserved.
//

import UIKit
import FBSDKLoginKit
class ViewController: UIViewController {

    var btnFBLogin: FBSDKLoginButton?
    override func viewDidLoad() {
        super.viewDidLoad()
        btnFBLogin = FBSDKLoginButton(frame: CGRectMake(0, self.view.frame.size.height - 100, self.view.frame.size.width,50))
        btnFBLogin?.readPermissions = ["email","user_friends","user_photos"]
        btnFBLogin?.publishPermissions = ["publish_actions"]

        self.view.addSubview(btnFBLogin!)

        // Do any additional setup after loading the view, typically from a nib.
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if (FBSDKAccessToken.currentAccessToken() != nil){
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let viewcontroller = storyboard.instantiateViewControllerWithIdentifier("fbComponent")
            self.presentViewController(viewcontroller, animated: true, completion: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

