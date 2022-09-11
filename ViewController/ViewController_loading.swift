//
//  LoadingViewController.swift
//  wwwdc
//
//  Created by Hankyu Lee on 2022/04/16.
//

import Foundation
import UIKit
import SceneKit


class LoadingViewController: UIViewController {

    var gameView : GameView!
    var mainScene:SCNScene!
    //general
    var gameState:GameState = .loading
    //nodes
    private var player:Player?
    private var player2: Player?
    private var cameraStick:SCNNode!
    private var cameraXHolder:SCNNode!
    private var cameraYHolder:SCNNode!
    private var lightStick:SCNNode!
    var emptyNode = SCNNode()
    var goingToSetUpEnemy:Bool = true
    var finalCameraNode:SCNNode!
    //movement
    private var controllerStoredDirection = float2(0.0)
    private var padTouch:UITouch?
    private var cameraTouch:UITouch?
    var didRotate = false
    var firstMent = false
    var button  = UIButton()

    private var maxPenetrationDistance = CGFloat(0.0)
    private var replacementPositions = [SCNNode:SCNVector3]()
    
    private var golemsPositionArray = [String:SCNVector3]()
    private var peoplePositionArray = [String:SCNVector3]()
    private var specialPositionArray = [String:SCNVector3]()
    deinit {

        NotificationCenter.default.removeObserver(self)
    }
    @objc private func hpDidChange(notification:Notification) {

        guard let userInfo = notification.userInfo as? [String:Any], let endLoading = userInfo["endLoading"] as? Bool else { return }
        if endLoading == true {
            getButton()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(hpDidChange), name: NSNotification.Name("endLoading"), object: nil)

        setupScene()
        setupPlayer()
        setupPlayer2()
        setupCamera()
        setupLight()
        setupWallBitmasks()
        
        if goingToSetUpEnemy{
            setupEnemies()
        }
        gameState = .playing
    }

    override var shouldAutorotate: Bool { return true }

    override var prefersStatusBarHidden: Bool { return true }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    func getLoadingLabel(string:String){
        DispatchQueue.main.async {
            let label = UILabel()
            label.textColor = UIColor.white
            label.font = UIFont(name: "HelveticaNeue-ThinItalic", size: 40)
            label.text = string
            label.sizeToFit()
            label.center.x = 200
            label.frame.origin.y = self.view.bounds.height - 300
            if self.goingToSetUpEnemy {
                label.blinkFast()
            }
            
            self.gameView!.addSubview(label)
        }
        
    }
    func getButton(){
        print("endendend")
        SCNTransaction.begin()
        SCNTransaction.animationDuration = 5
        let vc = LightViewController()
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true)
        SCNTransaction.commit()
    }

    func addButton(ment:String){

        DispatchQueue.main.async {
            self.button.tintColor = UIColor.white
            self.button.setTitle("\(ment)", for: .normal)
            self.button.titleLabel?.font = UIFont(name: "HelveticaNeue-ThinItalic", size: 30)
            self.button.sizeToFit()
            self.button.titleLabel?.blinkFast()
            self.button.addTarget(self, action: #selector(self.didPressBack), for: .touchUpInside)
            self.button.center.x = 150
            self.button.frame.origin.y = self.view.bounds.height - 200
            self.gameView!.addSubview(self.button)
        }
    }
    
    //MARK:- scene
    private func setupScene() {

        gameView = GameView()
        gameView.customWidth = UIScreen.main.bounds.width
        gameView.awakeFromNib()
        gameView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        gameView.antialiasingMode = .multisampling4X
        gameView.delegate = self
        gameView.allowsCameraControl = false
        let paths = Bundle.main.paths(forResourcesOfType: "scn", inDirectory: nil)
        print(paths)
        for path in paths {
            if path.contains("stage3") {
                do {
                mainScene = try SCNScene(url: URL(fileURLWithPath: path),options: nil)
                } catch {
                    print("no wall")
                }
            }
        }

        mainScene.physicsWorld.contactDelegate = self
        gameView.delegate = self
        gameView.scene = mainScene
        gameView.isPlaying = true
        if goingToSetUpEnemy {
            mainScene.rootNode.childNode(withName: "floor", recursively: false)!.runAction(SCNAction.fadeOpacity(to: 1, duration: 1)){
                self.getLoadingLabel(string: "Now loading....")
            }
        }
        else if !goingToSetUpEnemy {
            mainScene.rootNode.childNode(withName: "floor", recursively: false)!.runAction(SCNAction.fadeOpacity(to: 1, duration: 1.6)){
                self.getLoadingLabel(string: "             Airpod..?")
            }
        }
        
        view = gameView//view.addsubview 대신 이렇게 하니까 hp, dpad 등이 뜨네.
        
        if !goingToSetUpEnemy {
            DispatchQueue.main.async {
                self.button.tintColor = UIColor.white
                self.button.setTitle("", for: .normal)
                self.button.titleLabel?.font = UIFont(name: "HelveticaNeue-ThinItalic", size: 30)
                self.button.titleLabel?.blinkFast()
                self.button.addTarget(self, action: #selector(self.didPressBack), for: .touchUpInside)
                self.button.center.x = 150
                self.button.frame.origin.y = self.view.bounds.height - 200
                self.gameView!.addSubview(self.button)
            }
                self.mainScene.rootNode.childNode(withName: "floor", recursively: false)!.runAction(SCNAction.fadeOpacity(to: 1, duration: 1))
                {
                    DispatchQueue.main.async {
                self.button = UIButton(type: .system)
                self.button.tintColor = UIColor.white
                self.button.titleLabel?.font = UIFont(name: "HelveticaNeue-ThinItalic", size: 30)
                self.button.titleLabel?.blink()
                self.button.setTitle("um...", for: .normal)
                self.button.sizeToFit()
                self.button.addTarget(self, action: #selector(self.didPressBack), for: .touchUpInside)
                self.button.center.x = 150
                self.button.frame.origin.y = self.view.bounds.height - 200
                self.gameView!.addSubview(self.button)
                    }
            }
        }
    }
    @objc func didPressBack (sender: UIButton!) {
        DispatchQueue.main.async {
            self.button.removeFromSuperview()
        }
        if !firstMent {
            firstMent = true
            GameSound.getthird_0(finalCameraNode)
            mainScene.rootNode.childNode(withName: "target", recursively: false)!.runAction(SCNAction.rotateBy(x: 0, y: 0, z: 0, duration: 3.2)){
                self.addButton(ment: "Next")
            }
            
        }
        else if !didRotate {
            didRotate = true
            GameSound.gethird_1(finalCameraNode)
            rotateByOrgin()
            let act = SCNAction.rotateBy(x: 0, y: 0, z: 0, duration: 1)
           
            SCNNode().runAction(act){
                self.addButton(ment: "Next page")
            }
            
        }
        else if didRotate {
            print("viewcontroller")
            let vc = ViewController()
            vc.modalPresentationStyle = .overFullScreen
            vc.isFinalVC = true
            self.present(vc, animated: true)
        }
    }
    func rotateByOrgin(){
        
        var scene = SCNScene()
        let paths = Bundle.main.paths(forResourcesOfType: "scn", inDirectory: nil)

        print(paths)
        for path in paths {
            if path.contains("stage3") {
                do {
                    scene = try SCNScene(url: URL(fileURLWithPath: path),options: nil)
                } catch {
                    print("no wall")
                }
            }
        }
        SCNTransaction.begin()
        SCNTransaction.animationDuration = 3.7
        SCNTransaction.completionBlock = {
            self.addButton(ment: "Next")
        }
        let ang = toRadians(angle: Float(-25))
        let scnQuat = SCNQuaternion(0, ang, 0, 1)
        finalCameraNode.rotate(by: scnQuat, aroundTarget: SCNVector3(0,0,0))
        SCNTransaction.commit()
    }
    //MARK:- player
    private func setupPlayer() {
        player = Player()
        player!.scale = SCNVector3Make(0.26, 0.26, 0.26)
        player!.position = SCNVector3Make(0.0, 0.0, 0.0)
        player!.rotation = SCNVector4Make(0, 1, 0, Float.pi)
        mainScene.rootNode.addChildNode(player!)
        player?.opacity = 0
        player!.setupCollider(with: 0.26)
        player!.setupWeaponCollider(with: 0.26)
    }
    private func setupPlayer2() {

        let target = mainScene.rootNode.childNode(withName: "target", recursively: false)!
        player2 = Player()//에어팟위에있는놈. 골렘이 아니다.
        player2!.scale = SCNVector3Make(0.26, 0.26, 0.26)
        player2!.position = target.worldPosition
        player2!.rotation = SCNVector4Make(0, 1, 0, Float.pi)
        player2?.opacity = 0.0
        mainScene.rootNode.addChildNode(player2!)
        player2!.setupCollider(with: 0.26)
        player2!.setupWeaponCollider(with: 0.26)
    }

    //MARK:- touches + movement
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

        for touch in touches {

            if gameView.virtualDPadBounds().contains(touch.location(in: gameView)) {
                if padTouch == nil {
                    padTouch = touch
                    controllerStoredDirection = float2(0.0)
                }

            } else if gameView.virtualAttackButtonBounds().contains(touch.location(in: gameView)) {
                player!.attack1()
            } else if cameraTouch == nil {//아무데도아닌곳
                cameraTouch = touches.first
            }

            if padTouch != nil { break }
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {

        if let touch = padTouch {
            let displacement = float2(touch.location(in: view)) - float2(touch.previousLocation(in: view))
            print("csd: \(controllerStoredDirection)")
            let vMix = mix(controllerStoredDirection, displacement, t: 0.1)
            let vClamp = clamp(vMix, min: -1.0, max: 1.0)

            controllerStoredDirection = vClamp

        } else if let touch = cameraTouch {
            let displacement = float2(touch.location(in: view)) - float2(touch.previousLocation(in: view))

        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {

        padTouch = nil
        controllerStoredDirection = float2(0.0)
        cameraTouch = nil
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {

        padTouch = nil
        controllerStoredDirection = float2(0.0)
        cameraTouch = nil
    }

    private func characterDirection() -> float3 {

        var direction = float3(controllerStoredDirection.x, 0.0, controllerStoredDirection.y)

        if let pov = gameView.pointOfView {

            let p1 = pov.presentation.convertPosition(SCNVector3(direction), to: nil)
            let p0 = pov.presentation.convertPosition(SCNVector3Zero, to: nil)
            direction = float3(Float(p1.x-p0.x), 0.0, Float(p1.z-p0.z))

            if direction.x != 0.0 || direction.z != 0.0 {

                direction = normalize(direction)
            }
        }

        return direction
    }

    //MARK:- camera
    private func setupCamera() {

        cameraStick = mainScene.rootNode.childNode(withName: "CameraStick", recursively: false)!

        cameraXHolder = mainScene.rootNode.childNode(withName: "xHolder", recursively: true)!

        cameraYHolder = mainScene.rootNode.childNode(withName: "yHolder", recursively: true)!
       
        finalCameraNode = mainScene.rootNode.childNode(withName: "camera", recursively: true)!
    }

    private func panCamera(_ direction:float2) {

        var directionToPan = direction
        directionToPan *= float2(1.0, -1.0)

        let panReducer = Float(0.005)

        let currX = cameraXHolder.rotation
        let xRotationValue = currX.w - directionToPan.x * panReducer

        let currY = cameraYHolder.rotation
        var yRotationValue = currY.w + directionToPan.y * panReducer

        if yRotationValue < -0.94 { yRotationValue = -0.94 }
        if yRotationValue > 0.46 { yRotationValue = 0.46 }

        cameraXHolder.rotation = SCNVector4Make(0, 1, 0, xRotationValue)
        cameraYHolder.rotation = SCNVector4Make(1, 0, 0, yRotationValue)
    }

    private func setupLight() {

        lightStick = mainScene.rootNode.childNode(withName: "LightStick", recursively: false)!
    }

    //MARK:- game loop functions

    func updateFollowersPositions() {//캐릭터 움직이면 빛하고, 카메라 따라가게.

        cameraStick.position = SCNVector3Make(player!.position.x, 0.0, player!.position.z)
        lightStick.position = SCNVector3Make(player!.position.x, 0.0, player!.position.z)
    }

    //MARK:- walls
    private func setupWallBitmasks() {

        var collisionNodes = [SCNNode]()

        mainScene.rootNode.enumerateChildNodes { (node, _) in

            switch node.name {

            case let .some(s) where s.range(of: "collision") != nil:
                print("node#@@@", node)
                collisionNodes.append(node)

            default:
                break
            }
        }

        for node in collisionNodes {

            node.physicsBody = SCNPhysicsBody.static()
            node.physicsBody!.categoryBitMask = BitmaskWall
            node.physicsBody!.physicsShape = SCNPhysicsShape(node: node, options: [.type: SCNPhysicsShape.ShapeType.concavePolyhedron as NSString])
        }
    }

    //MARK:- collisions
    private func characterNode(_ characterNode:SCNNode, hitWall wall:SCNNode, withContact contact:SCNPhysicsContact) {
        print("collide~!~!")
        if characterNode.name != "collider" && characterNode.name != "golemCollider" { return }

        if maxPenetrationDistance > contact.penetrationDistance { return }

        maxPenetrationDistance = contact.penetrationDistance

        var characterPosition = float3(characterNode.parent!.position)
        var positionOffest = float3(contact.contactNormal) * Float(contact.penetrationDistance)
        positionOffest.y = 0
        characterPosition += positionOffest

        replacementPositions[characterNode.parent!] = SCNVector3(characterPosition)
    }

    //MARK:- enemies
    private func setupEnemies() {

        let people = mainScene.rootNode.childNode(withName: "people", recursively: false)!
        let special = mainScene.rootNode.childNode(withName: "special", recursively: false)!
        //정보가져가려고 한것. 그림에서도 빈노드로 만든것.

        for child in people.childNodes {
            peoplePositionArray[child.name!] = child.worldPosition

        }
        print(special.childNodes)
        for child in special.childNodes {
            specialPositionArray[child.name!] = child.worldPosition
        }
        print(golemsPositionArray)
        setupGolems()
    }

    private func setupGolems() {

        let golemScale:Float = 0.28//0.28
        let specialScale:Float = 0.7//0.7
        var golems: [Zombie] = [Zombie]()
        var specials: [Zombie] = [Zombie]()
        print("spc2",peoplePositionArray.count)
        for i in 1...peoplePositionArray.count {
            print("\(i)번째 사람: \(peoplePositionArray["inplaceWalk\(i)"]!)")
            golems.append(Zombie(enemy: player!, view: gameView))
            golems[i-1].scale = SCNVector3Make(golemScale, golemScale, golemScale)
            print(i)
            golems[i-1].position = peoplePositionArray["inplaceWalk\(i)"]!
            if i < 5 {
                golems[i-1].goelmSpeed = 8
            }
            else if i < 12 {
                golems[i-1].goelmSpeed = 12
            }
            else {
                golems[i-1].goelmSpeed = 14
            }
        }
        gameView.prepare(golems) {
            (finished) in
            self.prepareHelper(golems: golems, golemScale: golemScale)
        }
        print("spc,",specialPositionArray.count)
        for i in 1...specialPositionArray.count {
            specials.append(Zombie(enemy: player2!, view: gameView, isItSpecial: true))
            specials[i-1].originEnemy = player!
            specials[i-1].scale = SCNVector3Make(specialScale, specialScale, specialScale)
            specials[i-1].position = specialPositionArray["special\(i)"]!
            specials[i-1].goelmSpeed = 10//10
        }

        gameView.prepare(specials) {
            (finished) in
            self.prepareHelper(golems: specials, golemScale: specialScale)
        }
    }
}
extension LoadingViewController: SCNPhysicsContactDelegate {

    func physicsWorld(_ world: SCNPhysicsWorld, didBegin contact: SCNPhysicsContact) {

        if gameState != .playing { return }

        //if player collide with wall
        contact.match(BitmaskWall) {
            (matching, other) in
            self.characterNode(other, hitWall: matching, withContact: contact)
        }

        //if player collide with golem
        contact.match(BitmaskGolem) {

            (matching, other) in
//            print("2mo", matching,other)
            let golem = matching.parent as! Zombie
            if other.name == "collider" { golem.isCollideWithEnemy = true }
            if other.name == "weaponCollider" { player!.weaponCollide(with: golem) }
        }
    }

    func physicsWorld(_ world: SCNPhysicsWorld, didUpdate contact: SCNPhysicsContact) {
        
        contact.match(BitmaskWall) {
            (matching, other) in

            self.characterNode(other, hitWall: matching, withContact: contact)
        }

        contact.match(BitmaskGolem) {
            (matching, other) in

            let golem = matching.parent as! Zombie
            if other.name == "collider" { golem.isCollideWithEnemy = true }
            if other.name == "weaponCollider" { player!.weaponCollide(with: golem) }
        }
    }

    func physicsWorld(_ world: SCNPhysicsWorld, didEnd contact: SCNPhysicsContact) {

        //if player collide with golem
        contact.match(BitmaskGolem) {
            (matching, other) in

            let golem = matching.parent as! Zombie
            if other.name == "collider" { golem.isCollideWithEnemy = false }
            if other.name == "weaponCollider" { player!.weaponUnCollide(with: golem) }
        }
    }
}

//game loop
extension LoadingViewController:SCNSceneRendererDelegate {

    func renderer(_ renderer: SCNSceneRenderer, didSimulatePhysicsAtTime time: TimeInterval) {
//
        if gameState != .playing { return }

        for (node,position) in replacementPositions {

            node.position = position
        }
    }

    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {

        if gameState != .playing { return }
        //reset
        replacementPositions.removeAll()
        maxPenetrationDistance = 0.0

        let scene = gameView.scene!
        let direction = characterDirection()

        player!.walkInDirection(direction, time: time, scene: scene)

        updateFollowersPositions()


        mainScene.rootNode.enumerateChildNodes { (node, _) in

            if let name = node.name {

                switch name {

                case "Golem":
                    (node as! Zombie).update(with: time, and: scene)

                default:
                    break
                }
            }
        }
    }
}
extension LoadingViewController {
    func prepareHelper(golems:[Zombie], golemScale:Float){
        for g in golems {
            self.mainScene.rootNode.addChildNode(g)
            g.setupCollider(scale: CGFloat(golemScale))
        }
    }
}
