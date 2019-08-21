//
//  IconEditView.swift
//  ScrollMemoApp
//
//  Created by 植田圭祐 on 2019/08/15.
//  Copyright © 2019 Keisuke Ueda. All rights reserved.
//

import UIKit

//ボタンの見た目を編集する画面

class IconEditView: UIViewController {
    var iconTitle = ""
    var iconColor: UIColor = .clear
    
    //もらってきたデータを格納
    init(receiveTitle: String, receiveColor: UIColor) {
        iconTitle = receiveTitle
        iconColor = receiveColor
        
        super.init(nibName: nil, bundle: nil)
    }
    
    // 新しく init を定義した場合に必須
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = iconColor
        
        let titleView = UILabel()
        titleView.text = iconTitle
        titleView.frame = CGRect(x: 0, y: 0, width: view.frame.width / 2, height: view.frame.height / 10)
        titleView.center = CGPoint(x: view.center.x, y: view.frame.height / 3 * 2)
        titleView.font = UIFont(name: "Avenir-Oblique", size: 60)
        titleView.textColor = .white
        view.addSubview(titleView)
        
        let imageButton = UIButton()
        //imageButton.sizeThatFits(CGSize(width: view.frame.width / 2, height: view.frame.width / 2))
        imageButton.frame = CGRect(x: 0, y: 0, width: view.frame.width / 2, height: view.frame.width / 2)
        imageButton.center = CGPoint(x: view.center.x, y: view.center.y)
        imageButton.layer.cornerRadius = view.frame.width / 4
        imageButton.backgroundColor = .white
        view.addSubview(imageButton)
        
        let returnButton = UIButton()
        returnButton.frame = CGRect(x: view.frame.width - 50, y: view.frame.height - 50, width: 50, height: 50)
        returnButton.layer.cornerRadius = 25
        returnButton.setImage(#imageLiteral(resourceName: "left"), for: .normal)
        returnButton.addTarget(self, action: #selector(viewReturn), for: .touchUpInside)
        view.addSubview(returnButton)
    }
    
    @objc func viewReturn() {
        dismiss(animated: true, completion: nil)
    }
}
