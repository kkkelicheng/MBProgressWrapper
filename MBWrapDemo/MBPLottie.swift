//
//  MBPLottie.swift
//  MBWrapDemo
//
//  Created by kkkelicheng on 2023/4/14.
//

import UIKit
import Lottie

class MBPLottie : UIView {
    
    lazy var animationView: AnimationView = {
        let a = AnimationView.init(name: "lottie_load", animationCache: MBPLottie.StatusIndicatorLottieLoadingCache.shared)
        a.backgroundBehavior = .pauseAndRestore
        a.contentMode = .scaleAspectFit
        return a
    }()
    
    init(){
        super.init(frame: .zero)
        configSubviews()
        self.translatesAutoresizingMaskIntoConstraints = false
        self.widthAnchor.constraint(equalToConstant: 80).isActive = true
        self.heightAnchor.constraint(equalToConstant: 80).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configSubviews() {
        addSubview(animationView)
        animationView.translatesAutoresizingMaskIntoConstraints = false
        animationView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        animationView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        animationView.widthAnchor.constraint(equalToConstant: 80).isActive = true
        animationView.heightAnchor.constraint(equalToConstant: 80).isActive = true
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        animationView.play(fromProgress: 0, toProgress: 1, loopMode: .loop, completion: nil)
    }
    
    override func removeFromSuperview() {
        animationView.stop()
        super.removeFromSuperview()
    }
    
    
    class StatusIndicatorLottieLoadingCache : AnimationCacheProvider{
        
        static let shared = StatusIndicatorLottieLoadingCache()
        
        private var container : [String : Animation] = [:]
        
        func animation(forKey: String) -> Animation? {
            return container[forKey]
        }
        
        func setAnimation(_ animation: Animation, forKey: String) {
            container[forKey] = animation
        }
        
        func clearCache() {
            container.removeAll()
        }
        
        
    }
}
