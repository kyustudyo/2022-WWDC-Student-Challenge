
import Foundation
import SceneKit

class Player_light : SCNNode, CAAnimationDelegate {
    private var daeHolderNode = SCNNode()
    var characterNode:SCNNode!
    private var aliveChar  = SCNNode()
    private var walkAnimation = CAAnimation()
    var clothOrder:Int = 0
    var isWalking:Bool = false {
        
        didSet {
            
            if oldValue != isWalking {
                
                if isWalking {
                    
                    characterNode.addAnimation(walkAnimation, forKey: "walk")
            
                }
                else {
//                    characterNode.removeAllActions()
//                    characterNode.removeAllAnimations()
//                    characterNode.removeAnimation(forKey: "walk", blendOutDuration: 0.01)
                }
            }
        }
    }
    init(clothOrder:Int = 0){
        super.init()
        self.clothOrder = clothOrder
        setupModel()
        loadAnimations()
    }

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    //MARK:- scene
    private func setupModel() {
        

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
        
        //set mesh name
//        characterNode = daeHolderNode.childNode(withName: "Bip01", recursively: true)!
        //그냥 daeholdernode로 해도됨.
        characterNode = daeHolderNode.childNode(withName: "mixamorig_Hips", recursively: false)
        
        let color1 = UIColor(red: 247.0 / 255, green: 183.0 / 255, blue: 51.0 / 255, alpha: 1.0)
        let color2 = UIColor(red: 195 / 255, green: 214 / 255, blue: 145 / 255, alpha: 1.0)
    
        switch clothOrder {
        case 1 : daeHolderNode.childNode(withName: "male_worksuit01-obj", recursively: false)?.geometry?.firstMaterial?.diffuse.contents = color1
        
        case 2 : daeHolderNode.childNode(withName: "male_worksuit01-obj", recursively: false)?.geometry?.firstMaterial?.diffuse.contents = color2
            
        default: break
        }
        
        
        print(characterNode.name)
//        characterNode = daeHolderNode.childNode(withName: "ani1", recursively: true)!
//        characterNode = daeHolderNode.childNode(withName: "staticman", recursively: true)!
//        characterNode.scale = SCNVector3(x: 70, y: 70, z: 70)
    }
    //MARK:- animations
    private func loadAnimations() {
        
        loadAnimation(inSceneNamed: "inplaceWalk", withIdentifier: "unnamed_animation__0")
        

        
        
        
    }
    func applyWalk(){
        characterNode.addAnimation(walkAnimation, forKey: "walk")
        
    }
    
    
    private func loadAnimation( inSceneNamed scene:String, withIdentifier identifier:String) {
        

        let animationObject:CAAnimation = animationFromSceneNamed(path: "Sd")!
        
        animationObject.delegate = self
        animationObject.fadeInDuration = 0.2
        animationObject.fadeOutDuration = 0.2
        animationObject.usesSceneTimeBase = false
        animationObject.repeatCount = 0
        animationObject.repeatCount = Float.greatestFiniteMagnitude
        walkAnimation = animationObject
         
    }
    
}
