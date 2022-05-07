import SwiftUI
import UIKit
import Foundation
import SceneKit

struct ViewControllerRepresentation: UIViewControllerRepresentable {
    
    
    func makeUIViewController(context: Context) -> ViewController {
        ViewController()
    }
    
    func updateUIViewController(_ uiViewController: ViewController, context: Context) {
        
    }
}
struct StartViewControllerRepresentation: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> StartViewController {
        StartViewController()
    }
    
    func updateUIViewController(_ uiViewController: StartViewController, context: Context) {
        
    }
    
    typealias UIViewControllerType = StartViewController
    
    
}

struct LoadingViewControllerRepresentation: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> LoadingViewController {
        LoadingViewController()
    }
    func updateUIViewController(_ uiViewController: LoadingViewController, context: Context) {
    }
    typealias UIViewControllerType = LoadingViewController
}
struct LightViewControllerRepresentation: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> LightViewController {
        LightViewController()
    }
    
    func updateUIViewController(_ uiViewController: LightViewController, context: Context) {
        
    }
    
    typealias UIViewControllerType = LightViewController
    
    
}
