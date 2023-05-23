//
//  ContentView.swift
//  tower-bloxx
//
//  Created by Kezia Gloria on 18/05/23.
//

import SwiftUI
import SpriteKit

struct PhysicsCategory {
    static let block: UInt32 = 1 << 0
    static let rope: UInt32 = 1 << 1
    static let ground: UInt32 = 1 << 2
}

class GameScene: SKScene, SKPhysicsContactDelegate{
    var ground : SKShapeNode!
    var rope : SKSpriteNode!
    var stickBody: SKPhysicsJointFixed!
    var cornerNode : SKShapeNode!
    var scoreLbl : SKLabelNode!
    var score2Lbl : SKLabelNode!
    var descLbl : SKLabelNode!
    var block: Block!
    var index: Int = 1
    var combo: Int = 0
    var score: Int = 0
    var blockSize: Int = 125
//    var gameOver: Bool = false
    var dropped: Bool = false
    var finGenerate: Bool = false
    var blocks: [Block] = []
    var cities: [SKSpriteNode] = []
    
    @ObservedObject var gameData : GameData
        
    init(size: CGSize, gameData: GameData) {
        self.gameData = gameData
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        self.physicsWorld.gravity = CGVector(dx: 0, dy: -30)
        self.backgroundColor = UIColor(hue: 199/360, saturation: 9/100, brightness: 100/100, alpha: 1.0)
        createSky()
        createGround()
        createRope()
        showScore()
        generateBlock(base: true)
    }
    override func update(_ currentTime: TimeInterval) {
        if index > 2{
            if blocks[index-1].position.y < 0 {
                gameData.gameOver = true
                descLbl.text = "Game Over"
            }
        }
        
        gameData.score = score
        
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let firstNode = contact.bodyA.node
        let secondNode = contact.bodyB.node
        
            if (firstNode == blocks[0] && secondNode == ground) || (firstNode == ground && secondNode == blocks[0]) {
                
                let delayAction = SKAction.wait(forDuration: 0.5)
                let addJointAction = SKAction.run {
                    let joint = SKPhysicsJointFixed.joint(withBodyA: self.blocks[0].physicsBody!, bodyB: self.ground.physicsBody!, anchor: contact.contactPoint)
                    self.physicsWorld.add(joint)
                    self.dropped = false
                }

                let sequenceAction = SKAction.sequence([delayAction, addJointAction])
                run(sequenceAction)
                
            }else if (firstNode == blocks[index-1] && secondNode == ground) || (firstNode == ground && secondNode == blocks[index-1]) {
                gameData.gameOver = true
                descLbl.text = "Game Over"
                
            }else if (firstNode == blocks[index-2] && secondNode == blocks[index-1]) || firstNode == blocks[index-2] && secondNode == blocks[index-1] {
                let delayAction = SKAction.wait(forDuration: 0.7)
                    let addJointAction = SKAction.run {
                        if self.blocks[self.index-1].position.y - self.blocks[self.index-1].size.width/2 > self.blocks[self.index-2].position.y + self.blocks[self.index-2].size.width/2 - 5 && (-1 ... 1).contains(self.blocks[self.index-1].zRotation){
                            self.blocks[self.index-1].zRotation = 0
                            let joint = SKPhysicsJointFixed.joint(withBodyA: self.blocks[self.index-2].physicsBody!, bodyB: self.blocks[self.index-1].physicsBody!, anchor: contact.contactPoint)
                            self.physicsWorld.add(joint)
                            self.dropped = false
                            let moveLeft = SKAction.moveBy(x: -10, y: 0, duration: 1.5)
                            let moveRight = SKAction.moveBy(x: 10, y: 0, duration: 1.5)
                            let rotateSequence = SKAction.sequence([moveLeft, moveRight])
                            let repeatAction = SKAction.repeatForever(rotateSequence)
                            self.blocks[self.index-2].removeAllActions()
                            self.blocks[self.index-1].run(repeatAction)
                        }
                        
                    }

                    let sequenceAction = SKAction.sequence([delayAction, addJointAction])
                    run(sequenceAction)
            }
        }
    
    func showScore(){
        
        
        scoreLbl = SKLabelNode(fontNamed: AppFont.regular)
        scoreLbl.text = "\(score)"
        scoreLbl.fontColor = UIColor(red: 12.0/255.0, green: 46.0/255.0, blue: 69.0/255.0, alpha: 1.0)
        scoreLbl.position = CGPoint(x: size.width*1.5/10, y: size.height*8.4/10)
        scoreLbl.fontSize = 50
        scoreLbl.zPosition = 1
        self.addChild(scoreLbl)
        
        score2Lbl = SKLabelNode(fontNamed: AppFont.regular)
        score2Lbl.text = "Score"
        score2Lbl.fontColor = UIColor(red: 12.0/255.0, green: 46.0/255.0, blue: 69.0/255.0, alpha: 1.0)
        score2Lbl.position = CGPoint(x: size.width*1.5/10, y: size.height*9/10)
        score2Lbl.fontSize = 25
        score2Lbl.zPosition = 1
        self.addChild(score2Lbl)
        
        descLbl = SKLabelNode(fontNamed: AppFont.regular)
        descLbl.fontColor = UIColor(red: 73.0/255.0, green: 75.0/255.0, blue: 90.0/255.0, alpha: 0.5)
        descLbl.text = ""
        descLbl.fontSize = 28
        descLbl.position = CGPoint(x: size.width/2, y: size.height/2)
        self.addChild(descLbl)
    }
    
    func generateBlock(base: Bool){
        block = Block(index: index, isBase: index==1, pos: cornerNode.position, blockSize: blockSize)
        self.addChild(block)
        block.name = "block \(block.index)"
        blocks.append(block)
        
        
        stickBody = SKPhysicsJointFixed.joint(
            withBodyA: block.physicsBody!,
                    bodyB: rope.physicsBody!,
                    anchor: .zero
                )
        self.physicsWorld.add(stickBody)
        finGenerate = true
        
        
    }
    
    func createGround(){
        ground = SKShapeNode(rectOf: CGSize(width: size.width+50, height: 150))
        ground.fillColor = UIColor(hue: 219/360, saturation: 24/100, brightness: 38/100, alpha: 1.0)
        ground.strokeColor = .clear
        ground.position = CGPoint(x: size.width/2, y: 0)
        ground.physicsBody = SKPhysicsBody(rectangleOf: ground.frame.size)
        ground.physicsBody?.isDynamic = false
        ground.physicsBody?.categoryBitMask = PhysicsCategory.ground
        ground.physicsBody?.contactTestBitMask = PhysicsCategory.block
        ground.name = "ground"
        self.addChild(ground)
    }
    
    func configCloud(cloud: SKSpriteNode, move: CGFloat, duration: Double, left: Bool){
        let moveLeft = SKAction.moveBy(x: -move, y: 0, duration: duration)
        let moveRight = SKAction.moveBy(x: move, y: 0, duration: duration)
        let rotateSequence = left ? SKAction.sequence([moveLeft, moveRight]) : SKAction.sequence([moveRight, moveLeft])
        let repeatAction = SKAction.repeatForever(rotateSequence)
        cloud.run(repeatAction)
    }
    
    func createSky(){
        
        let cloud1 = SKSpriteNode(imageNamed: "cloud")
        cloud1.position = CGPoint(x: size.width/3, y: size.height*1.8/3)
        cloud1.setScale(0.12)
        cloud1.alpha = 0.8
        
        let cloud2 = SKSpriteNode(imageNamed: "cloud")
        cloud2.position = CGPoint(x: size.width*3/4, y: size.height*1.1/3)
        cloud2.setScale(0.1)
        
        let cloud3 = SKSpriteNode(imageNamed: "cloud")
        cloud3.position = CGPoint(x: size.width*3/4, y: size.height*2.5/3)
        cloud3.setScale(0.15)
        cloud3.alpha = 0.6
        
        self.addChild(cloud1)
        self.addChild(cloud2)
        self.addChild(cloud3)
        
        configCloud(cloud: cloud1, move: 50, duration: 5.0, left: true)
        configCloud(cloud: cloud2, move: 100, duration: 8.0, left: false)
        configCloud(cloud: cloud3, move: 25, duration: 3.0, left: true)
        
        let moveLeft = SKAction.moveBy(x: -50, y: 0, duration: 5.0)
        let moveRight = SKAction.moveBy(x: 50, y: 0, duration: 5.0)
        let rotateSequence = SKAction.sequence([moveLeft, moveRight])
        let repeatAction = SKAction.repeatForever(rotateSequence)
        cloud1.run(repeatAction)
        
        let city3 = SKSpriteNode(imageNamed: "city3")
        city3.position = CGPoint(x: size.width/2, y: size.height/2.25)
        city3.setScale(0.12)
        self.addChild(city3)
        
        let city2 = SKSpriteNode(imageNamed: "city2")
        city2.position = CGPoint(x: size.width/2, y: size.height/2.25)
        city2.setScale(0.12)
        self.addChild(city2)
        
        let city1 = SKSpriteNode(imageNamed: "city1")
        city1.position = CGPoint(x: size.width/2, y: size.height/2.25)
        city1.setScale(0.12)
        self.addChild(city1)
        
        cities = [city1, city2, city3]
        
        
    }
    
    func createRope(){
        rope = SKSpriteNode(imageNamed: "rope")
        rope.name = "rope"
        rope.scale(to: CGSize(width: size.height/1.8, height: size.height/1.8))
        rope.position = CGPoint(x: size.width/2, y: size.height)
        rope.physicsBody = SKPhysicsBody(rectangleOf: rope.frame.size)
        rope.zRotation = CGFloat.pi / 4
        rope.physicsBody?.isDynamic = false
        rope.physicsBody?.categoryBitMask = PhysicsCategory.rope
        rope.physicsBody?.collisionBitMask = 0
        rope.physicsBody?.contactTestBitMask = 0
        self.addChild(rope)
        
        cornerNode = SKShapeNode(rectOf: CGSize(width: 10, height: 10))
        cornerNode.fillColor = .clear
        cornerNode.position = CGPoint(
            x: rope.position.x + 200,
            y: rope.position.y - 200
        )
        cornerNode.physicsBody = SKPhysicsBody(rectangleOf: cornerNode.frame.size)
        cornerNode.physicsBody?.categoryBitMask = PhysicsCategory.rope
        cornerNode.physicsBody?.collisionBitMask = 0
        cornerNode.physicsBody?.contactTestBitMask = 0
        self.addChild(cornerNode)
        
        
        let rotateLeftAction = SKAction.rotate(byAngle: CGFloat.pi/2.5, duration: 2.5)
        let rotateRightAction = SKAction.rotate(byAngle: -CGFloat.pi/2.5, duration: 2.5)
        let rotateSequence = SKAction.sequence([rotateRightAction, rotateLeftAction])
        let repeatAction = SKAction.repeatForever(rotateSequence)
        rope.run(repeatAction)


        let stick = SKPhysicsJointFixed.joint(
            withBodyA: cornerNode.physicsBody!,
            bodyB: rope.physicsBody!,
            anchor: cornerNode.position
        )
        self.physicsWorld.add(stick)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if finGenerate{
            dropped = true
            finGenerate = false
            self.block.zRotation = 0
            self.physicsWorld.remove(stickBody)
            let delayAction = SKAction.wait(forDuration: 2.5)
            self.run(delayAction) { [self] in
                if blocks[index-1].position.y >= size.height/5 && !gameData.gameOver{
                    let moveAction = SKAction.moveBy(x: 0, y: -110, duration: 2.0)
                    self.ground.run(moveAction)
                    self.cities[0].run(moveAction)
                    self.cities[1].run(moveAction)
                    self.cities[2].run(moveAction)
                }
                
                if !dropped{
                    self.index += 1
                    if self.index == 2{
                        descLbl.text = "+10"
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                            self.descLbl.text = ""
                        }
                        self.score += 10
                        self.combo = 0
                    }else if (self.blocks[index-3].position.x-1 ... self.blocks[index-3].position.x+1).contains(block.position.x){
                        self.combo += 1
                        descLbl.text = "Combo \(self.combo)x"
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                            self.descLbl.text = ""
                        }
                        self.score += 5 * combo
                    }else if (self.blocks[index-3].position.x-10 ... self.blocks[index-3].position.x+10).contains(block.position.x){
                        descLbl.text = "+3"
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                            self.descLbl.text = ""
                        }
                        self.score += 3
                        self.combo = 0
                    }else{
                        descLbl.text = "+1"
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                            self.descLbl.text = ""
                        }
                        self.score += 1
                        self.combo = 0
                    }
                    
                    if index % 5 == 0 {
                        descLbl.text = "Level Up!"
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                            self.descLbl.text = ""
                        }
                        rope.zRotation = CGFloat.pi / 4
                        cornerNode.position = CGPoint(
                            x: rope.position.x + 200,
                            y: rope.position.y - 200
                        )
                        let duration = 2.0 - (Double(index) / 20) > 1.0 ? 2.0 - (Double(index) / 20) : 1.0
                        blockSize = blockSize - index/5 * 5 > 70 ? blockSize - index/5 * 5 : 70
                        rope.removeAllActions()
                        let newRotateLeftAction = SKAction.rotate(byAngle: CGFloat.pi/2.5, duration: duration)
                        let newRotateRightAction = SKAction.rotate(byAngle: -CGFloat.pi/2.5, duration: duration)
                        let newRotateSequence = SKAction.sequence([newRotateRightAction, newRotateLeftAction])
                        let newRepeatAction = SKAction.repeatForever(newRotateSequence)
                        rope.run(newRepeatAction)
                    }
                    
                    scoreLbl.text = "\(score)"
                    if !gameData.gameOver && !finGenerate{
                        self.generateBlock(base: false)
                    }
                }
            }
        }
    }
}

class GameData: ObservableObject {
    @Published var score: Int = 0
    @Published var gameOver: Bool = false
}

struct GameView: View {
    @State var mc : MusicController
    @StateObject var gameData = GameData()
    var body: some View {
        NavigationView {
            ZStack{
                GeometryReader { geometry in
                    SpriteView(scene: GameScene(size: CGSize(width: geometry.size.width, height: geometry.size.height), gameData: gameData), options: [.allowsTransparency])
                }
                
                if gameData.gameOver{
                    Popup(mc: mc, score: gameData.score)
                }
            }.ignoresSafeArea()
        }.navigationBarBackButtonHidden(true)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        GameView(mc: MusicController())
    }
}
