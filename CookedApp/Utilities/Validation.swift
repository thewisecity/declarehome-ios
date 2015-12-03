//
//  Validation.swift
//  CookedApp
//
//  Created by Dexter Lohnes on 10/14/15.
//  Copyright © 2015 The Wise City. All rights reserved.
//

import Foundation

let _MINIMUM_NAME_LENGTH = 2
let _MINIMUM_PHONE_NUMBER_LENGTH = 7

func validateGroupName(name : String?) -> Bool
{
    var isValid = false
    // TODO: Stuff here
    
    if(name?.characters.count > 0){
        isValid = true
    }
    
    
    return isValid
}

func validateGroupPurpose(purpose : String?) -> Bool
{
    var isValid = false
    // TODO: Stuff here
    
    if(purpose?.characters.count > 0){
        isValid = true
    }
    
    return isValid
}

func validateEmail(email : String?) -> Bool
{
    return true
}

func validatePassword(email : String?) -> Bool
{
    // TODO: Implement
    return true
}

func validateDisplayName(displayName : String?) -> Bool
{
    var isValid : Bool = false;
    if let displayName = displayName {
        let trimmedDisplayName = displayName.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        if trimmedDisplayName.characters.count >= _MINIMUM_NAME_LENGTH
        {
            isValid = true
        }
    }
    return isValid;
}

func validatePhoneNumber(phoneNumber : String?) -> Bool
{
    var isValid : Bool = false;
    if let phoneNumber = phoneNumber {
        var trimmedPhoneNumber : String! = phoneNumber.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        trimmedPhoneNumber = trimmedPhoneNumber.stringByTrimmingCharactersInSet(NSCharacterSet.letterCharacterSet())
        trimmedPhoneNumber = trimmedPhoneNumber.stringByTrimmingCharactersInSet(NSCharacterSet.punctuationCharacterSet())
        if(trimmedPhoneNumber.characters.count >= _MINIMUM_PHONE_NUMBER_LENGTH){
            isValid = true
        }
    }
    return true
}
