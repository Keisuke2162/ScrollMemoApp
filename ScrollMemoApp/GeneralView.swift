//
//  GeneralView.swift
//  ScrollMemoApp
//
//  Created by 植田圭祐 on 2019/09/02.
//  Copyright © 2019 Keisuke Ueda. All rights reserved.
//

import UIKit

class GeneralView: UIViewController {
    
    let iconName = ["america","around","gate","kawai","night","seed","silver","sumo","tribal"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        SetButton()
    }
    
    func SetButton() {
        let width = view.frame.width / 10
        let height = view.frame.height / 10
        for i in 0 ..< 9 {
            let generalButton = UIButton()
            let x = CGFloat(i % 3 * 3 + 1)
            let y = CGFloat(i / 3 + 3)
            
            generalButton.tag = i
            generalButton.frame = CGRect(x: width * x, y: height * y, width: width * 1.5, height: width * 1.5)
            generalButton.setImage(UIImage(named: iconName[i]), for: .normal)
            generalButton.addTarget(self, action: #selector(ChooseButton), for: .touchUpInside)
            
            view.addSubview(generalButton)
        }
    }
    
    var chooseButton = UIButton()
    
    @objc func ChooseButton(_ sender: UIButton) {
        chooseButton = sender
        chooseButton.layer.borderColor = UIColor.blue.cgColor
        chooseButton.layer.borderWidth = 0.25
        
    }
}
