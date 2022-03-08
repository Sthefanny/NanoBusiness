//
//  Heros.swift
//  cyberunner
//
//  Created by Ana C S Costa on 25/02/22.
//

import Foundation
import UIKit

class Hero {
    var name : String
    var image : UIImage
    var price : Float
    var locked : Bool
    
    init (name: String, imageName: String, price: Float, locked: Bool) {
        self.name = name
        self.image = UIImage(named: imageName)!
        self.price = price
        self.locked = locked
    }
}
