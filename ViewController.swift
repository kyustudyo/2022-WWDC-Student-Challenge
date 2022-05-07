//
//  ViewController.swift
//  wwwdc
//
//  Created by Hankyu Lee on 2022/04/13.
//

import Foundation
import UIKit
import SceneKit


import UIKit
import QuartzCore
import SceneKit

//첨에는 얘기 안하다 오는게 날듯
//누르면 소리나게
//하늘색깔
//왓다갓다 거리는 거는 누르면 다른 액션 취하게

//
let BitmaskPlayer = 1
let BitmaskPlayerWeapon = 2
let BitmaskWall = 64
let BitmaskGolem = 3

enum GameState {
    case menu,loading,playing
}

class ViewController: UIViewController, CAAnimationDelegate {
    var button = UIButton(type: .system)
    
    func addButton(ment:String){

        DispatchQueue.main.async {
            
            
            SCNTransaction.begin()
            SCNTransaction.animationDuration = 3

            SCNTransaction.commit()
            
            
            self.button.tintColor = UIColor.white
            self.button.setTitle("\(ment)", for: .normal)
            self.button.titleLabel?.font = UIFont(name: "HelveticaNeue-ThinItalic", size: 30)
            self.button.sizeToFit()
//            self.button.fadeIn()
            self.button.titleLabel?.blinkFast()
            self.button.addTarget(self, action: #selector(self.didPressBack), for: .touchUpInside)
            self.button.center.x = 150
            self.button.frame.origin.y = self.view.bounds.height - 200
            self.gameView!.addSubview(self.button)
        }


    }

    var gameView : SCNView? = SCNView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))

//    SCNView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))

    var mainScene:SCNScene!
    var floors = SCNNode()
    var f1Node = [SCNNode]()
    var allFloorNode = [SCNNode]()
    var boxPerson : SCNNode!
    var personNode : SCNNode!
    var boxNode : SCNNode!
    var decoBox:SCNNode!
    var driveAction: SCNAction!
    var driveAction2: SCNAction!
    var gameState = GameState.menu
    var count = 0
    
    var onceBool = false
    var onceBool2 = true
    var theEnd = false
    var sphere : SCNNode!
    var cinemaNode: SCNNode!
    var cameraNode2: SCNNode!
    var realCameraNode: SCNNode!
    var playerDetailNode : SCNNode!
    var specialNodeE = [SCNNode]()
    var specialNodeN = [SCNNode]()
    var specialNodeJ = [SCNNode]()
    var specialNodeO = [SCNNode]()
    var specialNodeY = [SCNNode]()
    var red : SCNNode!
    var aniArray:[Bool] = Array(repeating: false, count: 100)
    var youCanEnd = false
    var label2 = UILabel()
    var lastCount = 0
    var dance = false
    
    
    
    var isFinalVC:Bool = false//false로해야한다
    
    
    
    
    
    
    
//    private var _hud: HUD!

//    override func viewWillAppear(_ animated: Bool) {
//        <#code#>
//    }
    func getLoadingLabel(string:String){
        
        
        
        let label = UILabel()
        label.textColor = UIColor.white
        label.font = UIFont(name: "HelveticaNeue-ThinItalic", size: 40)
        label.text = string
        label.sizeToFit()
        label.center.x = 200
        label.frame.origin.y = view.bounds.height - 200
        label.blinkFast()
        gameView!.addSubview(label)
    }
    
    override func viewDidLoad() {



        super.viewDidLoad()

        let paths = Bundle.main.paths(forResourcesOfType: "scn", inDirectory: nil)

        print(paths)
        for path in paths {
            if path.contains("wall") {
                do {
                mainScene = try SCNScene(url: URL(fileURLWithPath: path),options: nil)
                } catch {
                    print("no wall")
                }
            }
        }
//        let scn = try? SCNScene(url: URL(string: paths[0])!)
//        var k = SCNScene()
//        do {
//            mainScene = try SCNScene(url: URL(fileURLWithPath: paths[0]),options: nil)
//        } catch {
//            print("ffff")
//        }

//        if !isFinalVC {
//            let label = UILabel()
//            label.textColor = UIColor.white
//            label.font = UIFont(name: "HelveticaNeue-ThinItalic", size: 30)
//            label.text = "Are you ready ?"
//            label.sizeToFit()
//            label.center.x = 130
//            label.frame.origin.y = self.view.bounds.height - 250
//            addButton(ment: "Start-")
//        }
//        else if isFinalVC {
//            addButton(ment: "Umm...")
//        }

        if let view = gameView {
            self.view.addSubview(view)
            view.scene = mainScene
//            view.allowsCameraControl = true
        ////            let wallScene = SCNScene(named: "art.scnassets/wall.scn")!
        //            mainScene = SCNScene(named: "scenekitItem.scnassets/wall.scn")!
        ////            mainScene.physicsWorld.contactDelegate = self
        //
        //
        ////            view.allowsCameraControl  = true
        //
                    view.isPlaying = true
                    view.backgroundColor = UIColor.gray
                    view.antialiasingMode = SCNAntialiasingMode.multisampling4X
        //
        //
            print(mainScene.rootNode.childNodes)
            boxPerson = mainScene.rootNode.childNode(withName: "boxPerson", recursively: false)!
            personNode = boxPerson.childNode(withName: "person", recursively: false)!
            playerDetailNode = personNode.childNode(withName: "mixamorig_Hips", recursively: true)!
//            playerDetailNode.removeAllAnimations()//처음에 안걷게.
            
            boxNode = boxPerson.childNode(withName: "downBox", recursively: false)!
            decoBox = mainScene.rootNode.childNode(withName: "box", recursively: false)!
            cinemaNode = mainScene.rootNode.childNode(withName: "cinemaCamera", recursively: true)!
            realCameraNode = cinemaNode.childNode(withName: "cam2", recursively: false)!
            cameraNode2 = mainScene.rootNode.childNode(withName: "cam3", recursively: true)!
            red = cinemaNode.childNode(withName: "red", recursively: true)!
            red.opacity = 0
//            sphere = mainScene.rootNode.childNode(withName: "sphere1", recursively: false)!
//            mainScene.rootNode.addChildNode(cameraNode)
//            mainScene.rootNode.addChildNode(cameraNode2)
//            mainScene.rootNode.camera = cameraNode.camera
        //
        //
        //
        ////            boxPerson.scale = SCNVector3Make(120, 10, 11)//이거쓰면안나옴.
        ////            mainScene.rootNode.addChildNode(boxPerson)//이미 있는데 또 하는거.
        ////            boxPerson.worldPosition = SCNVector3(x: 16, y: 0.5, z: 1.8)
        ////            print(boxPerson.position)
                    for i in 1...5 {//뺏어가기도 하는구나 addchild하면.
                        let floor = mainScene.rootNode.childNode(withName: "f\(i)", recursively: true)!
        //                floor.runAction(SCNAction.scale(by: 1.4, duration: 8))
                        floors.addChildNode(floor)
                    }

                    floors.childNode(withName: "f1", recursively: false)?.enumerateChildNodes({ node,_  in
                        switch node.name {
                        case "box3" :
                            f1Node.append(node)
                        default :
                            break
                        }
                    })
        //
                    f1Node[0].childNode(withName: "e", recursively: false)?.enumerateChildNodes({ node, _ in

                        specialNodeE.append(node)
                    })

                    f1Node[0].childNode(withName: "n", recursively: false)?.enumerateChildNodes({ node, _ in

                        specialNodeN.append(node)
                    })
                f1Node[0].childNode(withName: "j", recursively: false)?.enumerateChildNodes({ node, _ in

                    specialNodeJ.append(node)
                })
                f1Node[0].childNode(withName: "o", recursively: false)?.enumerateChildNodes({ node, _ in

                    specialNodeO.append(node)
                })
                f1Node[0].childNode(withName: "y", recursively: false)?.enumerateChildNodes({ node, _ in

                    specialNodeY.append(node)
                })
            for i in [specialNodeE,specialNodeN,specialNodeJ,specialNodeO,specialNodeY] {
                for j in i {
                    j.name = "floorBox0"//알파벳 눌러도 enjoy 되도록
                }
            }


        //
                    for i in 1...5 {
                        floors.childNode(withName: "f\(i)", recursively: false)?.enumerateChildNodes({ node,_  in
                            switch node.name {
                            case "box3" :
                                allFloorNode.append(node)
                            default :
                                break
                            }
                        })
                    }
        //
        //
        //
        //            print("box3개수", allFloorNode.count)
                    for i in 0..<allFloorNode.count {//이름 붙여서 호명 쉽게.
        //
        ////                allFloorNode[i].geometry = allFloorNode[i].copy() as? SCNGeometry//이거하면 새로생기게 됨.
                        allFloorNode[i].name = "floorBox\(i)"
                    }
        //
                    mainScene.rootNode.addChildNode(floors)//@

        //
        //

                    view.scene = mainScene
//                    animateTower()
//                    f1Dance()
//                    eDance(index: 0)
//                    nDance(index: 0)


                    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(gestureRecognize: )))
                    view.addGestureRecognizer(tapGesture)
//                    let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(gestureRecognize: )))
//                    view.addGestureRecognizer(panGesture)

                    setUpAction()
                    aniArray[1] = true
                    count += 1
                    addAction()
                }
        if !isFinalVC {
//            let label = UILabel()
//            label.textColor = UIColor.white
//            label.font = UIFont(name: "HelveticaNeue-ThinItalic", size: 30)
//            label.text = "Are you ready ?"
//            label.sizeToFit()
//            label.center.x = 130
//            label.frame.origin.y = self.view.bounds.height - 250
//            gameView?.addSubview(label)
//            let ang = toRadians(angle: Float(360))
            red.runAction(SCNAction.fadeOpacity(to: 1, duration: 1.6)){
                self.addButton(ment: "What is scenario..?")//좀있다 시작하려고
            }
            redBlink()
//            runAction(SCNAction.repeatForever(SCNAction.rotate(by: 1, around: SCNVector3(1,0,0), duration: 1)))
            
        }
        
        else if isFinalVC {
           
            red.runAction(SCNAction.fadeOpacity(to: 1, duration: 1.3)){
                DispatchQueue.main.async {
                    self.addButton(ment: "Next")//좀있다 시작하려고
                    self.label2 = UILabel()
                    self.label2.textColor = UIColor.white
                    self.label2.font = UIFont(name: "HelveticaNeue-ThinItalic", size: 40)
                    self.label2.text = "             "
                    self.label2.sizeToFit()
                    self.label2.center.x = self.view.bounds.height/6
                    self.label2.frame.origin.y = self.view.bounds.height - 300
                    self.label2.blinkFast()
                    self.gameView!.addSubview(self.label2)
                }
                
            }
            
            
        }
        
        }
//    func getLoadingLabel(string:String){
//        let label = UILabel()
//        label.textColor = UIColor.white
//        label.font = UIFont(name: "HelveticaNeue-ThinItalic", size: 40)
//        label.text = string
//        label.sizeToFit()
//        label.center.x = 200
//        label.frame.origin.y = view.bounds.height - 200
//        label.blinkFast()
//        gameView!.addSubview(label)
//
//        let label2 = UILabel()
//        label2.textColor = UIColor.white
//        label2.font = UIFont(name: "HelveticaNeue-ThinItalic", size: 40)
//        label2.text = "Let's look differently!"
//        label2.sizeToFit()
//        label2.center.x = 200
//        label2.frame.origin.y = view.bounds.height - 100
//        label2.blinkFast()
//        gameView!.addSubview(label2)
//
//    }
    
    @objc func didPressBack (sender: UIButton!) {
        
        
//        dismiss(animated: true, completion: nil)
//        if count+1 != 4 {
        if !isFinalVC{
                count += 1
                aniArray[count] = true
    //            print("\(count)")
            DispatchQueue.main.async {
                
                self.button.removeFromSuperview()
                self.addAction()
            }
        }
        else if isFinalVC{
            lastCount += 1
            DispatchQueue.main.async {
                self.button.removeFromSuperview()
            }
            if lastCount == 1 {
                GameSound.getBeforeLast(realCameraNode)
                red.runAction(SCNAction.fadeOpacity(to: 1, duration: 5.2)){
                    self.addButton(ment: "Next")//좀있다 시작하려고
                }
            }
            else if lastCount == 2 {
                GameSound.getRem(realCameraNode)
                DispatchQueue.main.async {
                    self.button.removeFromSuperview()
                    self.red.runAction(SCNAction.fadeOpacity(to: 1, duration: 1.7)){
                        self.addButton(ment: "Umm..")
                    }
                }
            }
            else if lastCount == 3 {
                
                
                DispatchQueue.main.async {
                    
//                    GameSound.getBeforeLast(self.realCameraNode)
                    
                    self.button.removeFromSuperview()
                    self.label2.removeFromSuperview()
                    self.label2.textColor = UIColor.white
                    self.label2.font = UIFont(name: "HelveticaNeue-ThinItalic", size: 35)
                    self.label2.text = "Let's look differently!"
                    self.label2.sizeToFit()
                    self.label2.center.x = self.view.bounds.height/6
                    self.label2.frame.origin.y = self.view.bounds.height - 100
                    self.label2.blinkFast()
                    self.gameView!.addSubview(self.label2)

                    let label = UILabel()
                    label.textColor = UIColor.white
                    label.font = UIFont(name: "HelveticaNeue-ThinItalic", size: 25)
                    label.text = "The end, thank you for playing."
                    label.sizeToFit()
                    label.center.x = self.view.bounds.height/2
                    label.frame.origin.y = self.view.bounds.height - 50
                    label.blinkFast()
                    self.gameView!.addSubview(label)
                    
                }
                print("정답공개")
                SCNTransaction.begin()
                SCNTransaction.animationDuration = 3
                SCNTransaction.completionBlock = {
                    self.red.runAction(SCNAction.fadeOpacity(to: 1, duration: 3)){
                        GameSound.music(self.realCameraNode)
                    }
                    GameSound.gethird_2(self.realCameraNode)
                }
                let finalCameraNode = mainScene.rootNode.childNode(withName: "finalCamera", recursively: false)!
    //            cinemaNode.position = finalCameraNode.position
    //            let youAreTheBest = mainScene.rootNode.childNode(withName: "youarethebset", recursively: false)!
                let finalBox = mainScene.rootNode.childNode(withName: "finalBox", recursively: false)!
                let camera = cinemaNode.childNode(withName: "cam2", recursively: false)!
                cinemaNode.position = SCNVector3(x: finalCameraNode.position.x, y: finalCameraNode.position.y+3, z: finalCameraNode.position.z)
                camera.constraints = [SCNLookAtConstraint(target: finalBox)]
    //            let ang = toRadians(angle: Float(-5))
    //            cinemaNode.localRotate(by:  SCNQuaternion(0, ang, 0, 1))
                
                SCNTransaction.commit()
                
            }
            
        }
            
    }
//
    func setUpAction(){
//        let moveAction1 = SCNAction.moveBy(x: -0.3, y: 0, z: 0.4, duration: 0.2)
//        let moveAction2 = SCNAction.moveBy(x: -0.1, y: 0, z: -01, duration: 0.2)
//        moveAction1.timingMode = .easeOut
//        moveAction2.timingMode = .easeIn
//        let action = SCNAction.sequence([moveAction1,moveAction2])
        driveAction = SCNAction.moveBy(x: -42, y: 0, z: 7, duration: 20)//25
        driveAction2 = SCNAction.moveBy(x: 0, y: -1, z: 0, duration: 3)
    }
        func addAction(){
            
            let rotate = SCNAction.rotate(by: 3, around: SCNVector3(x: 0, y: 1, z: 0), duration: 5)
            rotate.speed = 1
            driveAction.speed = 1/CGFloat(5/1) + 1.6
            driveAction2.speed = 1/CGFloat(5/1) + 1
    //        boxNode.runAction(driveAction2)
            //@@
            if aniArray[2] == true {//시작
//                let animationObject:CAAnimation = animationFromSceneNamed(path: "Sd")!
                
//                animationObject.delegate = self
//                animationObject.fadeInDuration = 0.2
//                animationObject.fadeOutDuration = 0.2
//                animationObject.usesSceneTimeBase = false
//                animationObject.repeatCount = 0
//                animationObject.repeatCount = Float.greatestFiniteMagnitude
//                let walkAnimation = animationObject
//                playerDetailNode.addAnimation(walkAnimation, forKey: "walk")
//                DispatchQueue.main.async {
                GameSound.vcFirst(self.realCameraNode)
//                GameSound.lightsec_0(self.cinemaNode)
//                }
                
                //사람 이동.
                boxPerson.runAction(driveAction){
                    self.addButton(ment: "Next")
                    self.playerDetailNode.removeAllAnimations()
                }
                
                
                //@@카메라는 옮길때 무조건 랜더함수나 애니메이션 붙여야 움직인다.
//                cinemaNode.constraints = [SCNLookAtConstraint(target: personNode)]
                SCNTransaction.begin()
                SCNTransaction.animationDuration = 18
                cinemaNode.position = decoBox.position
                let ang = toRadians(angle: Float(-5))
                cinemaNode.localRotate(by:  SCNQuaternion(0, ang, 0, 1))
                SCNTransaction.commit()

                
                aniArray[2] = false
            }

            //{
            if aniArray[3] == true {//돌기
                GameSound.vcSecond(realCameraNode)
                //realcamera로 해야하지 cameranode로 하면 안된다.
//                print("sp",sphere.position)
                SCNTransaction.begin()
                SCNTransaction.animationDuration = 7
//                let scn = SCNNode()
//                scn.position = SCNVector3(x: 0, y: 0, z: 0)
                realCameraNode.constraints = [SCNLookAtConstraint(target: floors)]
                SCNTransaction.commit()
                
                
                
                SCNTransaction.begin()
                
                let ang = toRadians(angle: Float(-30))
                let ang2 = toRadians(angle: Float(-7))
                cinemaNode.childNode(withName: "inst", recursively: false)!.rotate(by: SCNQuaternion(ang2, ang, 0, 1), aroundTarget: cinemaNode.position)
                SCNTransaction.animationDuration = 8//18
                cinemaNode.position = cameraNode2.position
                SCNTransaction.commit()
 
                
                
               
                
//                DispatchQueue.main.async {
//                    self.button.removeFromSuperview()
//                }
//                button.titleLabel?.font = UIFont(name: "HelveticaNeue-ThinItalic", size: 30)
//                button.titleLabel?.blink()
//                eDance(index: 0)// 수정필
//                nDance(index: 0)// 수정필

                self.boxPerson.runAction(rotate)
//                {
//                    self.addButton(ment: "Next")
//                }
                // 모두가 회전
                self.personNode.runAction(self.driveAction2)//사람내려옴
                self.boxNode.runAction(self.driveAction2){
                    self.boxNode.runAction(SCNAction.fadeOpacity(to: 0, duration: 4))
                    self.floors.runAction(SCNAction.scale(by: 2, duration: 6))
                    self.personNode.runAction(.rotate(by: -1.9, around: SCNVector3(x: 0, y: 1, z: 0), duration: 3)){
                        self.addButton(ment: "Next")
                    }
                }
                aniArray[3] = false
        }
            if aniArray[4] == true {
                GameSound.vcThird(realCameraNode)
//                self.addButton(ment: "Next")
//                DispatchQueue.main.async {
//                    self.button.removeFromSuperview()
//                }
//                addButton(ment: "gkgksdsd")
//                button.titleLabel?.font = UIFont(name: "HelveticaNeue-ThinItalic", size: 30)
//                button.titleLabel?.blink()
                eDance(index: 0)// 수정필
//               nDance(index: 0)// 수정필
                aniArray[4] = false
            }
            if aniArray[5] == true {
                GameSound.vcFourth(realCameraNode)
//                self.addButton(ment: "Next")
//                DispatchQueue.main.async {
//                    self.button.removeFromSuperview()
//                }
//                addButton(ment: "gksdsdsdsdgk")
//                button.titleLabel?.font = UIFont(name: "HelveticaNeue-ThinItalic", size: 30)
//                button.titleLabel?.blink()
                animateTower()
                
                red.runAction(SCNAction.fadeOpacity(to: 1, duration: 3.3)){
                    print("6?")
                    self.addButton(ment: "Next")//좀있다 시작하려고
                }
                

                f1Dance()
                aniArray[5] = false
            }
            if aniArray[6] == true {
                GameSound.vcFifth(realCameraNode)
//                DispatchQueue.main.async {
//                    self.button.removeFromSuperview()
//                }
                //@@
                red.runAction(SCNAction.fadeOpacity(to: 1, duration: 4.5)){
                    self.addButton(ment: "Next")//좀있다 시작하려고
                }
                
//                print("준비가되면 enjoy 박스를 를 줄러주세요!")
//                addButton(ment: "gkgaaaaak")
//                button.titleLabel?.font = UIFont(name: "HelveticaNeue-ThinItalic", size: 30)
//                button.titleLabel?.blink()
//                button.removeFromSuperview()
                aniArray[6] = false
                
            }
            if aniArray[7] == true {
                GameSound.vcSixth(realCameraNode)
                
                red.runAction(SCNAction.fadeOpacity(to: 1, duration: 2.3)){
                    self.blingBling()
                    self.youCanEnd = true//enjoy 클릭되어있을때 나가지는 오류 막으려고
                    print("i can end")
                }
                theEnd = true
            }




        }

//        @objc func handlePan(gestureRecognize: UIPanGestureRecognizer) {
//
//            let xTranslation = Float(gestureRecognize.translation(in: gestureRecognize.view!).x)
//
//            //HANDLE PAN GESTURE HERE
//            /////////////////////////
//
//            if gestureRecognize.state == UIGestureRecognizer.State.began || gestureRecognize.state == UIGestureRecognizer.State.changed {
//
//                floors.panBeginMoved(xTranslationToCheckNegative: xTranslation)
//            }
//
//            var angle:Float = (xTranslation * Float(M_PI)) / 700.0
//            let angleRatio = angle / Float(M_PI_4/2)
//            angle += floors.rotationCurrent
//            floors.rotation = SCNVector4(0,1,0,angle)
//
//            if gestureRecognize.state == UIGestureRecognizer.State.ended || gestureRecognize.state == UIGestureRecognizer.State.cancelled {
//                floors.realign(angleRatio: angleRatio)
//            }
//
//        }
        func eDance(index:Int){
            SCNTransaction.begin()
            SCNTransaction.animationDuration = 0.05
            SCNTransaction.animationTimingFunction = (CAMediaTimingFunction(name: .easeInEaseOut))
            let material = specialNodeE[index].geometry?.firstMaterial!
            material?.emission.contents = UIColor.purple

            SCNTransaction.completionBlock = { () -> Void in

                SCNTransaction.begin()
                SCNTransaction.animationDuration = 0.05
                SCNTransaction.animationTimingFunction = (CAMediaTimingFunction(name: .easeInEaseOut))
                material?.emission.contents = UIColor.red

                SCNTransaction.completionBlock = ({ () -> Void in
                    if index + 1 == self.specialNodeE.count {

                        self.nDance(index: 0)//반복
                    }
                    else {
                        self.eDance(index: index+1)
                    }

                })

                SCNTransaction.commit()
            }

            SCNTransaction.commit()
        }

        func nDance(index:Int){


            SCNTransaction.begin()
            SCNTransaction.animationDuration = 0.05
            SCNTransaction.animationTimingFunction = (CAMediaTimingFunction(name: .easeInEaseOut))
            let material = specialNodeN[index].geometry?.firstMaterial!
            material?.emission.contents = UIColor.purple

            SCNTransaction.completionBlock = { () -> Void in

                SCNTransaction.begin()
                SCNTransaction.animationDuration = 0.05
                SCNTransaction.animationTimingFunction = (CAMediaTimingFunction(name: .easeInEaseOut))
                material?.emission.contents = UIColor.green

                SCNTransaction.completionBlock = ({ () -> Void in
                    if index + 1 == self.specialNodeN.count {

//                        self.eDance(index: 0)//반복
                        self.jDance(index: 0)
                    }
                    else {
                        self.nDance(index: index+1)
                    }

                })

                SCNTransaction.commit()
            }

            SCNTransaction.commit()
        }

    func jDance(index:Int){


        SCNTransaction.begin()
        SCNTransaction.animationDuration = 0.05
        SCNTransaction.animationTimingFunction = (CAMediaTimingFunction(name: .easeInEaseOut))
        let material = specialNodeJ[index].geometry?.firstMaterial!
        material?.emission.contents = UIColor.purple

        SCNTransaction.completionBlock = { () -> Void in

            SCNTransaction.begin()
            SCNTransaction.animationDuration = 0.05
            SCNTransaction.animationTimingFunction = (CAMediaTimingFunction(name: .easeInEaseOut))
            material?.emission.contents = UIColor.cyan

            SCNTransaction.completionBlock = ({ () -> Void in
                if index + 1 == self.specialNodeJ.count {
                    self.addButton(ment: "Next")

//                        self.eDance(index: 0)//반복
                    self.oDance(index: 0)
                }
                else {
                    self.jDance(index: index+1)
                }

            })

            SCNTransaction.commit()
        }

        SCNTransaction.commit()
    }
    func oDance(index:Int){


        SCNTransaction.begin()
        SCNTransaction.animationDuration = 0.05
        SCNTransaction.animationTimingFunction = (CAMediaTimingFunction(name: .easeInEaseOut))
        let material = specialNodeO[index].geometry?.firstMaterial!
        material?.emission.contents = UIColor.purple

        SCNTransaction.completionBlock = { () -> Void in

            SCNTransaction.begin()
            SCNTransaction.animationDuration = 0.05
            SCNTransaction.animationTimingFunction = (CAMediaTimingFunction(name: .easeInEaseOut))
            material?.emission.contents = UIColor.orange

            SCNTransaction.completionBlock = ({ () -> Void in
                if index + 1 == self.specialNodeO.count {

//                        self.eDance(index: 0)//반복
                    self.yDance(index: 0)
                }
                else {
                    self.oDance(index: index+1)
                }

            })

            SCNTransaction.commit()
        }

        SCNTransaction.commit()
    }

    func yDance(index:Int){


        SCNTransaction.begin()
        SCNTransaction.animationDuration = 0.05
        SCNTransaction.animationTimingFunction = (CAMediaTimingFunction(name: .easeInEaseOut))
        let material = specialNodeY[index].geometry?.firstMaterial!
        material?.emission.contents = UIColor.purple

        SCNTransaction.completionBlock = { () -> Void in

            SCNTransaction.begin()
            SCNTransaction.animationDuration = 0.05
            SCNTransaction.animationTimingFunction = (CAMediaTimingFunction(name: .easeInEaseOut))
            material?.emission.contents = UIColor.magenta

            SCNTransaction.completionBlock = ({ () -> Void in
                if index + 1 == self.specialNodeY.count {

//                        self.eDance(index: 0)//반복
                    

//                    self.eDance(index: 0)//또다시 반복은 하지 말자 정신없다
//                    if self.onceBool2 {
//                        self.onceBool2 = false
//                        self.addButton(ment: "Next")
//                    }

                }
                else {
                    self.yDance(index: index+1)
                }

            })

            SCNTransaction.commit()
        }

        SCNTransaction.commit()
    }

    func blingBling(){
        SCNTransaction.begin()
        SCNTransaction.animationDuration = 0.4
        SCNTransaction.animationTimingFunction = (CAMediaTimingFunction(name: .easeInEaseOut))
        let material = f1Node[0].geometry?.firstMaterial!
        material?.emission.contents = UIColor.purple

        SCNTransaction.completionBlock = { () -> Void in

            SCNTransaction.begin()
            SCNTransaction.animationDuration = 0.4
            SCNTransaction.animationTimingFunction = (CAMediaTimingFunction(name: .easeInEaseOut))
            material?.emission.contents = UIColor.yellow

            SCNTransaction.completionBlock = ({ () -> Void in
//                self.redBlink()
                self.blingBling()
            })

            SCNTransaction.commit()
        }

        SCNTransaction.commit()
    }
    func redBlink(){


        SCNTransaction.begin()
        SCNTransaction.animationDuration = 0.1
        SCNTransaction.animationTimingFunction = (CAMediaTimingFunction(name: .easeInEaseOut))
        let material = red.geometry?.firstMaterial!
        material?.emission.contents = UIColor.red

        SCNTransaction.completionBlock = { () -> Void in

            SCNTransaction.begin()
            SCNTransaction.animationDuration = 0.1
            SCNTransaction.animationTimingFunction = (CAMediaTimingFunction(name: .easeInEaseOut))
            material?.emission.contents = UIColor.black

            SCNTransaction.completionBlock = ({ () -> Void in
                self.redBlink()
            })

            SCNTransaction.commit()
        }

        SCNTransaction.commit()
    }

        func f1Dance(){//
            SCNTransaction.begin()
            SCNTransaction.animationDuration = 2
            SCNTransaction.animationTimingFunction = (CAMediaTimingFunction(name: .easeInEaseOut))
            f1Node[0].rotation = SCNVector4Make(0, 1, 0, .pi/16)
            allFloorNode[4].position = SCNVector3(x: allFloorNode[4].position.x, y: allFloorNode[4].position.y, z: allFloorNode[4].position.z + 0.4)
            SCNTransaction.completionBlock = { () -> Void in
               
                SCNTransaction.begin()
                SCNTransaction.animationDuration = 2
                SCNTransaction.animationTimingFunction = (CAMediaTimingFunction(name: .easeInEaseOut))

    //            self.towerAttach.position = SCNVector3(self.towerAttach.position.x, self.towerAttach.position.y - 0.1, self.towerAttach.position.z)
                self.f1Node[0].rotation = SCNVector4Make(0, 1, 0, -.pi/16)
                self.allFloorNode[4].position = SCNVector3(x: self.allFloorNode[4].position.x, y: self.allFloorNode[4].position.y, z: self.allFloorNode[4].position.z - 0.4)
                SCNTransaction.completionBlock = ({ () -> Void in
                    
                    self.f1Dance()
                    //@@
//                    if !self.onceBool {
//                        self.onceBool = true
//                        self.addButton(ment: "Next")
//                    }


                })

                SCNTransaction.commit()
            }
            SCNTransaction.commit()

        }

        func animateTower(){
            SCNTransaction.begin()
            SCNTransaction.animationDuration = 3
            SCNTransaction.animationTimingFunction = (CAMediaTimingFunction(name: .easeInEaseOut))

    //        towerAttach.position = SCNVector3(towerAttach.position.x, towerAttach.position.y + 0.1, towerAttach.position.z)
            floors.rotation = SCNVector4Make(0, 1, 0, .pi/18)

            SCNTransaction.completionBlock = { () -> Void in

                SCNTransaction.begin()
                SCNTransaction.animationDuration = 3
                SCNTransaction.animationTimingFunction = (CAMediaTimingFunction(name: .easeInEaseOut))

    //            self.towerAttach.position = SCNVector3(self.towerAttach.position.x, self.towerAttach.position.y - 0.1, self.towerAttach.position.z)
                self.floors.rotation = SCNVector4Make(0, 1, 0, -.pi/18)

                SCNTransaction.completionBlock = ({ () -> Void in

                    self.animateTower()
                })
                SCNTransaction.commit()
            }
            SCNTransaction.commit()
        }

        @objc func handleTap(gestureRecognize: UIGestureRecognizer) {
            // retrieve the SCNView
            let scnView = gameView!
            print("d")
//            GameSound.welcom(cinemaNode)
//            GameSound.explosion(cinemaNode)
//            GameSound.explosion(cinemaNode)
            
            // check what nodes are tapped
            let p = gestureRecognize.location(in: scnView)
            let hitResults = scnView.hitTest(p, options: nil)
            // check that we clicked on at least one object
            if hitResults.count > 0 {
                // retrieved the first clicked object
                let result: AnyObject! = hitResults[0]
                var specialCase = false
                let resultNode = result.node! as SCNNode
                if resultNode.name == "floorBox0" {
//                    gamesound.enjoy(cinemaNode)
                    GameSound.enjoy(realCameraNode)
                    
                }
              
                if resultNode.name == "floorBox8"{
                    GameSound.scenario(realCameraNode)
                }
                if resultNode.name == "floorBox13"{
                    GameSound.welcom(realCameraNode)
                }
                if resultNode.name == "floorBox10"{
                    GameSound.this(realCameraNode)
                }
                if resultNode.name == "floorBox12"{
                    GameSound._is(realCameraNode)
                }
                
                print("qc,\(resultNode.name)")
                if let name = resultNode.name {
                    
                    var node = SCNNode()
                    for i in allFloorNode {
                        if name == i.name {
                            node = i
                        }
                        if name == "floorBox0"{
                            if youCanEnd {
                                specialCase = true
                            }
                            
                            
                                                    }
                    }

                    print("nG",node.name, node.geometry?.name)
                    let material = node.geometry?.firstMaterial!

                    //position기억하는 골렘앱처럼 포지션은 가져오는 걸 해볼까?
                    //누르면 소리나게?
                    //말하는것처럼F
                    SCNTransaction.begin()
    //                SCNTransaction.setAnimationDuration(0.0)
                    SCNTransaction.animationDuration = 1.5
    //                SCNTransaction.setAnimationDuration(0.0)
                    SCNTransaction.completionBlock = {
                        ()-> Void in
                        SCNTransaction.begin()

                        if !specialCase{
                           
                            SCNTransaction.animationDuration = 1.5
                            node.position = SCNVector3(x: node.position.x, y: node.position.y , z: node.position.z-0.5)
                        }
                        else if specialCase  {
                            print("welc")
//                            GameSound.enjoy(self.cinemaNode)
                            if self.theEnd {
                                SCNTransaction.animationDuration = 7
                                let vc = LoadingViewController()
                                vc.modalPresentationStyle = .overFullScreen

                                self.present(vc, animated: true)
                            }
                            else {
                                SCNTransaction.animationDuration = 1.5
                                node.position = SCNVector3(x: node.position.x, y: node.position.y , z: node.position.z-6)
                            }
                        }
                        material?.emission.contents = UIColor.orange

                        SCNTransaction.commit()
                    }

//                    GameSound.enjoy(self.realCameraNode)
                    material?.emission.contents = UIColor.red
                    if specialCase {
                        node.position = SCNVector3(x: node.position.x, y: node.position.y , z: node.position.z+6)
                    }
                    else if !specialCase {
                        node.position = SCNVector3(x: node.position.x, y: node.position.y , z: node.position.z+0.5)
                    }


                    SCNTransaction.commit()


    //                print(player2)
                   // player.playKey(keyName: name)
                    // highlight it


                    //THIS IS WHERE YOU HANDLE THE SCNTRANSACTION
                    /////////////////////////////////////////////

                    SCNTransaction.begin()
    //                SCNTransaction.setAnimationDuration(0.0)
                    SCNTransaction.animationDuration = 0.0
    //                SCNTransaction.setAnimationDuration(0.0)
                    SCNTransaction.completionBlock = {
                        ()-> Void in
                        SCNTransaction.begin()
                        SCNTransaction.animationDuration = 0.5

    //                    material.emission.contents = UIColor.black
    //                    key.position = SCNVector3(x: key.position.x, y: key.position.y - 0.2, z: key.position.z)

                        SCNTransaction.commit()
                    }


    //                material.emission.contents = UIColor.red
    //                key.position = SCNVector3(x: key.position.x, y: key.position.y + 0.2, z: key.position.z)

                    SCNTransaction.commit()


                }
            }
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


extension ViewController: SCNSceneRendererDelegate {

    func updateMoving(){
        if boxPerson.position.x <= 8 && boxPerson.position.z >= 7{
            boxPerson.position = SCNVector3(x: 7, y: 0, z: 7)
        }
    }
    func renderer(_ renderer: SCNSceneRenderer, didApplyAnimationsAtTime time: TimeInterval) {

//        updatePositions()
//        updateTraffic()
        updateMoving()
    }



}

//extension ViewController {
//    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: aranchor) {
//
//       //1. Check We Have The Image Anchor
//       guard let imageAnchor = anchor as? ARImageAnchor else { return }
//
//       //2. Get The Reference Image
//       let referenceImage = imageAnchor.referenceImage
//
//       //1. Create The Plane Geometry With Our Width & Height Parameters
//       let planeGeometry = SCNPlane(width: referenceImage.physicalSize.width,
//                            height: referenceImage.physicalSize.height)
//
//       //2. Create A New Material
//       let material = SCNMaterial()
//
//       DispatchQueue.main.async {
//           //3. Create The New Clickable View
//           let clickableElement = ClickableView(frame: CGRect(x: 0, y: 0,
//                                                              width: 300,
//                                                              height: 300))
//           clickableElement.tag = 1
//
//           //4. Add The Clickable View As A Materil
//           material.diffuse.contents = clickableElement
//       }
//
//       //5. Create The Plane Node
//       let planeNode = SCNNode(geometry: planeGeometry)
//
//       planeNode.geometry?.firstMaterial = material
//
//       planeNode.opacity = 0.25
//
//       planeNode.eulerAngles.x = -.pi / 2
//
//       //6. Add It To The Scene
//       node.addChildNode(planeNode)
//   }
//}
