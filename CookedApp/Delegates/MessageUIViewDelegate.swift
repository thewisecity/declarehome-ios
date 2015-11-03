//
//  MessageUIViewDelegate.swift
//  CookedApp
//
//  Created by Dexter Lohnes on 10/16/15.
//  Copyright © 2015 The Wise City. All rights reserved.
//

protocol MessageUIViewDelegate : UITextFieldDelegate, GroupCheckboxTableViewDelegate {
    var messageTextField: UITextField? {get set}
    var chosenCategory: AlertCategory? {get set}
    var selectedGroups: [Group]? {get set}
    func plusButtonTouched() -> Void
    func alertButtonTouched() -> Void
    func messageButtonTouched() -> Void
    func postNewMessage(messageBody: String?) -> Void
    func postNewAlert(category:AlertCategory, messageBody: String?) -> Void
}