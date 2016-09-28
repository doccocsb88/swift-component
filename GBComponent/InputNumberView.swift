//
//  InputNumberView.swift
//  GBComponent
//
//  Created by macbook on 9/27/16.
//  Copyright © 2016 macbook. All rights reserved.
//

import Foundation
import UIKit

@objc protocol InputNumberViewDelegate {
    optional func didFinishedInputNumber(inputNumber: InputNumberView, stringInput: String)
}
@IBDesignable
class InputNumberView: UIView  {
    var delegate: InputNumberViewDelegate?
    @IBInspectable var numberOfTextField: Int = 4
    @IBInspectable var padding: CGFloat = 20
    @IBInspectable var itemSize: CGFloat = 40
    @IBInspectable var fontNormal: UIFont? = UIFont.systemFontOfSize(12)
    @IBInspectable var fontFocus: UIFont? = UIFont.systemFontOfSize(14)

    var currentIndex: Int = NSNotFound

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        drawSubView()
    }
    override func intrinsicContentSize() -> CGSize {
        let width =  CGFloat(numberOfTextField) * itemSize + padding *  CGFloat(numberOfTextField - 1)
        let height = itemSize
        return CGSize(width: width, height: height)
    }
    func drawSubView(){
        for index in 1...numberOfTextField{
            let textField = UITextField(frame: CGRectMake(CGFloat(index - 1) * padding + CGFloat(index - 1) * itemSize,0,40,40))
            textField.delegate = self
            textField.font = fontNormal
            textField.tag = index
            textField.layer.borderColor = UIColor.blackColor().CGColor
            textField.layer.borderWidth = 1.0
            textField.textAlignment = NSTextAlignment.Center
            textField.addTarget(self, action: #selector(textFieldDidChange(_:)), forControlEvents: UIControlEvents.EditingChanged)
            if index < numberOfTextField {
                textField.returnKeyType = UIReturnKeyType.Next
            }else{
                textField.returnKeyType = UIReturnKeyType.Done
            
            }
            self.addSubview(textField)
            
        }
    }
}
extension InputNumberView : UITextFieldDelegate{
    func textFieldDidChange(textField:UITextField){
        focusOnNextTextField(textField.tag + 1)
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField.tag == numberOfTextField {
            //lastTextField
            textField.resignFirstResponder()
            if validateIndex(){
                delegate?.didFinishedInputNumber!(self, stringInput: stringInput())
            }
        }else{
            if let nextTextField = self.viewWithTag(textField.tag + 1) as? UITextField{
                nextTextField.becomeFirstResponder()
            }
        }
        return true
    }
    func textFieldDidBeginEditing(textField: UITextField) {
        textField.text = ""
        hightlightTextField(textField)
    }
    func textFieldDidEndEditing(textField: UITextField) {
        unHightlightTextField(textField)
    }
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if (textField.text?.characters.count)! + string.characters.count == 1{
            return true
        }
        return false
    }
    func focusOnNextTextField(tag: Int){
        if let nextTextField = self.viewWithTag(tag) as? UITextField{
            nextTextField.becomeFirstResponder()
        }

    }
    func validateIndex() ->Bool{
        for index in 1...numberOfTextField{
            if let tf = self.viewWithTag(index) as? UITextField{
                if tf.text?.characters.count == 0 {
                    return false
                }
            }
        }
        return true
    }
    func stringInput() ->String{
        var stringInput:String = ""
        for index in 1...numberOfTextField{
            if let tf = self.viewWithTag(index) as? UITextField{
                stringInput = stringInput + tf.text!
            }
        }
        return stringInput
    }
    func hightlightTextField(textField: UITextField){
        textField.font = fontFocus
        textField.layer.borderColor = UIColor.redColor().CGColor
        textField.layer.borderWidth = 1.5
    }
    func unHightlightTextField(textField: UITextField){
        textField.font = fontNormal
        textField.layer.borderColor = UIColor.blackColor().CGColor
        textField.layer.borderWidth = 1.0
    }
}