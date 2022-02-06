//
//  Background.swift
//  cyberunner
//
//  Created by Sthefanny Gonzaga on 06/02/22.
//

import Foundation
import SpriteKit

class Background {
    
    private var parent: SKNode
    
    private var bg1: SKNode!
    private var bg2: SKNode!
    private var bg3: SKNode!
    private var bg4: SKNode!
    private var bg5: SKNode!
    
    init(parent: SKNode) {
        self.parent = parent
        
        bg1 = parent.childNode(withName: "bg1") as! SKSpriteNode
        bg2 = parent.childNode(withName: "bg2") as! SKSpriteNode
        bg3 = parent.childNode(withName: "bg3") as! SKSpriteNode
        bg4 = parent.childNode(withName: "bg4") as! SKSpriteNode
        bg5 = parent.childNode(withName: "bg5") as! SKSpriteNode
    }
    
    func update(deltaTime: TimeInterval) {
        bg1.position.x -= GameManager.speed * deltaTime + 0.0
        bg2.position.x -= GameManager.speed * deltaTime + 0.4
        bg3.position.x -= GameManager.speed * deltaTime + 0.8
        bg4.position.x -= GameManager.speed * deltaTime + 1.2
        bg5.position.x -= GameManager.speed * deltaTime + 1.6
        
        if bg1.position.x <= -1192 {
            bg1.position.x += 1192
        }
        if bg2.position.x <= -1192 {
            bg2.position.x += 1192
        }
        if bg3.position.x <= -1192 {
            bg3.position.x += 1192
        }
        if bg4.position.x <= -1192 {
            bg4.position.x += 1192
        }
        if bg5.position.x <= -1192 {
            bg5.position.x += 1192
        }
    }
}
