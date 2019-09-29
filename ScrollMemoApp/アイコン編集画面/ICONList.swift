//
//  ICONList.swift
//  ScrollMemoApp
//
//  Created by 植田圭祐 on 2019/08/23.
//  Copyright © 2019 Keisuke Ueda. All rights reserved.
//

import UIKit

class IconList: UIViewController {
    
    var iconString: [String] = ["adidas","android","bigben","captain","dragon","ferrari","flower","ios","king",
                                "magic","mazda","monster48","nasa","pharao","pika","pirates","premier",
                                "psyduck","real","mercedes","sagrada","samurai"]
    
    
    /*
    var iconString: [String] =
        ["apple","buy","calendar","gmail","itunes","james","mail","map","micro","new","paint","speech","watch","xcode","visa","iron",
         "increase","graph","choise","maintenance","gener"]
    */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        IconSelect()
        
    }
    
    func IconSelect() {
        let iconLength = view.frame.width / 7
        let head = view.frame.height / 10
        
        for i in 0 ..< iconString.count {
            let icon = UIButton()
            let x = CGFloat(i % 7) * iconLength
            let y = CGFloat(i / 7) * iconLength + head
            
            icon.tag = i
            icon.frame = CGRect(x: x, y: y, width: iconLength, height: iconLength)
            //icon.backgroundColor = .blue
            //icon.layer.cornerRadius = iconLength / 2
            icon.setImage(UIImage(named: iconString[i]), for: .normal)
            
            icon.addTarget(self, action: #selector(saveIcon), for: .touchUpInside)
            
            view.addSubview(icon)
            
        }
    }
    /*
     let count = (self.navigationController?.viewControllers.count)! - 2
     let vcA = self.navigationController?.viewControllers[count]
     */
    
    @objc func saveIcon(sender: UIButton) {
        //let image = UIImage(named: iconString[sender.tag])
        //let count = (self.navigationController?.viewControllers.count)! - 1
        //let returnView = self.navigationController?.viewControllers[count]
        let returnView = self.presentingViewController as! EditView
        returnView.buttonIconName = iconString[sender.tag]
        
        self.dismiss(animated: true, completion: nil)
    
        
    }
    
    
}
