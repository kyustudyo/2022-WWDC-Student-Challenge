

import Foundation
import SceneKit

enum PlayerAnimationType {
    
    case walk, attack1, dead
}

class Player:SCNNode {
    
    //nodes
    private var daeHolderNode = SCNNode()
    private var characterNode:SCNNode!
    private var collider:SCNNode!
    private var weaponCollider:SCNNode!
 
    //animations
    private var walkAnimation = CAAnimation()
    private var attack1Animation = CAAnimation()
    private var deadAnimation = CAAnimation()
    
    //movement
    private var previousUdateTime = TimeInterval(0.0)
    
    private var isWalking:Bool = false {
        
        didSet {
            
            if oldValue != isWalking {
                
                if isWalking {
                    
                    characterNode.addAnimation(walkAnimation, forKey: "walk")
            
                } else {
                    
                    characterNode.removeAnimation(forKey: "walk", blendOutDuration: 0.2)
                }
            }
        }
    }
    
    private var directionAngle:Float = 0.0 {
        
        didSet {
            
            if directionAngle != oldValue {
                
                runAction(SCNAction.rotateTo(x: 0.0, y: CGFloat(directionAngle), z: 0.0, duration: 0.1, usesShortestUnitArc: true))
            }
        }
    }
    
    var replacementPosition:SCNVector3 = SCNVector3Zero
    private var activeWeaponCollideNodes = Set<SCNNode>()
    
    //battle
    var isDead = false
    private let maxHpPoints:Float = 105
    private var hpPoints:Float = 0
    var isAttacking = false
    private var attackTimer:Timer?
    private var attackFrameCounter = 0
    
    //MARK:- initialization
    override init() {
        super.init()
        
        setupModel()
        loadAnimations()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK:- scene
    private func setupModel() {
        //load dae childs
        var playerScene = SCNScene()
        let paths = Bundle.main.paths(forResourcesOfType: "scn", inDirectory: nil)
        for path in paths {
            if path.contains("inplaceWalk") {
                do {
                    playerScene = try SCNScene(url: URL(fileURLWithPath: path),options: nil)
                } catch {
                    print("no wall")
                }
            }
        }
        for child in playerScene.rootNode.childNodes {
            daeHolderNode.addChildNode(child)
        }
        addChildNode(daeHolderNode)
        characterNode = daeHolderNode
        
        characterNode.scale = SCNVector3(x: 70, y: 70, z: 70)
        
        
    }

    private func loadAnimations() {
        loadAnimation(animationType: .walk, inSceneNamed: "inplaceWalk", withIdentifier: "unnamed_animation__0")
    }
    
    private func loadAnimation(animationType:PlayerAnimationType, inSceneNamed scene:String, withIdentifier identifier:String) {
        let sceneURL = Bundle.main.url(forResource: scene, withExtension: "scn")!
        let sceneSource = SCNSceneSource(url: sceneURL, options: nil)!
        let animationObject:CAAnimation = animationFromSceneNamed(path: "Sd")!

        animationObject.delegate = self
        animationObject.fadeInDuration = 0.2
        animationObject.fadeOutDuration = 0.2
        animationObject.usesSceneTimeBase = false
        animationObject.repeatCount = 0
        
        switch animationType {
            
        case .walk:
            
            animationObject.repeatCount = Float.greatestFiniteMagnitude
            walkAnimation = animationObject
            
        case .dead:
            
            animationObject.isRemovedOnCompletion = false
            deadAnimation = animationObject
            
        case .attack1:
            
            animationObject.setValue("attack1", forKey: "animationId")
            attack1Animation = animationObject
        }
    }
    
    //MARK:- movement
    func walkInDirection(_ direction:float3, time:TimeInterval, scene:SCNScene) {
        
        if isDead || isAttacking { return }
        
        if previousUdateTime == 0.0 { previousUdateTime = time }
        
        let deltaTime = Float(min(time-previousUdateTime, 1.0/60.0))
        let characterSpeed = deltaTime * 13//13
        previousUdateTime = time
        
        let initialPosition = position
        
        //move
        if direction.x != 0.0 && direction.z != 0.0 {
            
            //move character
            let pos = float3(position)
            position = SCNVector3(pos+direction * characterSpeed)
            
            //update angle
            directionAngle = SCNFloat(atan2f(direction.x, direction.z))
            
            isWalking = true
            
        } else {
            
            isWalking = false
        }
        
        //update altidute
        var pos = position
        var endpoint0 = pos
        var endpoint1 = pos
        
        endpoint0.y -= 5
        endpoint1.y += 5
        
        let results = scene.physicsWorld.rayTestWithSegment(from: endpoint1, to: endpoint0, options: [.collisionBitMask: BitmaskWall, .searchMode: SCNPhysicsWorld.TestSearchMode.closest])
        
        if let result = results.first {
            
            let groundAltidute = result.worldCoordinates.y
            pos.y = groundAltidute
            
            position = pos
      
        } else {
            
            position = initialPosition
        }
    }
    
    //MARK:- collisions
    func setupCollider(with scale:CGFloat) {//
        
        let geometry = SCNCapsule(capRadius: 2, height: 10)//통증
        geometry.firstMaterial?.diffuse.contents = UIColor.red
        
        collider = SCNNode(geometry: geometry)
        collider.position = SCNVector3Make(0.0, 12.41, 0.0)
        collider.name = "collider"
        collider.opacity = 0
        
        let physicsGeometry = SCNCapsule(capRadius: 2*scale, height: 10*scale)//생긴거
        let physicsShape = SCNPhysicsShape(geometry: physicsGeometry, options: nil)
        collider.physicsBody = SCNPhysicsBody(type: .kinematic, shape: physicsShape)
        collider.physicsBody!.categoryBitMask = BitmaskPlayer
        collider.physicsBody!.contactTestBitMask = BitmaskWall//이거없앤다고 계단못올라가는거아님
        addChildNode(collider)
    }
    
    func weaponCollide(with node:SCNNode) {
        
        activeWeaponCollideNodes.insert(node)
    }
    
    func weaponUnCollide(with node:SCNNode) {
        
        activeWeaponCollideNodes.remove(node)
    }
    
    func gotHit(with hpPoints:Float) {
//        print("gothit")
        self.hpPoints += hpPoints
        print("hp\(self.hpPoints)")
        NotificationCenter.default.post(name: NSNotification.Name("hpChanged"), object: nil, userInfo: ["playerMaxHp":maxHpPoints, "currentHp":self.hpPoints])
        
        if self.hpPoints >= 105{
            
            die()
        }
    }
    
    private func die() {
        
        isDead = true
        characterNode.removeAllActions()
        characterNode.removeAllAnimations()
        characterNode.addAnimation(deadAnimation, forKey: "dead")
    }
    
    func attack1() {
        
        if isAttacking || isDead { return }
        
        isAttacking = true
        isWalking = false
        
        attackTimer = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(attackTimerTicked), userInfo: nil, repeats: true)
        
        characterNode.removeAllAnimations()
        characterNode.addAnimation(attack1Animation, forKey: "attack1")
    }
    
    @objc private func attackTimerTicked(timer:Timer) {
        
        attackFrameCounter += 1
        
        if attackFrameCounter == 12 {
            
            for node in activeWeaponCollideNodes {
                
                if let golem = node as? Zombie {
                    
                    golem.gotHit(by: node, with: 30.0)
                }
            }
        }
    }
    
    func setupWeaponCollider(with scale:CGFloat) {
        
        let geometryBox = SCNBox(width: 160.0, height: 140.0, length: 160.0, chamferRadius: 0.0)
        geometryBox.firstMaterial?.diffuse.contents = UIColor.orange
        weaponCollider = SCNNode(geometry: geometryBox)
        weaponCollider.name = "weaponCollider"
        weaponCollider.position = SCNVector3Make(-10, 108.4, 88)
        weaponCollider.opacity = 0.0
        addChildNode(weaponCollider)
        
        let geometry = SCNBox(width: 160.0 * scale, height: 140.0 * scale, length: 160.0 * scale, chamferRadius: 0.0)
        let physicsShape = SCNPhysicsShape(geometry: geometry, options: nil)
        weaponCollider.physicsBody = SCNPhysicsBody(type: .kinematic, shape: physicsShape)
        weaponCollider.physicsBody!.categoryBitMask = BitmaskPlayerWeapon
        weaponCollider.physicsBody!.contactTestBitMask = BitmaskGolem
    }

}

//MARK:- extensions

extension Player: CAAnimationDelegate {
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        
        guard let id = anim.value(forKey: "animationId") as? String else { return }
        
        if id == "attack1" {
            
            attackTimer?.invalidate()
            attackFrameCounter = 0
            isAttacking = false
        }
    }
}

func animationFromSceneNamed(path: String) -> CAAnimation? {
    
    
    var playerScene = SCNScene()
        let paths = Bundle.main.paths(forResourcesOfType: "scn", inDirectory: nil)
        for path in paths {
            if path.contains("inplaceWalk") {
                do {
                    playerScene = try SCNScene(url: URL(fileURLWithPath: path),options: nil)

                } catch {
                    print("no wall")
                }
            }
        }

    
//    let scene  = SCNScene(named: path)
    let scene: SCNScene? = playerScene
    var animation:CAAnimation?
    scene?.rootNode.enumerateChildNodes({ child, stop in
        if let animKey = child.animationKeys.first {
            print("animkey: \(animKey)")
            animation = child.animation(forKey: animKey)
            stop.pointee = true
        }
    })
    return animation
}

