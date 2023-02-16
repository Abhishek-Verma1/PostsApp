//
//  LoadingMaskController.swift
//  PostsApp
//
//  Created by Abhishek Verma on 14.02.23.
//  Copyright © 2023 JMD. All rights reserved.
//

import UIKit

#warning("Optimization is required in the next sprint.")

private class LoadingMaskController: UIViewController {
    
    fileprivate var shouldBeDismissed = false
    
    init() {
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .overFullScreen
        let activityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
        view.addSubview(activityIndicator)
        activityIndicator.center = view.center
        activityIndicator.startAnimating()
        transitioningDelegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension LoadingMaskController: UIViewControllerTransitioningDelegate {
    func animationController(
        forPresented presented: UIViewController, presenting: UIViewController,
        source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
            return self
        }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
}

extension LoadingMaskController: UIViewControllerAnimatedTransitioning {
    static var presentationAnimationDuration: TimeInterval { return 0.3 }
    
    var transitionDuration: TimeInterval { return LoadingMaskController.presentationAnimationDuration }
    
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return transitionDuration
    }
    
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        view.frame = CGRect(origin: .zero, size: transitionContext.containerView.frame.size)
        if isBeingPresented {
            transitionContext.containerView.addSubview(view)
            view.alpha = 0
            UIView.animate(withDuration: transitionDuration, animations: {
                self.view.alpha = 1
            }, completion: { _ in
                transitionContext.completeTransition(true)
            })
        } else {
            UIView.animate(withDuration: transitionDuration, animations: {
                self.view.alpha = 0
            }, completion: { _ in
                transitionContext.completeTransition(true)
            })
        }
    }
}

private var loadingMaskControllerReference: UInt8 = 0

@objc extension UIViewController {
    private var loadingMaskController: LoadingMaskController? {
        get {
            return objc_getAssociatedObject(self, &loadingMaskControllerReference) as? LoadingMaskController
        }
        set {
            objc_setAssociatedObject(
                self, &loadingMaskControllerReference, newValue,
                objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    /// Show the loading mask.
    ///
    /// - Parameters:
    ///   - isOverFullscreen: if `true`, the loading mask will be over the full screen.
    ///                       if `false`, the loading mask will match the size of the view controller's view.
    ///                       (e.g. won't cover navigation bar or tab bar)
    public func showLoadingMask(isOverFullscreen: Bool) {
        let loadingMask: LoadingMaskController = {
            if let loadingMask = loadingMaskController {
                return loadingMask
            } else {
                let loadingMask = LoadingMaskController()
                loadingMaskController = loadingMask
                return loadingMask
            }
        } ()
        loadingMask.shouldBeDismissed = false
        if isOverFullscreen {
            if !loadingMask.isBeingPresented {
                present(loadingMask, animated: true) {
                    if loadingMask.shouldBeDismissed {
                        loadingMask.dismiss(animated: true, completion: nil)
                    }
                }
            }
        } else {
            addChild(loadingMask)
            view.addSubview(loadingMask.view)
            loadingMask.view.frame.size = view.frame.size
            loadingMask.didMove(toParent: self)
            loadingMask.view.alpha = 0
            UIView.animate(withDuration: LoadingMaskController.presentationAnimationDuration, animations: {
                loadingMask.view.alpha = 1
            })
        }
    }
    
    /// Hide the loading mask.
    ///
    /// - Parameter completion: Is guarantee to be called after the loading mask is hidden.
    ///
    /// It's not necessary to put UI work inside the completion block,
    /// if you don't need to wait the dismissing animation to finish first.
    public func hideLoadingMask(completion: (() -> Void)?) {
        guard let loadingMaskController = loadingMaskController else {
            completion?()
            return
        }
        loadingMaskController.shouldBeDismissed = true
        UIView.animate(withDuration: LoadingMaskController.presentationAnimationDuration, animations: {
            loadingMaskController.view.alpha = 0
        }, completion: { _ in
            loadingMaskController.willMove(toParent: nil)
            loadingMaskController.view.removeFromSuperview()
            loadingMaskController.removeFromParent()
            loadingMaskController.dismiss(animated: true, completion: nil)
            completion?()
        })
    }
    
}
