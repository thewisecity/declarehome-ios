//
//  MessageUIView.swift
//  CookedApp
//
//  Created by Dexter Lohnes on 10/16/15.
//  Copyright © 2015 The Wise City. All rights reserved.
//

import UIKit

class MessageUIView: UIView {
    
    enum MessageType {case Message, Alert}
    
    var delegate: MessageUIViewDelegate?
    
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var postAlertButton: UIButton!
    @IBOutlet weak var postMessageButton: UIButton!
    
    var isExpanded: Bool = false
        {
        didSet
        {
            
            var postMessageButtonFrame: CGRect  = postMessageButton.frame
            var postAlertButtonFrame: CGRect  = postAlertButton.frame
            
            UIView.beginAnimations(nil, context: nil)
            
            if isExpanded == false
            {
                postMessageButtonFrame.origin.y = plusButton.frame.origin.y + plusButton.frame.size.height + 10
                postAlertButtonFrame.origin.y = plusButton.frame.origin.y + plusButton.frame.size.height + 10
            }
            else
            {
                postMessageButtonFrame.origin.y = plusButton.frame.origin.y - postMessageButton.frame.size.height - 20
                postAlertButtonFrame.origin.y = postMessageButtonFrame.origin.y - postAlertButton.frame.size.height - 20
            }

            UIView.setAnimationDuration(0.32)
            UIView.setAnimationCurve(UIViewAnimationCurve.EaseOut)
            
            postMessageButton.frame = postMessageButtonFrame
            postAlertButton.frame = postAlertButtonFrame
            
            UIView.commitAnimations()
            
        }
    }
   
    @IBAction func respondToPlusButtonTouched()
    {
        delegate?.plusButtonTouched()
        isExpanded = !isExpanded
        
        // We are now measuring the 'new' state of expansion
        if isExpanded == true
        {
            Stats.TrackOpenedNewMessageMenu()
        }
        else
        {
            Stats.TrackClosedNewMessageMenu()
        }
    }
    
    @IBAction func respondToPostAlertButtonTouched()
    {
        delegate?.alertButtonTouched()
        beginMessageCreation(MessageType.Alert)
    }
    
    @IBAction func respondToPostMessageButtonTouched()
    {
        delegate?.messageButtonTouched()
        beginMessageCreation(MessageType.Message)
    }
    
    func beginMessageCreation(type: MessageType) -> Void
    {
        
        
        if type == MessageType.Message
        {
            plusButton.hidden = true
            delegate?.messageTextField?.hidden = false
            delegate?.messageTextField?.becomeFirstResponder()
            Stats.TrackBeganMessageCreation()
            //  Analytics.with(App.getContext()).track("Began Message Creation");
        }
        else if type == MessageType.Alert
        {
            isExpanded = false
            showPickerAlertTypeForAlert()
            Stats.TrackBeganAlertCreation()
            // Analytics.with(App.getContext()).track("Began Alert Creation");
        }
    }
    
    func endMessageCreation() -> Void {
        delegate?.chosenCategory = nil
        delegate?.selectedGroups = nil
        configureMessageCompositionAreaForAlertCategory()
        delegate?.messageTextField?.attributedText = nil
        delegate?.messageTextField?.attributedText? = NSMutableAttributedString(string: "S")
        delegate?.messageTextField?.text = ""
        delegate?.messageTextField?.endEditing(true)
        plusButton.hidden = false
        isExpanded = false
    }

    override func pointInside(point: CGPoint, withEvent event: UIEvent?) -> Bool
    {
        print("Subview count: \(subviews.count)")
        var absorbTouch = false
        for v:UIView in subviews
        {
            if v.hitTest(convertPoint(point, toView: v), withEvent: event) != nil
            {
                print("Taking touch")
                absorbTouch = true
                break
            }
        }
        return absorbTouch
    }
    
    func showPickerAlertTypeForAlert() -> Void
    {
        print("Show alert type picker here")
    }
    
    func showAlertComposition()
    {
        plusButton.hidden = true
        isExpanded = false;
        configureMessageCompositionAreaForAlertCategory()
        delegate?.messageTextField?.becomeFirstResponder()
        Stats.TrackBeganAlertComposition()
    }
    
    func configureMessageCompositionAreaForAlertCategory()
    {
        if let chosenCategory = delegate?.chosenCategory
        {
            let str : NSMutableAttributedString = chosenCategory.getAttributedTitleString()
            str.appendAttributedString(NSAttributedString(string: " "))
            delegate?.messageTextField?.attributedText = str
        }
        else
        {
            // In order to ensure we remove the attributed text features from our text view
            // for some reason we actually need to set our attributedText
            // to an NSMutableAttributedString which is not equal to an empty string ("").
            // Only then are we able to remove the attributed features of the text,
            // at which point we are free to set the text to an empty string
            let str = NSMutableAttributedString(string: "S")
            delegate?.messageTextField?.attributedText = str
            delegate?.messageTextField?.text = ""
        }
        
    }
    
//    private void showAlertComposition(@NonNull AlertCategory chosenCategory) {
//    
//    configureMessageCompositionAreaForAlertCategory(chosenCategory);
//    
//    mPlusButton.setVisibility(View.GONE);
//    showPostMessageButtons(false);
//    mEditTextLayout.setVisibility(View.VISIBLE);
//    if(mMessageBodyEditText.requestFocus()) {
//    InputMethodManager imm = (InputMethodManager) App.getContext().getSystemService(Context.INPUT_METHOD_SERVICE);
//    imm.showSoftInput(mMessageBodyEditText, InputMethodManager.SHOW_IMPLICIT);
//    }

//    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
