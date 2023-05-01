//
//  FirebaseDataManager.swift
//  PutItOn
//
//  Created by 박현준 on 2023/04/24.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage

//MARK: - Data
class FireBaseDataManager {
    
    static func getData(_ completion: @escaping ([String], [String]) -> Void ) {
        
        var timeModel: [String] = []
        var imageModel: [String] = []
        
        let dataReference = Database.database().reference()
        let storageReference = Storage.storage().reference()
        
        // Firebase Realtime Database에서 데이터 가져오기
        dataReference.child("current_time").observeSingleEvent(of: .value, with: { (snapshot) in
            
            guard let sv = snapshot.value as?  [String: Any] else { return }
        
            for (_, value) in sv {
                    // 각각의 문자열 값을 출력합니다.
                    if let timeString = value as? String {
                        timeModel.append("\(timeString)")
                        timeModel.sort(by: >)
                        
                        if timeModel.isEmpty == false && imageModel.isEmpty == false {
                            completion(timeModel, imageModel)
                        }
                    }
                }
 
//            sleep(5)
//            completion(timeModel, imageModel)
        })
        
        // Firebase Storage에서 이미지 가져오기
        // storageRef에서 모든 이미지 파일의 reference를 가져옴
        storageReference.listAll { (result, error) in
            if let error = error {
                print("Error listing images: \(error.localizedDescription)")
                return
            }
            
            // result.items에 모든 이미지 파일의 reference가 배열로 들어있음
            guard let imageRefs = result?.items else { return }
            
            // 각 이미지 파일에서 데이터를 가져와서 처리
            for imageRef in imageRefs {
                imageRef.downloadURL { url, error in
                    if let error = error {
                        print("이미지 에러")
                        return
                    }
                    
                    if let imageUrl = url {
                        print("imageURL = \(imageUrl)")
                        imageModel.append("\(imageUrl)")
                        imageModel.sort(by: >)
                        
                        if timeModel.isEmpty == false && imageModel.isEmpty == false {
                            completion(timeModel, imageModel)
                        }

                    }
                }
            }
        }
    }

}

