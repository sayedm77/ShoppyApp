//
//  SettingsViewModel.swift
//  ShopyApp
//
//  Created by sayed mansour on 25/09/2024.
//

import Foundation
class SettingsViewModel{
    
    let settingsList = ["Addresses", "Currency", "About Us"]
    var userDefult : Utilities?
    
    init() {
        self.userDefult = Utilities()
    }

    func isLoggedIn()->Bool{
        return userDefult?.isLoggedIn() ?? false
    }
    
    func logUserOut(){
        userDefult?.logout()
    }
        
}
