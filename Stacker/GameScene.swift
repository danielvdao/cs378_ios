//
//  GameScene.swift
//  Stacker
//
//  Created by Daniel Dao on 10/19/15.
//  Copyright (c) 2015 Daniel Dao. All rights reserved.
//

import SpriteKit

var blockNum = 1

class GameScene: SKScene {
    let rowsOfBlocks = 15
    let columnsOfBlocks = 7
    let rightBounds = CGFloat(350)
    let leftBounds = CGFloat(0)
    var blocks:[Block] = []
    var blockSpeed = 0.9
    var curRow = -1
    var currentNumOfBlocks = 5
    var numBlocksError = 0
    let blockWidth = Block(name: "size").size.width
    var curScore = 0
    var fixedPoint = 0
    var dynamicLabel: UILabel = UILabel()
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        dynamicLabel.frame = CGRectMake(50, 150, 200, 21)
        dynamicLabel.backgroundColor = UIColor.orangeColor()
        dynamicLabel.textColor = UIColor.blackColor()
        dynamicLabel.textAlignment = NSTextAlignment.Center
        dynamicLabel.text = "Score: " + String(curScore)
        self.view?.addSubview(dynamicLabel)
        backgroundColor = SKColor.blackColor()
        NSLog("Main screen loaded")
        let pushButton = SKSpriteNode(imageNamed: "blue")
        pushButton.position = CGPointMake(size.width / 2, 100)
        pushButton.name = "PushButton"
        addChild(pushButton)
        NSLog("Push button loaded")
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */
        let touch = touches.first as! UITouch!
        let touchLocation = touch.locationInNode(self)
        let touchedNode = self.nodeAtPoint(touchLocation)
        
        
        if(touchedNode.name == "PushButton"){
            NSLog("Button has been pushed, stop the stack")
            // 1. stop the current block
            setupRow(curRow, currentNumBlocks: currentNumOfBlocks)
            
            // 2. check if the blocks are in line if curRow >= 2
            if (curRow >= 2){
                if (checkBlocks() == false){
                    backgroundColor = SKColor.whiteColor()
                    let view = self.view as SKView!
                    let scene:GameOverScene = GameOverScene()
                    view.presentScene(scene)
                    
                
                    
                }
            }
            
            if(curRow >= 2){
                curScore += 10
                dynamicLabel.text = "Score: " + String(curScore)
            }
        }
        
        if (curScore >= 40){
            let view = self.view as SKView!
            let scene:WinningScene =  WinningScene()
            view.presentScene(scene)
        }
     
    }

    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        moveBlocks()
    }
    
    func setupRow(curRow: Int, currentNumBlocks: Int){
        let numberOfBlocks = currentNumBlocks
        
        for(var i = 0; i < numberOfBlocks; i++){
            let block:Block = Block(name: String(curRow))
            let blockHalfWidth:CGFloat = block.size.width / 2
            let xPositionStart:CGFloat = size.width / 2 + ((block.size.width) + CGFloat(10))
            block.position = CGPoint(x:xPositionStart + ((block.size.width + CGFloat(10)) * (CGFloat(i-1))), y: CGFloat(150 + (20 * curRow)) )
            block.blockRow = curRow
            block.blockColumn = i
            addChild(block)

            
        
        }
        
        self.curRow += 1
        self.currentNumOfBlocks -= 1
        
    }
    
    func checkBlocks() -> Bool{
        var previousBlocks:[SKSpriteNode] = []
        var curBlocks:[SKSpriteNode] = []
        var error = 0
        var hit = 0
        NSLog("in checkBlocks")
        enumerateChildNodesWithName("block" + String(curRow - 2)){node, stop in
            let block = node as! SKSpriteNode
            previousBlocks.append(block)
        
        }
        
        enumerateChildNodesWithName("block" + String(curRow - 1)){node, stop in
            let block = node as! SKSpriteNode
            curBlocks.append(block)
        }
        
        if(curBlocks.count == 0 || previousBlocks.count == 0){
            return true
        }
        
        for(var i = 0; i < curBlocks.count; i++){
            for(var j = 0; j < previousBlocks.count; j++){
                if(abs(previousBlocks[j].position.x - curBlocks[i].position.x) < 20.0){
                    hit += 1
                }
            }
        }
//        
//        if(curBlocks[curBlocks.count-1].position.x > previousBlocks[previousBlocks.count-1].position.x){
//            error = Int( (curBlocks[curBlocks.count-1].position.x + 0.5) - previousBlocks[previousBlocks.count-1].position.x)
//            error = error / Int(blockWidth)
//
//        }
//        
//        if(curBlocks[curBlocks.count-1].position.x < previousBlocks[previousBlocks.count-1].position.x){
//            error = Int( (previousBlocks[previousBlocks.count-1].position.x - 0.5) - curBlocks[curBlocks.count-1].position.x)
//            error = error / Int(blockWidth)
//        }
//        
//        if (error >= curBlocks.count){
//            return false
//        }
//        
//        
//
//        // set the error
//        numBlocksError = error
        
//        if(numBlocksError == curBlocks[curBlocks.count-1]){
//            return false
//        }
        
        if(hit < 1){
            return false
        }
        return true
    }
    
    func moveBlocks(){
        var changeDirection = false
        enumerateChildNodesWithName("block" + String(curRow - 1)) { node, stop in
            
            let block = node as! SKSpriteNode
            let blockHalfWidth = block.size.width/2
         
            block.position.x -= CGFloat(self.blockSpeed)
            if(block.position.x < self.leftBounds + CGFloat(30) || block.position.x > self.rightBounds - blockHalfWidth){
                changeDirection = true
            }

            if (changeDirection == true){
                self.blockSpeed *= -1
                changeDirection = false
            }
            
        }
    }
}