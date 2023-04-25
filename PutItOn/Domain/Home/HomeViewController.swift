//
//  HomeViewController.swift
//  PutItOn
//
//  Created by 박현준 on 2023/03/31.
//

import UIKit
import SnapKit
import SDWebImage


class HomeViewController: UIViewController {
    
    var timeModel: [String] = []
    var imageModel: [String] = []
    
    let tableView: UITableView = {
        $0.register(HomeTableViewCell.self, forCellReuseIdentifier: HomeTableViewCell.identifier)
        return $0
    }(UITableView())
    
    
    //MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        setUIConstraints()
        configureNavbar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        FireBaseDataManager.getData() { tModel, iModel in
            self.timeModel = tModel
            self.imageModel = iModel
            self.tableView.reloadData()
            
            print("timeModel 들어있는 건 =. \(self.timeModel)")
            print("imageModel 들어있는 건 =. \(self.imageModel)")
            
        }
    }
    
    //MARK: - set UI
    
    func setUIConstraints() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func configureNavbar() {
        let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil) // title 부분 수정
            backBarButtonItem.tintColor = .black
            self.navigationItem.backBarButtonItem = backBarButtonItem
        
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.tintColor = .white
    }
    
}

//MARK: - TableView
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        200
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        imageModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HomeTableViewCell.identifier, for: indexPath) as? HomeTableViewCell else { return UITableViewCell() }
        
        let tModel = timeModel[indexPath.row]
        let iModel = imageModel[indexPath.row]
        
        let url = URL(string: iModel)
        cell.mainImageView.sd_setImage(with: url, completed: nil)
        cell.dateLabel.text = tModel
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let tModel = timeModel[indexPath.row]
        let iModel = imageModel[indexPath.row]
        let vc = HomeDetailViewController()
        
        let url = URL(string: iModel)
        vc.detailImageView.sd_setImage(with: url, completed: nil)
        vc.detailDateLabel.text = tModel
        navigationController?.tabBarController?.tabBar.isHidden = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
