//
//  GBVerticalButton.swift
//  GBComponent
//
//  Created by macbook on 9/27/16.
//  Copyright © 2016 macbook. All rights reserved.
//

import Foundation
import UIKit
class GBVerticalButton: UIButton {
    @IBInspectable var spacing: CGFloat = 10
    @IBInspectable var iconSize: CGFloat = 10

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        let imageSize = CGSizeMake(iconSize, iconSize)
        self.titleEdgeInsets = UIEdgeInsets(top:0,
                                            left:-imageSize.width,
                                            bottom:-(imageSize.height + spacing),
                                            right:0)
        let titleSize = self.titleLabel!.frame.size
        self.imageEdgeInsets = UIEdgeInsets(top:-(titleSize.height + spacing),
                                            left:0,
                                            bottom: 0,
                                            right:-titleSize.width)
        
        // reset contentInset, so intrinsicContentSize() is still accurate
        let trueContentSize = CGRectUnion(self.titleLabel!.frame, self.imageView!.frame).size
        let oldContentSize = self.intrinsicContentSize()
        let heightDelta = trueContentSize.height - oldContentSize.height
        let widthDelta = trueContentSize.width - oldContentSize.width
        self.contentEdgeInsets = UIEdgeInsets(top:heightDelta/2.0,
                                              left:widthDelta/2.0,
                                              bottom:heightDelta/2.0,
                                              right:widthDelta/2.0)
    }
}