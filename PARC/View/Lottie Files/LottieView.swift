//
//  SwiftUIView.swift
//  PARC
//
//  Created by Ayman Ali on 17/10/2023.
//

import SwiftUI
import Lottie

struct LottieView: UIViewRepresentable {
    var name: String
    var speed: CGFloat
    
    func makeUIView(context: Context) -> Lottie.LottieAnimationView {
        let animationView = LottieAnimationView(name: name)
        animationView.contentMode = .scaleAspectFill
        animationView.animationSpeed = speed
        animationView.loopMode = .loop
        animationView.play()
        
        return animationView
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
}
