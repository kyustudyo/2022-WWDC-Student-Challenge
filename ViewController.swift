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
            self.button.titleLabel?.blinkFast()
            self.button.addTarget(self, action: #selector(self.didPressBack), for: .touchUpInside)
            self.button.center.x = 150
            self.button.frame.origin.y = self.view.bounds.height - 200
            self.gameView!.addSubview(self.button)
        }
    }

    var gameView : SCNView? = SCNView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
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

        if let view = gameView {
            self.view.addSubview(view)
            view.scene = mainScene
                    view.isPlaying = true
                    view.backgroundColor = UIColor.gray
                    view.antialiasingMode = SCNAntialiasingMode.multisampling4X
            print(mainScene.rootNode.childNodes)
            boxPerson = mainScene.rootNode.childNode(withName: "boxPerson", recursively: false)!
            personNode = boxPerson.childNode(withName: "person", recursively: false)!
            playerDetailNode = personNode.childNode(withName: "mixamorig_Hips", recursively: true)!
            boxNode = boxPerson.childNode(withName: "downBox", recursively: false)!
            decoBox = mainScene.rootNode.childNode(withName: "box", recursively: false)!
            cinemaNode = mainScene.rootNode.childNode(withName: "cinemaCamera", recursively: true)!
            realCameraNode = cinemaNode.childNode(withName: "cam2", recursively: false)!
            cameraNode2 = mainScene.rootNode.childNode(withName: "cam3", recursively: true)!
            red = cinemaNode.childNode(withName: "red", recursively: true)!
            red.opacity = 0
                    for i in 1...5 {//뺏어가기도 하는구나 addchild하면.
                        let floor = mainScene.rootNode.childNode(withName: "f\(i)", recursively: true)!
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
                    for i in 0..<allFloorNode.count {//이름 붙여서 호명 쉽게.
        //allFloorNode[i].geometry = allFloorNode[i].copy() as? SCNGeometry//이거하면 새로생기게 됨.
                        allFloorNode[i].name = "floorBox\(i)"
                    }
                    mainScene.rootNode.addChildNode(floors)//@
                    view.scene = mainScene
                    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(gestureRecognize: )))
                    view.addGestureRecognizer(tapGesture)
                    setUpAction()
                    aniArray[1] = true
                    count += 1
                    addAction()
                }
        if !isFinalVC {
            red.runAction(SCNAction.fadeOpacity(to: 1, duration: 1.6)){
                self.addButton(ment: "What is scenario..?")//좀있다 시작하려고
            }
            redBlink()
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
    @objc func didPressBack (sender: UIButton!) {
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
                let finalBox = mainScene.rootNode.childNode(withName: "finalBox", recursively: false)!
                let camera = cinemaNode.childNode(withName: "cam2", recursively: false)!
                cinemaNode.position = SCNVector3(x: finalCameraNode.position.x, y: finalCameraNode.position.y+3, z: finalCameraNode.position.z)
                camera.constraints = [SCNLookAtConstraint(target: finalBox)]
                SCNTransaction.commit()
                
            }
            
        }
            
    }

    func setUpAction(){
        driveAction = SCNAction.moveBy(x: -42, y: 0, z: 7, duration: 20)//25
        driveAction2 = SCNAction.moveBy(x: 0, y: -1, z: 0, duration: 3)
    }
        func addAction(){
            
            let rotate = SCNAction.rotate(by: 3, around: SCNVector3(x: 0, y: 1, z: 0), duration: 5)
            rotate.speed = 1
            driveAction.speed = 1/CGFloat(5/1) + 1.6
            driveAction2.speed = 1/CGFloat(5/1) + 1
            if aniArray[2] == true {//시작
                GameSound.vcFirst(self.realCameraNode)
                //사람 이동.
                boxPerson.runAction(driveAction){
                    self.addButton(ment: "Next")
                    self.playerDetailNode.removeAllAnimations()
                }
                //@@카메라는 옮길때 무조건 랜더함수나 애니메이션 붙여야 움직인다.
                SCNTransaction.begin()
                SCNTransaction.animationDuration = 18
                cinemaNode.position = decoBox.position
                let ang = toRadians(angle: Float(-5))
                cinemaNode.localRotate(by:  SCNQuaternion(0, ang, 0, 1))
                SCNTransaction.commit()
                aniArray[2] = false
            }
            if aniArray[3] == true {//돌기
                GameSound.vcSecond(realCameraNode)
                //realcamera로 해야하지 cameranode로 하면 안된다.
                SCNTransaction.begin()
                SCNTransaction.animationDuration = 7
                realCameraNode.constraints = [SCNLookAtConstraint(target: floors)]
                SCNTransaction.commit()
                SCNTransaction.begin()
                let ang = toRadians(angle: Float(-30))
                let ang2 = toRadians(angle: Float(-7))
                cinemaNode.childNode(withName: "inst", recursively: false)!.rotate(by: SCNQuaternion(ang2, ang, 0, 1), aroundTarget: cinemaNode.position)
                SCNTransaction.animationDuration = 8//18
                cinemaNode.position = cameraNode2.position
                SCNTransaction.commit()
                self.boxPerson.runAction(rotate)
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
                eDance(index: 0)// 수정필
                aniArray[4] = false
            }
            if aniArray[5] == true {
                GameSound.vcFourth(realCameraNode)
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

                red.runAction(SCNAction.fadeOpacity(to: 1, duration: 4.5)){
                    self.addButton(ment: "Next")//좀있다 시작하려고
                }
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

        func f1Dance(){
            SCNTransaction.begin()
            SCNTransaction.animationDuration = 2
            SCNTransaction.animationTimingFunction = (CAMediaTimingFunction(name: .easeInEaseOut))
            f1Node[0].rotation = SCNVector4Make(0, 1, 0, .pi/16)
            allFloorNode[4].position = SCNVector3(x: allFloorNode[4].position.x, y: allFloorNode[4].position.y, z: allFloorNode[4].position.z + 0.4)
            SCNTransaction.completionBlock = { () -> Void in
               
                SCNTransaction.begin()
                SCNTransaction.animationDuration = 2
                SCNTransaction.animationTimingFunction = (CAMediaTimingFunction(name: .easeInEaseOut))
                self.f1Node[0].rotation = SCNVector4Make(0, 1, 0, -.pi/16)
                self.allFloorNode[4].position = SCNVector3(x: self.allFloorNode[4].position.x, y: self.allFloorNode[4].position.y, z: self.allFloorNode[4].position.z - 0.4)
                SCNTransaction.completionBlock = ({ () -> Void in
                    self.f1Dance()
                })

                SCNTransaction.commit()
            }
            SCNTransaction.commit()

        }

        func animateTower(){
            SCNTransaction.begin()
            SCNTransaction.animationDuration = 3
            SCNTransaction.animationTimingFunction = (CAMediaTimingFunction(name: .easeInEaseOut))
            floors.rotation = SCNVector4Make(0, 1, 0, .pi/18)

            SCNTransaction.completionBlock = { () -> Void in

                SCNTransaction.begin()
                SCNTransaction.animationDuration = 3
                SCNTransaction.animationTimingFunction = (CAMediaTimingFunction(name: .easeInEaseOut))
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
                    material?.emission.contents = UIColor.red
                    if specialCase {
                        node.position = SCNVector3(x: node.position.x, y: node.position.y , z: node.position.z+6)
                    }
                    else if !specialCase {
                        node.position = SCNVector3(x: node.position.x, y: node.position.y , z: node.position.z+0.5)
                    }
                    SCNTransaction.commit()
                    SCNTransaction.begin()
                    SCNTransaction.animationDuration = 0.0
                    SCNTransaction.completionBlock = {
                        ()-> Void in
                        SCNTransaction.begin()
                        SCNTransaction.animationDuration = 0.5
                        SCNTransaction.commit()
                    }
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
        updateMoving()
    }
}
