//
//  DataView.swift
//  scrollTest
//
//  Created by 植田圭祐 on 2019/08/08.
//  Copyright © 2019 Keisuke Ueda. All rights reserved.
//

import UIKit

class DataView: UIViewController {
    var receive = 0
    var color: UIColor = .clear
    
    init(tag: Int, colorB: UIColor) {
        receive = tag
        color = colorB
        
        super.init(nibName: nil, bundle: nil)
    }
    
    // 新しく init を定義した場合に必須
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let receiveData = receive
        print(receiveData)
        
        
        view.backgroundColor = .white
        
        let headder = UIView()
        headder.backgroundColor = color
        headder.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height / 3)
        
        view.addSubview(headder)
        
        let backButton = UIButton(frame: CGRect(x: 0, y: headder.frame.height / 2, width: 50, height: 50))
        backButton.setImage(#imageLiteral(resourceName: "down"), for: .normal)
        
        backButton.addTarget(self, action: #selector(BackView), for: .touchUpInside)
        
        headder.addSubview(backButton)
    }
    
    @objc func BackView() {
        dismiss(animated: true, completion: nil)
    }
}





