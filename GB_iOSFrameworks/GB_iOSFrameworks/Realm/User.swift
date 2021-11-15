//
//  User.swift
//  GB_iOSFrameworks
//
//  Created by Igor Potemkin on 09.11.2021.
//

import Foundation
import RealmSwift

class User: Object {
    @Persisted var login: String
    @Persisted var password: String
    
    override static func primaryKey() -> String? {
        return "login"
    }
}
