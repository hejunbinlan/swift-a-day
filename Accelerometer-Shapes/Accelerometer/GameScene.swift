//
//  GameScene.swift
//  Accelerometer
//
//  Created by Linda Dong on 5/26/15.
//  Copyright (c) 2015 Linda Dong. All rights reserved.
//

import SpriteKit
import CoreMotion

extension Array {
    func sample() -> T {
        let randomIndex = Int(rand()) % count
        return self[randomIndex]
    }
}
class GameScene: SKScene, SKPhysicsContactDelegate {
    
    let motionManager: CMMotionManager = CMMotionManager()
    let colorArray = [ SKColor(red: 0 / 255, green: 64 / 255, blue: 170 / 240, alpha: 1 ),
        SKColor(red: 255 / 255, green: 250 / 255, blue: 233 / 240, alpha: 1 ),
        SKColor(red: 245 / 255, green: 122 / 255, blue: 99 / 240, alpha: 1 )]
    
    override func didMoveToView(view: SKView) {
        let borderBody = SKPhysicsBody(edgeLoopFromRect: self.frame)
        
        borderBody.friction = 0
        
        self.physicsBody = borderBody
        
        self.physicsWorld.gravity = CGVectorMake(0, 0)
        self.physicsWorld.contactDelegate = self
        self.physicsBody?.contactTestBitMask =  0
        
        self.backgroundColor = SKColor(red: 255 / 255, green: 191 / 255, blue: 180 / 240, alpha: 1 )
        
        let maxShapes = 15
        for i in 0..<maxShapes {
            self.addChild(self.createRandomShape())
        }
        
        motionManager.startAccelerometerUpdates()
    
    }
    
    
    func createRandomShape() -> SKSpriteNode {
        var pointX = CGFloat(UInt(arc4random() % UInt32(UInt(self.frame.width - 100))))
        var pointY = CGFloat(UInt(arc4random() % UInt32(UInt(self.frame.height - 100))))
        var randomShape = String("")
        
        let shapes = ["triangle", "squiggle", "circle"]
        let randomIndex = Int(arc4random_uniform(UInt32(shapes.count)))

        let shape = SKSpriteNode(imageNamed: shapes[randomIndex])
        shape.position = CGPointMake(pointX, pointY)
        shape.name = "shape"
        
        shape.color = colorArray.sample()
        shape.colorBlendFactor = 1.0
        
        shape.physicsBody =  SKPhysicsBody(texture: shape.texture, size: shape.size)
        shape.physicsBody?.dynamic = true
        shape.physicsBody?.restitution = 0.5
        shape.physicsBody?.mass = 0.9
        shape.physicsBody?.linearDamping = 0.1
        shape.physicsBody?.angularDamping = 0.1
        shape.physicsBody?.friction = 0
        
        return shape
    }
    
    func processUserMotionForUpdate(currentTime: CFTimeInterval) {
        
        if let data = motionManager.accelerometerData {
            self.physicsWorld.gravity = CGVectorMake(10 * CGFloat(data.acceleration.x), 10 * CGFloat(data.acceleration.y))
            
        }
    }
    
    override func didSimulatePhysics() {
        self.enumerateChildNodesWithName("shape", usingBlock: { (node: SKNode!, stop: UnsafeMutablePointer<ObjCBool>) -> Void in
            if node.position.y < 10 || node.position.x < 10 {
                node.removeFromParent()
            }
        })
    }
   
    override func update(currentTime: CFTimeInterval) {
        processUserMotionForUpdate(currentTime)
    }
    
    
}
