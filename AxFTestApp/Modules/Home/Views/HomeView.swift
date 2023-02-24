//
//  HomeView.swift
//  AxFTestApp
//
//  Created by Henry on 22/02/2023.
//

import Foundation
import UIKit
import SnapKit

extension HomeViewController {
    
    
    func initViews() {
        view.backgroundColor = .init(hex: StyleGuide.backgroundColor)
        view.addSubview(createPostButton)
        view.addSubview(activityIndicator)
        
        activityIndicator.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(50)
        }

        createPostButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(activityIndicator.snp.bottom).offset(10)
        }
    }
}
