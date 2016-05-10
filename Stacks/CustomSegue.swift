//
//  CustomSegue.swift
//  Stacks
//
//  Created by James Gobert on 5/9/16.
//  Copyright © 2016 Mobile First Studios. All rights reserved.
//

import UIKit

class CustomSegue: UIStoryboardSegue {
    
    override func perform() {
//        let ourOriginViewController = self.sourceViewController as UIViewController
//        
//        ourOriginViewController.navigationController?.pushViewController(self.destinationViewController as UIViewController, animated: false)
//        let transitionView = ourOriginViewController.navigationController?.view
//        
//        UIView.transitionWithView(transitionView!, duration: 1, options: UIViewAnimationOptions.AllowAnimatedContent, animations: { () -> Void in
//            
//        }) { (success) -> Void in
//            
//        }
//    }
        
        let src: UIViewController = self.sourceViewController as UIViewController
        let dst: UIViewController = self.destinationViewController as UIViewController
        let transition: CATransition = CATransition()
        let timeFunc : CAMediaTimingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.duration = 0.25
        transition.timingFunction = timeFunc
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromRight
        src.navigationController!.view.layer.addAnimation(transition, forKey: kCATransition)
        src.navigationController!.pushViewController(dst, animated: false)
}

}
