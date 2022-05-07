
//
//  GameViewController.swift
//  newlec
//
//  Created by Hankyu Lee on 2022/04/02.
//

//사람들 사방에 있게하기 등장할ㄸㅐ마다 빛 비추기
//카메라 돌아가기

import UIKit
import QuartzCore
import SceneKit
import SwiftUI
class GameView2 : SCNView,CAAnimationDelegate {
    
}
class LightViewController: UIViewController, CAAnimationDelegate {
    var player : Player_light!
    var player_2 : Player_light!
    var player_3 : Player_light!
//    var player2 : Player2!
    var mainScene : SCNScene!
    var boxNode : SCNNode!
    var mapNode : SCNNode!
    var lightNode = SCNNode()
    var cameraNodes = SCNNode()
    var cameraNode = SCNNode()
    var cameraNode2 = SCNNode()
    var playerNode = SCNNode()
    var temScene = SCNScene()
    var firstLight = SCNNode()
    var ambientNode = SCNNode()
    var lightNodeSpot = SCNNode()
    var clickCount = 1
    var directionalNode = SCNNode()
    var cyliderNode = SCNNode()
    var A = SCNNode()
    var B = SCNNode()
    var plainFloor = SCNNode()
    var sittingNode = SCNNode()
    var spotPosition : SCNNode!
    var jumpForwardAction: SCNAction?
    var jumpRightAction: SCNAction?
    var jumpLeftAction: SCNAction?
    var driveRightAction: SCNAction?
    var driveLeftAction: SCNAction?
    var dieAction: SCNAction?
    var scnView = GameView2(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
    var fourThings:SCNNode!
    var person1:SCNNode!
    var person2:SCNNode!
    
    var fourText:SCNNode!
    var threeText:SCNNode!
//    var count = 0
    var aniArray:[Bool] = Array(repeating: false, count: 100)
    
    private func setupPlayer() {

        player = Player_light(clothOrder: 0)
        player!.scale = SCNVector3Make(1*40, 1*40, 1*40)
        player!.position = SCNVector3Make(0.0, 0.0, 60)
        let ang = toRadians(angle: Float(0))
        player.rotation = SCNVector4(0, 1, 0, ang)
//        player!.rotation = SCNVector4Make(0, 1, 0, Float.pi)
        mainScene.rootNode.addChildNode(player!)
//        player.removeAllActions()
//        player.removeAllAnimations()

        player.characterNode.removeAllAnimations()//처음엔 걷지마
        player.characterNode.removeAllActions()

        player_2 = Player_light(clothOrder: 1)
        player_2!.scale = SCNVector3Make(45, 45, 45)
        player_2!.position = SCNVector3Make(-3, 0.0, -22)
        player_2.opacity = 0
        player_2.castsShadow = false
        player_2.clothOrder = 1
        let ang2 = toRadians(angle: Float(20))
        player_2.rotation = SCNVector4(0, 1, 0, ang2)
//        player!.rotation = SCNVector4Make(0, 1, 0, Float.pi)
        mainScene.rootNode.addChildNode(player_2!)
        



        player_3 = Player_light(clothOrder: 2)
        player_3!.scale = SCNVector3Make(30,30,30)
        player_3!.position = SCNVector3Make(-15, 0.0, -0)
        player_3.opacity = 0
        player_3.castsShadow = false
        let ang3 = toRadians(angle: Float(110))
        player_3.rotation = SCNVector4(0, 1, 0, ang3)
//        player!.rotation = SCNVector4Make(0, 1, 0, Float.pi)
        mainScene.rootNode.addChildNode(player_3!)
        
        




    }
//    private func setupPlayer2() {
//
//        player2 = Player2()
//        player2!.scale = SCNVector3Make(1*0.5, 1*0.5, 1*0.5)
//        player2!.position = SCNVector3Make(3.0, 0.0, 20)
////        player2!.rotation = SCNVector4Make(0, 1, 0, Float.pi)
////        player2.removeAllAnimations()
//        mainScene.rootNode.addChildNode(player2!)
//
//    }

    var button = UIButton(type: .system)
    func addButton(ment:String){

        DispatchQueue.main.async {
            
            
//            SCNTransaction.begin()
//            SCNTransaction.animationDuration = 3
//
//            SCNTransaction.commit()
            
            
            self.button.tintColor = UIColor.white
            self.button.setTitle("\(ment)", for: .normal)
            self.button.titleLabel?.font = UIFont(name: "HelveticaNeue-ThinItalic", size: 30)
            self.button.sizeToFit()
//            self.button.fadeIn()
            self.button.titleLabel?.blink()
            self.button.addTarget(self, action: #selector(self.didPressBack), for: .touchUpInside)
            
            self.button.center.x = 150
            self.button.frame.origin.y = self.view.bounds.height - 200
            self.scnView.addSubview(self.button)
        }


    }

    @objc func didPressBack (sender: UIButton!) {
            
            clickCount += 1
            aniArray[clickCount] = true
            DispatchQueue.main.async {
            self.button.removeFromSuperview()
            self.addAction()
        }
        
        
    }
    //@@
    func addAction(){
        if aniArray[2] {
            

               GameSound.lightsec_0(cameraNode)
                let spotPosition2 = SCNNode()
                spotPosition2.position = SCNVector3(x: 0 , y:10  , z: -57 )
                SCNTransaction.begin()
                SCNTransaction.animationDuration = 7

                ambientNode.light?.intensity = 100
                firstLight.position = SCNVector3(x: firstLight.position.x, y: firstLight.position.y + 5, z: firstLight.position.z - 43)
                firstLight.constraints = [SCNLookAtConstraint(target: spotPosition2)]
                SCNTransaction.commit()


                player.applyWalk()
                SCNTransaction.begin()
                SCNTransaction.animationDuration = 5
                turnOffLight()
                cameraNode.position = SCNVector3(x: cameraNode.position.x , y: cameraNode.position.y , z: cameraNode.position.z - 40 )
                spotPosition = SCNNode()
                spotPosition.position = SCNVector3(x: 0 , y: 2 , z: 3 )
                cameraNode.constraints = [SCNLookAtConstraint(target: spotPosition)]
                SCNTransaction.commit()

                let ang = toRadians(angle: Float(180))

                let rot = SCNAction.rotate(by: CGFloat(ang), around: SCNVector3(x: 0, y: 1, z: 0), duration: 0.8)
                let ac = SCNAction.move(to: SCNVector3Make(0, 0, 20), duration: 3)
                ac.timingMode = .easeInEaseOut
                player.runAction(rot){
                    self.player.runAction(ac){
                        self.addButton(ment: "Set!")
                        self.player.characterNode.removeAnimation(forKey: "walk", blendOutDuration: 1)
                    }
                }






            
            aniArray[2] = false
        }
        
        if aniArray[3] {
            GameSound.lightsec_1(cameraNode)
                let opacityAction = SCNAction.fadeOpacity(to: 1, duration: 2)
                opacityAction.timingMode = .easeInEaseOut
            jumpLeftAction?.speed = 0.45
                cyliderNode.runAction(opacityAction)
                A.runAction(opacityAction){
                    self.cyliderNode.runAction(self.jumpLeftAction!){
                        self.cyliderNode.runAction(self.jumpLeftAction!){
                            self.cyliderNode.runAction(self.jumpLeftAction!){
                                self.cyliderNode.runAction(self.jumpLeftAction!){
                                    self.addButton(ment: "Change the light")
                                }
                            }
                        }
                    }
                }

                B.runAction(opacityAction){
                    SCNTransaction.begin()
                    SCNTransaction.animationDuration = 1

                    self.directionalNode.light?.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
                    SCNTransaction.commit()
                }
            aniArray[3] = false
        }
        
        if aniArray[4] {
            
            aniArray[4] = false
//            SCNTransaction.begin()
//            SCNTransaction.animationDuration = 2
//            SCNTransaction.completionBlock = {
                GameSound.lightsec_2(self.cameraNode)
                
//                SCNTransaction.commit()
//            }
            let ang = toRadians(angle: Float(180))
            firstLight.runAction(SCNAction.rotateBy(x: 0, y: CGFloat(ang), z: 0, duration: 5)){
                self.addButton(ment: "Turn on the light")
            }
//            firstLight.removeFromParentNode()
//            SCNTransaction.commit()
            
            
//            GameSound.lightsec_2(cameraNode)
            
//            firstLight.removeFromParentNode()
            
            
        }
        if aniArray[5] {
            GameSound.lightsec_3(cameraNode)
            aniArray[5] = false
            firstLight.light?.intensity = 0
            ambientNode.light?.intensity = 30
            setupSpotLight()
            let ang = toRadians(angle: Float(180))
            firstLight.runAction(SCNAction.rotateBy(x: 0, y: 0, z: 0, duration: 5)){
                self.addButton(ment: "Rotate!")
            }
            
            
            
            
        }
        if aniArray[6] {
            GameSound.lightsec_4(cameraNode)
            
            let act2 = SCNAction.rotate(by: 0.8, around: SCNVector3(x: 0, y: -0.3, z: 0), duration: 0.7)
            let act3 = SCNAction.rotate(by: 1.6, around: SCNVector3(x: 0, y: 0.3, z: 0), duration: 1.4)
            let act4 = SCNAction.rotate(by: 0.8, around: SCNVector3(x: 0, y: -1.4, z: 0), duration: 0.7)
            let action = SCNAction.sequence([act2,act3,act4])
            act2.speed = 8
            act3.speed = 10
            act4.speed = 8
            directionalNode.runAction(action){
                self.addButton(ment: "Next")
                
            }
            
            aniArray[6] = false
        }
        if aniArray[7] {
            GameSound.lightsec_5(cameraNode)
            
            SCNTransaction.begin()
            SCNTransaction.animationDuration = 1


            player_2.opacity = 1
            player_2.castsShadow = true
//                self.cyliderNode.position = SCNVector3(x: 3, y: 3, z: 3)
            SCNTransaction.commit()

            aniArray[7] = false
            firstLight.runAction(SCNAction.rotateBy(x: 0, y: 0, z: 0, duration: 3)){
                self.addButton(ment: "Next")
            }
            
        }
        if aniArray[8] {
            GameSound.lightsec_6(cameraNode)
            player_2.runAction(SCNAction.fadeOpacity(to: 0, duration: 1))
            SCNTransaction.begin()
            SCNTransaction.animationDuration = 1
            
            player_2.castsShadow = false
            player_3.opacity = 1
            player_3.castsShadow = true
            SCNTransaction.commit()
            
            firstLight.runAction(SCNAction.rotateBy(x: 0, y: 0, z: 0, duration: 2)){
                self.addButton(ment: "Next")
            }
            
            aniArray[8] = false
        }
        if aniArray[9] {
            GameSound.lightsec_7(cameraNode)
            firstLight.runAction(SCNAction.rotateBy(x: 0, y: 0, z: 0, duration: 4.5)){
                self.addButton(ment: "Another example!")
            }
            
            player_3.runAction(SCNAction.fadeOpacity(to: 0, duration: 1))
            SCNTransaction.begin()
            SCNTransaction.animationDuration = 1
            
            player_3.castsShadow = false

            plainFloor.opacity = 1
            sittingNode.opacity = 1
            fourThings.opacity = 1
            
            

            sittingNode.castsShadow = true
//                self.cyliderNode.position = SCNVector3(x: 3, y: 3, z: 3)
            SCNTransaction.commit()
            
            aniArray[9] = false
        }
        if aniArray[10] {
            GameSound.lightsec_8(self.cameraNode)
            firstLight.runAction(SCNAction.rotateBy(x: 0, y: 0, z: 0, duration: 2.5)){
                self.player.applyWalk()
                self.directionalNode.light?.castsShadow = false
    //            let ang = toRadians(angle: -Float(90))
    //            directionalNode.rotation = SCNVector4(0, 1, 0, ang)
                let angle = toRadians(angle: CGFloat(-90))

                let moveXdistance = Float(68)
                let act1 = SCNAction.rotate(by: angle, around: SCNVector3(x: 0, y: 1, z: 0), duration: 2)
                let act2 = SCNAction.move(to: SCNVector3(x: moveXdistance, y: 0, z: self.player.position.z-7), duration: 3)
                let act3 = SCNAction.move(to: SCNVector3(x: moveXdistance, y: self.cameraNode.position.y + 24, z: self.cameraNode.position.z), duration: 3)
                act1.speed = 5
                act2.speed = 3
                act3.speed = 1.5
                let action = SCNAction.sequence([act1,act2])
                self.player.runAction(action){
                    self.player.characterNode.removeAnimation(forKey: "walk", blendOutDuration: 1)
                    SCNTransaction.begin()
                    SCNTransaction.animationDuration = 1.8
                    SCNTransaction.completionBlock = {
                        print("됨")
                        GameSound.lightsec_8_2(self.cameraNode)
                        self.firstLight.runAction(SCNAction.rotateBy(x: 0, y: 0, z: 0, duration: 2.7)){
                            self.addButton(ment: "                        Umm...")
                        }
                        
                        SCNTransaction.commit()
                    }
                    let ang = toRadians(angle: Float(180))
                    self.player.rotation = SCNVector4(0,1,0, ang)
                    
                    SCNTransaction.commit()
                }
                
                self.cameraNode.constraints = []

    //            let spotAct = SCNAction.move(to: SCNVector3(x: spotPosition.position.x + moveXdistance, y: spotPosition.position.y, z: player.position.z), duration: 6)
                self.cameraNode.runAction(act3)
                self.fourText.opacity = 1
                self.threeText.opacity = 1
                self.fourText.runAction(SCNAction.repeatForever(SCNAction.rotate(by: 1, around: SCNVector3(x: 0, y: 1, z: 0), duration: 1)))
                self.threeText.runAction(SCNAction.repeatForever(SCNAction.rotate(by: 1, around: SCNVector3(x: 0, y: 1, z: 0), duration: 1)))
                self.aniArray[10] = false
            }
            
            
            
        }
        
        if aniArray[11] {
            person1.opacity = 1
            person2.opacity = 1
            self.firstLight.runAction(SCNAction.rotateBy(x: 0, y: 0, z: 0, duration: 5.2)){
                self.addButton(ment: " Go next Page")
            }
            
            GameSound.lightsec_9(cameraNode)
            aniArray[11] = false
        }
        if aniArray[12] {
            
            let vc = LoadingViewController()
            vc.modalPresentationStyle = .overFullScreen
            vc.goingToSetUpEnemy = false
            self.present(vc, animated: true)
            
        }
        
    }
    
    
    override func viewDidLoad() {

        super.viewDidLoad()
        // retrieve the SCNView
        self.view.addSubview(scnView)

        let paths = Bundle.main.paths(forResourcesOfType: "scn", inDirectory: nil)

        print(paths)
        for path in paths {
            if path.contains("180x180") {
                do {
                    temScene = try SCNScene(url: URL(fileURLWithPath: path),options: nil)
                } catch {
                    print("no wall")
                }
            }
        }



//        mainScene = SCNScene(named: "art.scnassets/9x9.scn")!
        mapNode = temScene.rootNode.childNode(withName: "map", recursively: true)!
        let bgNode = temScene.rootNode.childNode(withName: "carpet", recursively: true)!
        cyliderNode = temScene.rootNode.childNode(withName: "cylinder", recursively: true)!
        sittingNode = temScene.rootNode.childNode(withName: "sitting", recursively: true)!
        fourThings = temScene.rootNode.childNode(withName: "4things", recursively: true)!
        person1 = temScene.rootNode.childNode(withName: "person1", recursively: true)!
        person1.scale = SCNVector3(x: 50, y: 50, z: 50)
        person1.childNode(withName: "male_worksuit01-obj", recursively: false)?.geometry?.firstMaterial?.diffuse.contents = UIColor.red
        person1.opacity = 0
        
        person2 = temScene.rootNode.childNode(withName: "person2", recursively: true)!
        person2.childNode(withName: "male_worksuit01-obj", recursively: false)?.geometry?.firstMaterial?.diffuse.contents = UIColor.black
        let floor = temScene.rootNode.childNode(withName: "floor", recursively: true)!
        person2.opacity = 0
        person2.scale = SCNVector3(x: 50, y: 50, z: 50)
        plainFloor =  temScene.rootNode.childNode(withName: "plainFloor", recursively: true)!
        let zz = temScene.rootNode.childNode(withName: "zz", recursively: true)!

        fourText = temScene.rootNode.childNode(withName: "four", recursively: false)!
        threeText = temScene.rootNode.childNode(withName: "three", recursively: false)!
        fourText.opacity = 0
        threeText.opacity = 0
        
        plainFloor.opacity = 0
        fourThings.castsShadow = false
        fourThings.opacity = 0
        person1.opacity = 0
        person2.opacity = 0
        plainFloor.castsShadow = false
        sittingNode.opacity = 0
        cyliderNode.opacity = 0
        cyliderNode.castsShadow = true
//        let box = temScene.rootNode.childNode(withName: "box", recursively: true)!
        mainScene = SCNScene()
        A = temScene.rootNode.childNode(withName: "A", recursively: true)!
        B = temScene.rootNode.childNode(withName: "B", recursively: true)!
        A.opacity = 0
        B.opacity = 0
        mapNode.castsShadow = false
        mainScene.rootNode.addChildNode(mapNode)
        mainScene.rootNode.addChildNode(cyliderNode)//하나씩 소환가능
        cyliderNode.position = SCNVector3(x: cyliderNode.position.x + 4 , y: cyliderNode.position.y , z: cyliderNode.position.z)
        mainScene.rootNode.addChildNode(A)
        mainScene.rootNode.addChildNode(B)
        mainScene.rootNode.addChildNode(bgNode)
        mainScene.rootNode.addChildNode(sittingNode)
        mainScene.rootNode.addChildNode(fourThings)
        mainScene.rootNode.addChildNode(plainFloor)
        mainScene.rootNode.addChildNode(person1)//scene 객체를 만들었으므로 여기는 다 애드칠드 해야한다.
        mainScene.rootNode.addChildNode(person2)
        mainScene.rootNode.addChildNode(fourText)
        mainScene.rootNode.addChildNode(threeText)
        mainScene.rootNode.addChildNode(floor)
//        mainScene.rootNode.addChildNode(zz)
//        mainScene.rootNode.addChildNode(no)

//        mainScene.rootNode.addChildNode(box)
        // set the scene to the view
        scnView.scene = mainScene
        scnView.backgroundColor = .black

        setupCamera()
        setupPlayer()
//        setupPlayer2()
        setupLight()
        setupFloor()
//        setupSpotLight()//setupLight 다음에 해야한다.
        setupOrigin()
       setupActions()
        
        mapNode.runAction(SCNAction.fadeOpacity(to: 1, duration: 1)){
            
            self.addButton(ment: "Start!")//좀있다 시작하려고
        }
        

        // allows the user to manipulate the camera
        
//        scnView.allowsCameraControl = true

        // show statistics such as fps and timing information
//        scnView.showsStatistics = true

        // configure the view
        scnView.backgroundColor = UIColor.brown

        // add a tap gesture recognizer
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
//        scnView.addGestureRecognizer(tapGesture)
    }


    func setupOrigin(){
        let geometry2 = SCNBox(width: 50*0.0026, height: 700*0.026, length: 50*0.0026, chamferRadius: 0)
        geometry2.firstMaterial?.diffuse.contents = UIColor.red
        boxNode = SCNNode(geometry: geometry2)
        boxNode.position = SCNVector3(0,0,0)

//        boxNode2.pivot = SCNMatrix4MakeTranslation(0, 0.1, 0)
        boxNode.opacity = 0.0
//        boxNode.physicsBody = .kinematic()
        boxNode.name = "ccq"
        mainScene.rootNode.addChildNode(boxNode)
    }

    func setupCamera(){
        cameraNode = temScene.rootNode.childNode(withName: "camera", recursively: true)!
        mainScene.rootNode.addChildNode(cameraNode)
//        cameraNode2 = temScene.rootNode.childNode(withName: "camera2", recursively: true)!
//        self.mainScene.rootNode.addChildNode(self.cameraNode2)

//        cameraNode.camera = SCNCamera()
//        mainScene.rootNode.addChildNode(cameraNode)
//        cameraNode.position = SCNVector3(x: 0, y: 50, z: 25)
//        cameraNode.eulerAngles = SCNVector3(x: -toRadians(angle: 60), y: 0, z: -toRadians(angle: 0))
    }

    func setupSpotLight(){

        lightNodeSpot.light = SCNLight()
        lightNodeSpot.light!.type = .spot
        lightNodeSpot.light!.spotOuterAngle = 86//삼각꼴 입체 빛 . 크면 넓게 비춤.
        lightNodeSpot.light!.attenuationStartDistance = 0
        lightNodeSpot.light!.attenuationFalloffExponent = 30//크면 빨리 빛이 줄어든다.

//        directionalNode.position = SCNVector3(x: 2, y: 2, z: -5)
//        directionalNode.eulerAngles = SCNVector3(x: toRadians(angle: 170), y: toRadians(angle: 50), z: toRadians(angle: 180))
        lightNodeSpot.light!.attenuationEndDistance = 40 // 크면 너무 밝다.
//        lightNodeSpot.position = SCNVector3(x: 2, y: 2, z: -5)
        lightNodeSpot.position = SCNVector3(x: 17.2, y: 16, z: -14.68)//1
//        lightNodeSpot.position = SCNVector3(x: 16.76, y: 5.6, z: -15.36)//2
//        lightNodeSpot.eulerAngles = SCNVector3(x: toRadians(angle: 170), y: toRadians(angle: 50), z: toRadians(angle: 180))
        let spotPosition = SCNNode()
        spotPosition.position = SCNVector3(x: -15.2, y: 4.3, z: 0)
//        spotPosition.position = SCNVector3(x: 0, y: 0, z: 0)
        lightNodeSpot.constraints = [SCNLookAtConstraint(target: spotPosition)]

//        cameraNode.constraints = [SCNLookAtConstraint(target: spotPosition)]

//        lightNode.addChildNode(ambientNode)
        lightNode.addChildNode(lightNodeSpot)
        mainScene.rootNode.addChildNode(lightNode)
    }

    func setupLight() {
        firstLight = temScene.rootNode.childNode(withName: "area", recursively: true)!
//        firstLight.light = firstLight.light
        let spotPosition = SCNNode()
        spotPosition.position = SCNVector3(x: 0 , y: 2 , z: 3 )
        firstLight.constraints = [SCNLookAtConstraint(target: spotPosition)]
        lightNode.addChildNode(firstLight)

        ambientNode.light = SCNLight()
        ambientNode.light?.type = .ambient
        ambientNode.light?.intensity = 200

        directionalNode.light = SCNLight()
        directionalNode.light?.type = .directional
        directionalNode.light?.castsShadow = true
//        directionalNode.light?.shadowMode = .forward
        directionalNode.light?.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)

//        directionalNode.position = SCNVector3(x: 3, y: 3, z: -3)//position이 없어도되네
        directionalNode.eulerAngles = SCNVector3(x: toRadians(angle: 172.52), y: toRadians(angle:48.14), z: toRadians(angle: -176.9))
//        print(directionalNode.position)
//        directionalNode.eulerAngles = SCNVector3(x: toRadians(angle: 174), y: toRadians(angle:29), z: toRadians(angle: -176.9))
//        print(directionalNode.position)

        lightNode.addChildNode(ambientNode)
        ambientNode.light?.intensity = 200
        lightNode.addChildNode(directionalNode)
//        lightNode.position = cameraNode.position//우린 물체가 움직이지 않으므로 없어도된다
        mainScene.rootNode.addChildNode(lightNode)

    }
    func turnOffLight(){

//        firstLight.removeFromParentNode()


//        lightNode.position = SCNVector3(x: lightNode.position.x, y: lightNode.position.y, z: lightNode.position.z)
//        print(lightNode.position )
//        setupSpotLight()
//        SCNTransaction.commit()
//        ambientNode.light?.intensity = 0

    }
    func setupFloor(){



    }


    func setupActions() {
        let moveUpAction = SCNAction.moveBy(x: 0, y: 1.0, z: 0, duration: 0.15)
        let moveDownAction = SCNAction.moveBy(x: 0, y: -1.0, z: 0, duration: 0.15)
        moveUpAction.timingMode = .easeOut
        moveDownAction.timingMode = .easeIn
        let jumpAction = SCNAction.sequence([moveUpAction,moveDownAction])
        let moveForwardAction = SCNAction.moveBy(x: 0, y: 0, z: -1.0, duration: 0.2)
        let moveRightAction = SCNAction.moveBy(x: 1.0, y: 0, z: 0, duration: 0.2)
        let moveLeftAction = SCNAction.moveBy(x: -1.0, y: 0, z: 0, duration: 0.3)

        let turnForwardAction = SCNAction.rotateTo(x: 0, y: toRadians(angle: 180), z: 0, duration: 0.2, usesShortestUnitArc: true)
        print( "\(toRadians(angle: 90))")
        let turnRightAction = SCNAction.rotateTo(x: 0, y: toRadians(angle: 90), z: 0, duration: 0.2, usesShortestUnitArc: true)
        let turnLeftAction = SCNAction.rotateTo(x: 0, y: toRadians(angle: -90), z: 0, duration: 0.3, usesShortestUnitArc: true)

        jumpForwardAction = SCNAction.group([turnForwardAction, jumpAction, moveForwardAction])
        jumpRightAction = SCNAction.group([turnRightAction, jumpAction, moveRightAction])
        jumpLeftAction = SCNAction.group([turnLeftAction, jumpAction, moveLeftAction])

        driveRightAction = SCNAction.repeatForever(SCNAction.moveBy(x: 2.0, y: 0, z: 0, duration: 1.0))
        driveLeftAction = SCNAction.repeatForever(SCNAction.moveBy(x: -2.0, y: 0, z: 0, duration: 1.0))

        dieAction = SCNAction.moveBy(x: 0, y: 5, z: 0, duration: 1.0)
    }


    func getFloorMaterial() -> SCNMaterial {

        let floorMaterial = SCNMaterial()
//        floorMaterial.diffuse.contents = UIImage(named: "WoodPanel")//수정필
        floorMaterial.specular.contents = UIColor.black

        return floorMaterial
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

}
