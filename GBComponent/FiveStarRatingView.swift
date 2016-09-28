//
//  FiveStarRatingView.swift
//  GBComponent
//
//  Created by macbook on 9/27/16.
//  Copyright © 2016 macbook. All rights reserved.
//

import Foundation
import UIKit
@IBDesignable

class FiveStarRatingView: UIView {
    @IBInspectable var numberOfStar: Int = 5
    @IBInspectable var currentIndex: Int = 0
    @IBInspectable var pading: CGFloat = 0.0
    @IBInspectable var itemSize: CGFloat = 10.0
    @IBInspectable var imageNormal: UIImage? = UIImage(named: "ic_five_star_normal")
    @IBInspectable var imageSelected: UIImage? = UIImage(named: "ic_five_star_selected")
    
    var leftPading: CGFloat = 0
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    override func drawRect(rect: CGRect) {
        // Add ARCs
        addStar()
    }
    override func intrinsicContentSize() -> CGSize {
        let width = leftPading + CGFloat(numberOfStar) * itemSize + pading *  CGFloat(numberOfStar)
        let height = itemSize + pading * 2
        return CGSize(width: width, height: height)
    }
    
    func addStar(){
        
        
        for index in 1...numberOfStar{
            let margin = leftPading + pading * CGFloat(integerLiteral: index) +  itemSize * CGFloat(integerLiteral: index - 1)
            let marginTop = self.frame.size.height / 2 - itemSize / 2
            let item = UIImageView(frame: CGRectMake(leftPading + margin , marginTop, itemSize, itemSize))
            if index > currentIndex {
                item.image = imageNormal
            }else{
                item.image = imageSelected
            }
            item.contentMode = UIViewContentMode.ScaleAspectFit
            item.tag = index
            self.addSubview(item)
        }
    }
    func updateCurrentStar(){
        for view in self.subviews{
            if let image =  view as? UIImageView{
                
                if view.tag >  currentIndex {
                    image.image = imageNormal
                }else{
                    image.image = imageSelected
                    
                }
            }
        }
    }
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touch = touches.first {
            // ...
            let location = touch.locationInView(self)
            if location.y >= 0 && location.y <= itemSize + 2 * pading {
                let index: Int = Int(location.x / (pading + itemSize))
                currentIndex = index
                print("touch at index \(index)")
                updateCurrentStar()
            }
        }
        
    }
    
    
}