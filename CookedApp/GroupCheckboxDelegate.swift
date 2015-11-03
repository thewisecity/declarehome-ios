//
//  GroupCheckboxDelegate.swift
//  CookedApp
//
//  Created by Dexter Lohnes on 11/3/15.
//  Copyright © 2015 The Wise City. All rights reserved.
//

protocol GroupCheckboxDelegate {
    func groupCheckChanged(cell:GroupCheckboxCell, isChecked: Bool) -> Void
}
