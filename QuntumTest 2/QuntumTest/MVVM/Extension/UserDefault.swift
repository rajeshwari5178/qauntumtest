//
//  UserDefault.swift
//  QuntumTest
//
//  Created by user245455 on 11/29/23.
//



import Foundation
class Defaults {
    enum Keys: String, CaseIterable {
        case regToken
    
       
       
        
    }
    
    func cleanAllkeys(excepts: [Keys]?) {
        for key in Keys.allCases {
            if excepts?.contains(key) == true {
                continue
            } else {
                UserDefaults.standard.set(nil, forKey: key.rawValue)
                UserDefaults.standard.synchronize()
            }
        }
    }
    //
    var regToken: String {
        get {
            return UserDefaults.standard.object(forKey: Keys.regToken.rawValue) as? String ?? ""
        }
        set (newValue) {
            UserDefaults.standard.set(newValue, forKey: Keys.regToken.rawValue)
            UserDefaults.standard.synchronize()
        }
    }
    
}
