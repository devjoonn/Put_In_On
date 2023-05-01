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
    
    var mainImageView: UIImageView = {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 18
        $0.image = UIImage(systemName: "person.fill")
        return $0
    }(UIImageView())
    
    var failText: UILabel = {
        $0.text = "통과"
        $0.font = UIFont.pretendardBold(size: 25)
        $0.textColor = UIColor.mainColor
        return $0
    }(UILabel())
    
    var dateLabel: UILabel = {
        $0.text = "23.03.25"
        $0.font = UIFont.pretendardRegular(size: 13)
        $0.textColor = UIColor.black
        return $0
    }(UILabel())
    
    private let downLineView: UIView = {
        $0.backgroundColor = .clear
        $0.layer.cornerRadius = 10
        $0.layer.borderWidth = 4
        $0.layer.borderColor = UIColor.gray.cgColor
        $0.clipsToBounds = false
        return $0
    }(UIView())
    
    
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
        contentView.addSubview(mainImageView)
        contentView.addSubview(failText)
        contentView.addSubview(dateLabel)
        contentView.addSubview(downLineView)
        
        mainImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(14)
            make.width.equalTo(UIScreen.main.bounds.width / 3 + 20)
            make.height.equalTo(150)
        }
        
        failText.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(25)
            
        }
        dateLabel.snp.makeConstraints { make in
            make.trailing.bottom.equalToSuperview().inset(18)
        }
        
        downLineView.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(-8)
            make.leading.trailing.equalToSuperview().inset(11)
            make.height.equalTo(1)
        }
    }
}
