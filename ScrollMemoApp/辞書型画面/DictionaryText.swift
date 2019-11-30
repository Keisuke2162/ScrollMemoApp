//
//  DictionaryText.swift
//  ScrollMemoApp
//
//  Created by 植田圭祐 on 2019/11/22.
//  Copyright © 2019 Keisuke Ueda. All rights reserved.
//

import UIKit

class DictionaryText: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        //画面上部にボタンと同じ色のヘッダー
        headder()
        // Do any additional setup after loading the view.
        
        //アイコン選択画面への遷移ボタン
        let returnButton = UIButton()
        returnButton.frame = CGRect(x: view.frame.width - 75, y: view.frame.height - 75, width: 50, height: 50)
        returnButton.setImage(#imageLiteral(resourceName: "xcode"), for: .normal)
        returnButton.addTarget(self, action: #selector(ViewReturn), for: .touchUpInside)
        view.addSubview(returnButton)
    }
    
    @objc func ViewReturn() {
        let viewCnt = (self.navigationController!.viewControllers.count)-2
        navigationController?.popToViewController(navigationController!.viewControllers[viewCnt], animated: true)
    }
    
    //ヘッダー作成
    func headder() {
        
        let headder = UIView()
        
        headder.backgroundColor = .black

        headder.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height / 4)
        view.addSubview(headder)

    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
