//
//  StartViewController.swift
//  wwwdc
//
//  Created by Hankyu Lee on 2022/04/15.
//

import Foundation
//
//  ViewController.swift
//  wwwdc
//
//  Created by Hankyu Lee on 2022/04/13.
//

import Foundation
import UIKit
import SceneKit
import SpriteKit

import UIKit
import QuartzCore
import SceneKit
import AVFoundation

extension UIView{
     func blink() {
         self.alpha = 0.2
         UIView.animate(withDuration: 1, delay: 0.0, options: [.curveLinear, .repeat, .autoreverse], animations: {self.alpha = 1.0}, completion: nil)
     }
    func blinkFast() {
        self.alpha = 0.5
        UIView.animate(withDuration: 0.4, delay: 0.0, options: [.curveLinear, .repeat, .autoreverse], animations: {self.alpha = 1.0}, completion: nil)
    }
    
    
}

class StartViewController: UIViewController {
//
    var gameView : SCNView? = SCNView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
    var mainScene:SCNScene!
    var floors = SCNNode()
    var f1Node = [SCNNode]()
    var allFloorNode = [SCNNode]()
    var boxPerson : SCNNode!
    var personNode : SCNNode!
    var boxNode : SCNNode!
    var cinemaCameraNode : SCNNode!
    var driveAction: SCNAction!
    var driveAction2: SCNAction!
    var gameState = GameState.menu
    var count = 0
    var tmpNode = SCNNode()
    var specialNodeE = [SCNNode]()
    var specialNodeN = [SCNNode]()
    var aniArray:[Bool] = Array(repeating: false, count: 100)
    var emptyNode = SCNNode()
    var button  = UIButton()

    override func viewDidLoad() {

        super.viewDidLoad()

        let paths = Bundle.main.paths(forResourcesOfType: "scn", inDirectory: nil)
        print(paths)
        for path in paths {
            if path.contains("camera") {
                do {
                mainScene = try SCNScene(url: URL(fileURLWithPath: path),options: nil)
                } catch {
                    print("no wall")
                }
            }
        }
        
        DispatchQueue.main.async {

            let label2 = UILabel()
            label2.textColor = UIColor.white
            label2.font = UIFont(name: "HelveticaNeue-ThinItalic", size: 25)
            label2.text = "Simulator volume up plz 🔊 "
            label2.sizeToFit()
            label2.center.x = self.view.bounds.height/4
            label2.frame.origin.y = self.view.bounds.height - 300
            self.gameView!.addSubview(label2)
            
            let label = UILabel()
            label.textColor = UIColor.white
            label.font = UIFont(name: "HelveticaNeue-ThinItalic", size: 25)
            label.text = "Are you ready ?"
            label.sizeToFit()
            label.center.x = self.view.bounds.height/4
            label.frame.origin.y = self.view.bounds.height - 250
            self.gameView!.addSubview(label)

            self.button = UIButton(type: .system)
            self.button.tintColor = UIColor.white
            self.button.titleLabel?.font = UIFont(name: "HelveticaNeue-ThinItalic", size: 30)
            self.button.titleLabel?.blink()
            self.button.setTitle(" - yeah", for: .normal)
            self.button.sizeToFit()
            self.button.addTarget(self, action: #selector(self.didPressBack), for: .touchUpInside)
            self.button.center.x = self.view.bounds.height/6
            self.button.frame.origin.y = self.view.bounds.height - 200
            self.gameView!.addSubview(self.button)

        }


        if let view = gameView {
            self.view.addSubview(view)
            view.scene = mainScene
//            view.allowsCameraControl = true
            view.allowsCameraControl = false

                    view.isPlaying = true
                    view.backgroundColor = UIColor.gray
                    view.antialiasingMode = SCNAntialiasingMode.multisampling4X

                    boxPerson = mainScene.rootNode.childNode(withName: "hands", recursively: false)!

                    personNode = boxPerson.childNode(withName: "handAni", recursively: false)!
                    tmpNode.addChildNode(personNode)

                    boxNode = boxPerson.childNode(withName: "hand", recursively: false)!
                    cinemaCameraNode = mainScene.rootNode.childNode(withName: "cinemaCamera", recursively: false)!

            cinemaCameraNode.childNode(withName: "rotate", recursively: false)!.runAction(SCNAction.repeatForever(SCNAction.rotate(by: 1, around: SCNVector3(1,0,0), duration: 1)))

            emptyNode = mainScene.rootNode.childNode(withName: "emptyWhichIsNeeded", recursively: false)!

                    for i in 0..<allFloorNode.count {//이름 붙여서 호명 쉽게.

                        allFloorNode[i].name = "floorBox\(i)"
                    }
                    mainScene.rootNode.addChildNode(floors)//@
            mainScene.rootNode.addChildNode(emptyNode)
                    view.scene = mainScene

                    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(gestureRecognize: )))
                    view.addGestureRecognizer(tapGesture)
                }
            GameSound.music(self.mainScene.rootNode.childNode(withName: "camera", recursively: false)!)
        }
    @objc func didPressBack (sender: UIButton!) {
//        dismiss(animated: true, completion: nil)
        count += 1
        aniArray[count] = true
        print("\(count)")
        boxNode.opacity = 0
        cinemaCameraNode.childNode(withName: "sp", recursively: false)!.geometry?.firstMaterial?.diffuse.contents = UIColor(red: 253/255, green: 253/255, blue: 150/255, alpha: 1)
        if count == 1 {
            mainScene.rootNode.addChildNode(tmpNode)
            tmpNode.addChildNode(cinemaCameraNode)
            restAction()
        }
        DispatchQueue.main.async {
            self.button.layer.removeAllAnimations()
            self.button.isHidden = true
        }

    }
    //아래 다 애니메이션
    func setUpAction(){
        driveAction = SCNAction.moveBy(x: -14, y: 0, z: 7, duration: 20)
        driveAction2 = SCNAction.moveBy(x: 0, y: -1, z: 0, duration: 3)
    }

    func restAction(){
        if aniArray[1] == true {


            SCNTransaction.begin()
            SCNTransaction.animationDuration = 1//2
            emptyNode.position  = SCNVector3(x: emptyNode.position.x, y: emptyNode.position.y, z: emptyNode.position.z + 30)
            SCNTransaction.completionBlock = { ()->Void in
                SCNTransaction.begin()
//                print("2")
                SCNTransaction.animationDuration = 1
                SCNTransaction.animationTimingFunction = (CAMediaTimingFunction(name: .easeInEaseOut))
                self.emptyNode.position  = SCNVector3(x: self.emptyNode.position.x, y: self.emptyNode.position.y, z: self.emptyNode.position.z - 30)
                SCNTransaction.completionBlock = {

                    self.addAction()
                    print("3")
                }
                SCNTransaction.commit()
            }
            SCNTransaction.commit()
        }
    }
        func addAction(){
            let rotate = SCNAction.rotate(by: 3, around: SCNVector3(x: 0, y: 1, z: 0), duration: 5)
            rotate.speed = 1
            if aniArray[1] == true {
                tmpNode.addChildNode(cinemaCameraNode)
                SCNTransaction.begin()
                SCNTransaction.animationDuration = 1//3
                SCNTransaction.animationTimingFunction = (CAMediaTimingFunction(name: .easeInEaseOut))
                tmpNode.position = SCNVector3(x: tmpNode.position.x, y: tmpNode.position.y+2, z: tmpNode.position.z)
                SCNTransaction.completionBlock = { () -> Void in

                    SCNTransaction.begin()
                    SCNTransaction.animationDuration = 1//4
                    SCNTransaction.animationTimingFunction = (CAMediaTimingFunction(name: .easeInEaseOut))
                    self.tmpNode.position = SCNVector3(x: self.tmpNode.position.x+8, y: self.tmpNode.position.y, z: self.tmpNode.position.z )
                    SCNTransaction.completionBlock = ({ () -> Void in
//                        self.f1Dance()
                        print("all end")
                        self.mainScene.rootNode.childNode(withName: "camera", recursively: false)!.removeFromParentNode()
//                        self.playAudio()

                        let vc = ViewController()
                        vc.modalPresentationStyle = .overFullScreen
                        self.present(vc, animated: true)
                        
                    })

                    SCNTransaction.commit()
                }
                SCNTransaction.commit()
            }
        }
    
    func playAudio() {
        var soundEffect: AVAudioPlayer?
            let url = Bundle.main.url(forResource: "voice", withExtension: "wav")
            if let url = url{
                do {
                    soundEffect = try AVAudioPlayer(contentsOf: url)

                    guard let sound = soundEffect else { return }
                    sound.prepareToPlay()
                    sound.play()
                } catch let error {
                    print(error.localizedDescription)
                }
            }
        }
        func nDance(index:Int){
            SCNTransaction.begin()
            SCNTransaction.animationDuration = 0.1
            SCNTransaction.animationTimingFunction = (CAMediaTimingFunction(name: .easeInEaseOut))
            let material = specialNodeN[index].geometry?.firstMaterial!
            material?.emission.contents = UIColor.orange

            SCNTransaction.completionBlock = { () -> Void in

                SCNTransaction.begin()
                SCNTransaction.animationDuration = 0.1
                SCNTransaction.animationTimingFunction = (CAMediaTimingFunction(name: .easeInEaseOut))
                material?.emission.contents = UIColor.blue

                SCNTransaction.completionBlock = ({ () -> Void in
                    if index + 1 == self.specialNodeN.count {

    //                    self.eDance(index: 0)//반복
                    }
                    else {
                        self.nDance(index: index+1)
                    }

                })

                SCNTransaction.commit()
            }

            SCNTransaction.commit()
        }

        func eDance(index:Int){


            SCNTransaction.begin()
            SCNTransaction.animationDuration = 0.1
            SCNTransaction.animationTimingFunction = (CAMediaTimingFunction(name: .easeInEaseOut))
            let material = specialNodeE[index].geometry?.firstMaterial!
            material?.emission.contents = UIColor.orange

            SCNTransaction.completionBlock = { () -> Void in

                SCNTransaction.begin()
                SCNTransaction.animationDuration = 0.1
                SCNTransaction.animationTimingFunction = (CAMediaTimingFunction(name: .easeInEaseOut))
                material?.emission.contents = UIColor.blue

                SCNTransaction.completionBlock = ({ () -> Void in
                    if index + 1 == self.specialNodeE.count {
                    }
                    else {
                        self.eDance(index: index+1)
                    }

                })
                SCNTransaction.commit()
            }

            SCNTransaction.commit()
        }
        func f1Dance(){//
            SCNTransaction.begin()
            SCNTransaction.animationDuration = 0.5
            SCNTransaction.animationTimingFunction = (CAMediaTimingFunction(name: .easeInEaseOut))
            f1Node[0].rotation = SCNVector4Make(0, 1, 0, .pi/16)
            allFloorNode[4].position = SCNVector3(x: allFloorNode[4].position.x, y: allFloorNode[4].position.y, z: allFloorNode[4].position.z + 0.4)
            SCNTransaction.completionBlock = { () -> Void in

                SCNTransaction.begin()
                SCNTransaction.animationDuration = 0.5
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
//            GameSound.explosion(cinemaCameraNode)
            // check what nodes are tapped
            let p = gestureRecognize.location(in: scnView)
            let hitResults = scnView.hitTest(p, options: nil)
            // check that we clicked on at least one object
            if hitResults.count > 0 {
                // retrieved the first clicked object
                let result: AnyObject! = hitResults[0]
                let resultNode = result.node! as SCNNode
                if let name = resultNode.name {
                    print("name:",name)
                    var node = SCNNode()
                    for i in allFloorNode {
                        if name == i.name {
                            node = i
                        }
                    }
                    let material = node.geometry?.firstMaterial!

                    //position기억하는 골렘앱처럼 포지션은 가져오는 걸 해볼까?
                    //누르면 소리나게?
                    //말하는것처럼
                    SCNTransaction.begin()
                    SCNTransaction.animationDuration = 1.5
                    SCNTransaction.completionBlock = {
                        ()-> Void in
                        SCNTransaction.begin()
                        SCNTransaction.animationDuration = 1.5

                        material?.emission.contents = UIColor.orange

                        node.position = SCNVector3(x: node.position.x, y: node.position.y , z: node.position.z-0.5)

                        SCNTransaction.commit()
                    }


                    material?.emission.contents = UIColor.red
                    node.position = SCNVector3(x: node.position.x, y: node.position.y , z: node.position.z+0.5)

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
extension StartViewController {
    
}
