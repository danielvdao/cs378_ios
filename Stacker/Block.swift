//
//  Block.swift
//  Stacker
//
//  Created by Daniel Dao on 10/19/15.
//  Copyright © 2015 Daniel Dao. All rights reserved.
//

import UIKit
import SpriteKit

class Block: SKSpriteNode {
    var blockRow = 0
    var blockColumn = 0
    
    init(name: String){
        let texture = SKTexture(imageNamed: "purple@2x")
        super.init(texture: texture, color: SKColor.clearColor(), size: texture.size())
        self.name = "block" + name
        NSLog(self.name!)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
}
