//
//  HomeTableViewCell.swift
//  PutItOn
//
//  Created by 박현준 on 2023/04/05.
//

import UIKit
import SnapKit

class HomeTableViewCell: UITableViewCell {

    static let identifier = "HomeTableViewCell"
    
    
    private let view: UIView = {
        $0.backgroundColor = .clear
        $0.layer.cornerRadius = 10
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.mainColor.cgColor
        $0.clipsToBounds = false
        return $0
    }(UIView())
    
    var mainImageView: UIImageView = {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 25
        $0.image = UIImage(systemName: "person.fill")
        return $0
    }(UIImageView())
    
    var workerLabel: UILabel = {
        $0.text = "근무자"
//        $0.font = UIFont.notoSans(font: .notoSansKrMedium, size: 18)
        $0.textColor = UIColor.black
        $0.numberOfLines = 0
        return $0
    }(UILabel())
    
    var failText: UILabel = {
        $0.text = "불통과"
//        $0.font = UIFont.notoSansBold(size: 18)
        $0.textColor = UIColor.rgb(red: 255, green: 35, blue: 1)
        return $0
    }(UILabel())
    
    var dateLabel: UILabel = {
        $0.text = "23.03.25"
//        $0.font = UIFont.notoSansRegular(size: 13)
        $0.textColor = UIColor.black
        return $0
    }(UILabel())
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        setUIandConstraints()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 7.5, left: 2, bottom: 7.5, right: 2))
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    
    func setUIandConstraints() {
        contentView.addSubview(view)
        view.addSubview(mainImageView)
        view.addSubview(workerLabel)
        view.addSubview(failText)
        view.addSubview(dateLabel)
        
        view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        workerLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(21)
            make.leading.equalToSuperview().inset(40)
        }
        
        mainImageView.snp.makeConstraints { make in
            make.top.equalTo(workerLabel.snp.bottom).inset(-20)
            make.leading.equalToSuperview().inset(21)
            make.width.equalTo(UIScreen.main.bounds.width / 3)
            make.height.equalTo(130)
        }
        
        failText.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(20)
            
        }
        dateLabel.snp.makeConstraints { make in
            make.trailing.bottom.equalToSuperview().inset(15)
        }
    }
}
