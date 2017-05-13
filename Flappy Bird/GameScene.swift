//
//  GameScene.swift
//  Flappy Bird
//
//  Created by Jerry Shi on 12/12/15.
//  Copyright (c) 2015 jerryszp. All rights reserved.
//
import UIKit
import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var score = 0
    
    var scoreLabel = SKLabelNode()
    
    var gameoverLabel = SKLabelNode()
    
    var bird = SKSpriteNode()
    
    var bg = SKSpriteNode()
    
    var pipe1 = SKSpriteNode()
    
    var pipe2 = SKSpriteNode()
    
    var labelContainer = SKSpriteNode()
    
    var movingObjects = SKSpriteNode()
    
    enum ColliderType: UInt32 {
        case bird = 1
        case object = 2
        case gap = 4
    }
    
    var gameOver = false
    
    func makebg() {
        
        let bgTexture = SKTexture(imageNamed: "bg.png") //background image
        
        let movebg = SKAction.moveBy(x: -bgTexture.size().width, y: 0, duration: 9)
        
        let replacebg = SKAction.moveBy(x: bgTexture.size().width, y: 0, duration: 0)
        
        let movebgForever = SKAction.repeatForever(SKAction.sequence([movebg, replacebg]))
        
        for a in 0...3 {
            
            let i: CGFloat = CGFloat(a)
            
            bg.run(movebgForever)
            
            bg = SKSpriteNode(texture: bgTexture)
            
            bg.position = CGPoint(x: bgTexture.size().width/2 + bgTexture.size().width * i, y: self.frame.midY)
            
            bg.size.height = self.frame.height
            
            movingObjects.addChild(bg)
            
        }

        
    }
    
    override func didMove(to view: SKView) {
        
        self.physicsWorld.contactDelegate = self
        
        self.addChild(movingObjects)
        self.addChild(labelContainer)
        
        makebg()
        
        scoreLabel.fontName = "Helvetica"
        scoreLabel.fontSize = 60
        scoreLabel.text = "0"
        scoreLabel.position = CGPoint(x: self.frame.midX, y: self.frame.size.height - 70)
        self.addChild(scoreLabel)
        
        
        
        
        let birdTexture1 = SKTexture(imageNamed: "flappy1.png")
        let birdTexture2 = SKTexture(imageNamed: "flappy2.png")
        
        let animation = SKAction.animate(with: [birdTexture1, birdTexture2], timePerFrame: 0.1)
        
        let makeBirdFlap = SKAction.repeatForever(animation)
        
        bird = SKSpriteNode(texture: birdTexture1)
        
        bird.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        
        bird.run(makeBirdFlap)
        
        bird.physicsBody = SKPhysicsBody(circleOfRadius: birdTexture1.size().height / 2)
        
        bird.physicsBody!.isDynamic = true
        bird.physicsBody!.allowsRotation = false
        
        bird.physicsBody!.categoryBitMask = ColliderType.bird.rawValue
        bird.physicsBody!.contactTestBitMask = ColliderType.object.rawValue
        bird.physicsBody!.collisionBitMask = ColliderType.object.rawValue
        
        self.addChild(bird)
        
        var ground = SKNode()
        ground.position = CGPoint(x: 0, y: 0)
        ground.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.frame.size.width, height: 1))
        ground.physicsBody?.isDynamic = false
        
        ground.physicsBody!.categoryBitMask = ColliderType.object.rawValue
        ground.physicsBody!.contactTestBitMask = ColliderType.object.rawValue
        ground.physicsBody!.collisionBitMask = ColliderType.object.rawValue
        
        self.addChild(ground)
        
        _ = Timer.scheduledTimer(timeInterval: 3, target: self, selector: Selector("makePipes"), userInfo: nil, repeats: true)
        
    
    }
   
    func makePipes() {
        
        let gapHeight = bird.size.height * 4
        
        let movementAmount = arc4random() % UInt32(self.frame.size.height / 2)
        
        let pipeOffset = CGFloat(movementAmount) - self.frame.size.height/4
        
        let movePipes = SKAction.moveBy(x: -self.frame.size.width * 2, y: 0, duration: TimeInterval(self.frame.size.width) / 100)
        
        let removePipes = SKAction.removeFromParent()
        
        let moveAndRemovePipes = SKAction.sequence([movePipes, removePipes])
        
        
        var pipeTexture = SKTexture(imageNamed: "pipe1.png")
        
        var pipe1 = SKSpriteNode(texture: pipeTexture)
        
        var PipeDis1 = pipeTexture.size().height/2
        
        var PipeMove = self.frame.size.width
        
        pipe1.position = CGPoint(x: self.frame.midX + PipeMove, y: self.frame.midY + PipeDis1 + gapHeight/2 + pipeOffset)
        
        pipe1.run(moveAndRemovePipes)
        
        pipe1.physicsBody = SKPhysicsBody(rectangleOf: pipeTexture.size()) //pipe collision setup
        
        pipe1.physicsBody!.isDynamic = false
        
        pipe1.physicsBody!.categoryBitMask = ColliderType.object.rawValue
        pipe1.physicsBody!.contactTestBitMask = ColliderType.object.rawValue
        pipe1.physicsBody!.collisionBitMask = ColliderType.object.rawValue
        
        movingObjects.addChild(pipe1)
        
        var pipe2Texture = SKTexture(imageNamed: "pipe2.png")
        
        var pipe2 = SKSpriteNode(texture: pipe2Texture)
        
        var PipeDis2 = pipe2Texture.size().height/2
        
        pipe2.position = CGPoint(x: self.frame.midX + PipeMove, y: self.frame.midY - PipeDis2 - gapHeight/2 + pipeOffset)
        
        pipe2.run(moveAndRemovePipes)
        
        pipe2.physicsBody = SKPhysicsBody(rectangleOf: pipe2Texture.size()) //pipe collision setup
        
        pipe2.physicsBody!.isDynamic = false
        
        pipe2.physicsBody!.categoryBitMask = ColliderType.object.rawValue
        pipe2.physicsBody!.contactTestBitMask = ColliderType.object.rawValue
        pipe2.physicsBody!.collisionBitMask = ColliderType.object.rawValue
        
        movingObjects.addChild(pipe2)
        
        var gap = SKNode()
        gap.position = CGPoint(x: self.frame.midX + PipeMove, y: self.frame.midY + pipeOffset)
        
        gap.run((moveAndRemovePipes))
        
        gap.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: pipe1.size.width, height: gapHeight))
        gap.physicsBody!.isDynamic = false
        
        gap.physicsBody!.categoryBitMask = ColliderType.gap.rawValue
        gap.physicsBody!.contactTestBitMask = ColliderType.bird.rawValue
        gap.physicsBody!.collisionBitMask = ColliderType.gap.rawValue
        
        movingObjects.addChild(gap)
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        if contact.bodyA.categoryBitMask == ColliderType.gap.rawValue || contact.bodyB.categoryBitMask == ColliderType.gap.rawValue {
            
            score += 1
            
            scoreLabel.text = String(score)
            
        }else{
            
            if gameOver == false {
                
                gameOver = true
                
                self.speed = 0
                
                gameoverLabel.fontName = "Helvetica"
                gameoverLabel.fontSize = 30
                gameoverLabel.text = "try again"
                gameoverLabel.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
                labelContainer.addChild(gameoverLabel)
                
            }
            
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
       /* Called when a touch begins */
        
        if gameOver == false {
            
            bird.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            
            bird.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 70))
            
        }else{
            
            score = 0
            
            scoreLabel.text = "0"
            
            bird.position = CGPoint(x: self.frame.midX, y: self.frame.midY)

            bird.physicsBody!.velocity = CGVector(dx: 0,dy: 0)
            
            movingObjects.removeAllChildren()
            
            makebg()
            
            self.speed = 1
            
            gameOver = false
            
            labelContainer.removeAllChildren()
        }
       
    }
   
    override func update(_ currentTime: TimeInterval) {
        /* Called before each frame is rendered */
        
        
        
    }
}















