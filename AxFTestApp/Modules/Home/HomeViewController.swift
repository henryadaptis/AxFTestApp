//
//  ViewController.swift
//  AxFTestApp
//
//  Created by Henry on 22/02/2023.
//

import UIKit
import ReactiveSwift
import ReactiveCocoa
import NotificationBannerSwift

class HomeViewController: UIViewController {
    let viewModel: HomeViewModel
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var createPostButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Create Post", for: .normal)
        button.backgroundColor = .init(hex: StyleGuide.accentColor)
        button.layer.cornerRadius = 8
        button.setTitleColor(.init(hex: StyleGuide.secondaryTextColor), for: .normal)
        button.contentEdgeInsets = .init(top: StyleGuide.spacingSmall,
                                         left: StyleGuide.spacingSmall,
                                         bottom: StyleGuide.spacingSmall,
                                         right: StyleGuide.spacingSmall)
        return button
    }()
    
    var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.hidesWhenStopped = true        
        activityIndicator.color = .init(hex: StyleGuide.accentColor)
        return activityIndicator
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        initViews()
        observeValues()
        bindingActions()
    }
    
    private func observeValues() {
        createPostButton.reactive.isEnabled <~ viewModel.loading.negate()
        createPostButton.reactive.backgroundColor <~ viewModel.loading.map { $0 ? .gray : .init(hex: StyleGuide.accentColor)! }
        activityIndicator.reactive.isAnimating <~ viewModel.loading
        
        viewModel.error
            .observe(on: QueueScheduler.main)
            .take(duringLifetimeOf: reactive.lifetime)
            .observeValues{ error in
                var message = "Unexpected error"
                if let apiError = error as? APIError,
                   case .error(let msg) = apiError {
                    message = msg
                }
                let banner = NotificationBanner(title: "Error", subtitle: message, style: .danger)
                banner.show()
            }
        
        viewModel.photoRetryCount
            .signal
            .skipNil()
            .observe(on: QueueScheduler.main)
            .take(duringLifetimeOf: reactive.lifetime)
            .observeValues { count in
                print("Upload photo retry: \(count)")                
            }
        
        viewModel.videoRetryCount
            .signal
            .skipNil()
            .observe(on: QueueScheduler.main)
            .take(duringLifetimeOf: reactive.lifetime)
            .observeValues { count in
                print("Upload video retry: \(count)")
            }
        
        viewModel.createPostAction.values
            .observe(on: QueueScheduler.main)
            .take(duringLifetimeOf: reactive.lifetime)
            .observeValues { post in
                let banner = NotificationBanner(title: "Create Post Successfully", subtitle: "PostID: \(post.id)", style: .success)
                banner.show()
            }
    }
    
    private func bindingActions() {
        createPostButton.reactive.pressed = CocoaAction(viewModel.createPostAction, input: PostActionInput(content: "Content",
                                                                                                           photo: Media(withImage: UIImage.add, forKey: "photo"),
                                                                                                           photoParams: nil,
                                                                                                           video: Media(withImage: UIImage.checkmark, forKey: "video"),
                                                                                                           videoParams: nil))
    }
}

