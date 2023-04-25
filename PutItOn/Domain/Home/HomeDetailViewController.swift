//
//  HomeDetailViewController.swift
//  PutItOn
//
//  Created by 박현준 on 2023/04/24.
//

import UIKit
import SnapKit

class HomeDetailViewController: UIViewController {
    
    var detailImageView: UIImageView = {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.image = UIImage(systemName: "person.fill")
        return $0
    }(UIImageView())
    
    var detailDateLabel: UILabel = {
        $0.text = "23.03.25"
        $0.font = UIFont.pretendardBold(size: 15)
        $0.textColor = UIColor.black
        return $0
    }(UILabel())
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationController?.title = "불통과"
        setUIConstraints()
        
    }

    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.tabBarController?.tabBar.isHidden = false
    }
    
    func setUIConstraints() {
        view.addSubview(detailImageView)
        view.addSubview(detailDateLabel)
        
        detailImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(UIScreen.main.bounds.height / 3)
        }
        
        detailDateLabel.snp.makeConstraints { make in
            make.top.equalTo(detailImageView.snp.bottom).inset(-15)
            make.trailing.equalToSuperview().inset(15)
        }
    }
   
}
