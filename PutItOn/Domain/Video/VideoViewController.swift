//
//  VideoViewController.swift
//  PutItOn
//
//  Created by 박현준 on 2023/03/31.
//

import UIKit
import SnapKit

class VideoViewController: UIViewController {

    private let alertLabel: UILabel = {
        $0.text = "URL을 입력해주세요."
        $0.font = UIFont.cafe24Ssurround(size: 18)
        $0.textColor = UIColor.mainColor
        $0.textAlignment = .center
        return $0
    }(UILabel())
    
    private let textfieldView: UIView = {
        $0.layer.cornerRadius = 12
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.mainColor.cgColor
        $0.backgroundColor = UIColor.clear
        return $0
    }(UIView())
    
    let textfield: UITextField = {
        $0.attributedPlaceholder = NSAttributedString(
            string: "입력하세요.",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        $0.font = .pretendardRegular(size: 14)
        $0.backgroundColor = .clear
        $0.textColor = UIColor.black
        return $0
    }(UITextField())
    
    let moveButton: UIButton = {
        $0.layer.cornerRadius = 10
        $0.setAttributedTitle(NSAttributedString(string: "확인", attributes: [NSAttributedString.Key.font: UIFont.pretendardBold(size: 16), NSAttributedString.Key.foregroundColor: UIColor.white]), for: .normal)
        $0.tintColor = UIColor.white
        $0.backgroundColor = UIColor.mainColor
        $0.setTitle("확인", for: .normal)
        return $0
    }(UIButton())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setConstraints()
        hideKeyboardWhenTappedAround()
        configureNavbar()
       
        moveButton.addTarget(self, action: #selector(moveButtonTap), for: .touchUpInside)
    }
    
//MARK: - set UI
    func setUI() {
        view.addSubview(alertLabel)
        view.addSubview(textfieldView)
        textfieldView.addSubview(textfield)
        view.addSubview(moveButton)
    }

    func setConstraints() {
        alertLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(60)
            make.centerX.equalToSuperview()
        }
        
        textfieldView.snp.makeConstraints { make in
            make.top.equalTo(alertLabel.snp.bottom).inset(-10)
            make.centerX.equalToSuperview()
            make.height.equalTo(45)
            make.width.equalTo(UIScreen.main.bounds.width - 70)
        }
        
        textfield.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(20)
            make.trailing.equalToSuperview().inset(20)
        }
        
        moveButton.snp.makeConstraints { make in
            make.top.equalTo(textfieldView.snp.bottom).inset(-40)
            make.centerX.equalToSuperview()
            make.width.equalTo(UIScreen.main.bounds.width - 70)
            make.height.equalTo(50)
        }
    }
    
    func configureNavbar() {
        
        // 뒤로가기 버튼 < 만 출력
        let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil) // title 부분 수정
        backBarButtonItem.tintColor = UIColor.mainColor
        self.navigationItem.backBarButtonItem = backBarButtonItem
        
        // navigation bar title color
        if #available(iOS 13.0, *) {
            navigationController?.navigationBar.standardAppearance.titleTextAttributes = [.foregroundColor: UIColor.mainColor]
            navigationController?.navigationBar.scrollEdgeAppearance?.titleTextAttributes = [.foregroundColor: UIColor.mainColor]
        } else {
            navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.mainColor]
        }

    }
    
//MARK: - Func
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func moveButtonTap() {
        let vc = WebViewController()
        vc.text = textfield.text ?? ""
        vc.url = "https://m.search.naver.com/search.naver?sm=mtp_hty.top&where=m&"
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
