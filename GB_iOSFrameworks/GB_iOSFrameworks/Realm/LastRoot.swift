//
//  LastRoot.swift
//  GB_iOSFrameworks
//
//  Created by Igor Potemkin on 08.11.2021.
//

import Foundation
import GoogleMaps
import RealmSwift

class LastRoot: Object {
    @Persisted var rootCoordinates = List<LastRootPoint>()
}

class LastRootPoint: Object {
    @Persisted var lat: Double?
    @Persisted var long: Double?
}
