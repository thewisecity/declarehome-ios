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
    
    var isExpanded: Bool = false {
        didSet {
            
            var postMessageButtonFrame: CGRect  = postMessageButton.frame
            var postAlertButtonFrame: CGRect  = postAlertButton.frame
            
            UIView.beginAnimations(nil, context: nil)
            
            if isExpanded == false {
                postMessageButtonFrame.origin.y = plusButton.frame.origin.y + plusButton.frame.size.height + 10
                postAlertButtonFrame.origin.y = plusButton.frame.origin.y + plusButton.frame.size.height + 10
            } else {
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
   
    @IBAction func respondToPlusButtonTouched() {
        delegate?.plusButtonTouched()
        
        isExpanded = !isExpanded
        
    }
    
    @IBAction func respondToPostAlertButtonTouched() {
        delegate?.alertButtonTouched()
        beginMessageCreation(MessageType.Alert)
    }
    
    @IBAction func respondToPostMessageButtonTouched() {
        delegate?.messageButtonTouched()
        beginMessageCreation(MessageType.Message)
    }
    
    func beginMessageCreation(type: MessageType) -> Void {
        plusButton.hidden = true
        isExpanded = false
        
        if type == MessageType.Message {
            delegate?.messageTextField?.hidden = false
            delegate?.messageTextField?.becomeFirstResponder()
            //  TODO: Analytics call here
            //  Analytics.with(App.getContext()).track("Began Message Creation");
        } else if type == MessageType.Alert {
            showPickerAlertTypeForAlert()
            // TODO: Analytics call here
            // Analytics.with(App.getContext()).track("Began Alert Creation");
        }
    }
    
    func endMessageCreation() -> Void {
        //chosenAlertCategory = nil
        //unselectAllCheckedGroups()
        //selectedGroupsForAlert.clear()
        //hidePickGroupsForAlert()
        //hidePickAlertTypeForAlert()
        //configureMessageCompositionAreaForAlertCategory()
        //clearMessageText()
        delegate?.messageTextField?.text = nil
        delegate?.messageTextField?.endEditing(true)
        plusButton.hidden = false
        isExpanded = false
    }
    
//    private void cancelMessageCreation() {
//    mChosenAlertCategory = null;
//    unselectAllCheckedGroups();
//    //        mSelectedGroupsForAlert.clear();
//    hidePickGroupsForAlert();
//    hidePickAlertTypeForAlert();
//    configureMessageCompositionAreaForAlertCategory(null);
//    clearMessageText();
//    App.hideKeyboard(this.getActivity());
//    mPlusButton.setVisibility(View.VISIBLE);
//    mEditTextLayout.setVisibility(View.GONE);
//    showPostMessageButtons(false);
//    }
    
    func showPickerAlertTypeForAlert() -> Void {
        print("Show alert type picker here")
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
