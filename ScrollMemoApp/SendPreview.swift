//
//  SendPreview.swift
//  ScrollMemoApp
//
//  Created by 植田圭祐 on 2019/10/05.
//  Copyright © 2019 Keisuke Ueda. All rights reserved.
//

import UIKit

class SendView: UIViewController {
    
    var shareButton = UIButton()
    
    
    init(sendButton: UIButton){
        self.shareButton = sendButton
        
        super.init(nibName: nil, bundle: nil)
    }
 
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.75)
        view.isOpaque = false
        
        let cancelButton = UIButton(frame: CGRect(x: view.frame.width - 50, y: 50, width: 30, height: 30))
        cancelButton.backgroundColor = .white
        cancelButton.setImage(#imageLiteral(resourceName: "down"), for: .normal)
        cancelButton.layer.cornerRadius = 15
        cancelButton.addTarget(self, action: #selector(ViewReturn), for: .touchUpInside)
        view.addSubview(cancelButton)
        
        MainButton()
        
        SetButton()
    }
    
    /*
     // 画面のImageViewを削除する
     func imageRemove(){
     // self.viewの上に乗っているオブジェクトを順番に取得する
     for v in view.subviews {
     // オブジェクトの型がUIImageView型で、タグ番号が1〜5番のオブジェクトを取得する
     if let v = v as? UIImageView, v.tag >= 1 && v.tag <= 5  {
     // そのオブジェクトを親のviewから取り除く
     v.removeFromSuperview()
 */
    
    func MainButton() {
        for remove in shareButton.subviews {
            if let remLabel = remove as? UILabel {
                remLabel.removeFromSuperview()
            }
        }
        
        let witdh = shareButton.frame.width * 1.5
        let height = shareButton.frame.height * 1.5
        
        shareButton.frame = CGRect(x: 0, y: 0, width: witdh, height: height)
        shareButton.center = view.center
        shareButton.layer.cornerRadius = 20.0
        view.addSubview(shareButton)
        
        /*
        let animationWidth = shareButton.frame.width / 2
        let x = shareButton.frame.origin.x + animationWidth
        
        UIView.animate(withDuration: 0.25, delay: 0.0, options: [.curveEaseIn, .repeat], animations: {
            self.shareButton.frame = CGRect(x: x, y: self.shareButton.frame.origin.y, width: 1, height: self.shareButton.frame.height)
        }) { _ in
            UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveEaseOut, animations: {
                //self.shareButton.setBackgroundImage(#imageLiteral(resourceName: "pattern2"), for: .normal)
                self.shareButton.frame = CGRect(x: self.shareButton.frame.origin.x - animationWidth, y: self.shareButton.frame.origin.y, width: animationWidth * 2, height: self.shareButton.frame.height)
            }, completion: nil)
        }
        */
        
        //RepeatAnimation()
        
    }
    
    /*
    func RepeatAnimation() {
        let animationWidth = shareButton.frame.width / 2
        let x = shareButton.frame.origin.x + animationWidth
        
        UIView.animate(withDuration: 0.25, delay: 0.0, options: .repeat, animations: {
            self.shareButton.frame = CGRect(x: x, y: self.shareButton.frame.origin.y, width: 1, height: self.shareButton.frame.height)
        }) { _ in
            UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveEaseOut, animations: {
                //self.shareButton.setBackgroundImage(#imageLiteral(resourceName: "pattern2"), for: .normal)
                self.shareButton.frame = CGRect(x: self.shareButton.frame.origin.x - animationWidth, y: self.shareButton.frame.origin.y, width: animationWidth * 2, height: self.shareButton.frame.height)
            }, completion: nil)
        }
        
    }
 */
    
    func SetButton() {
        let posX = view.frame.width / 9
        let posY = view.frame.height / 10 * 7
        let line = UIButton(frame: CGRect(x: posX * 2, y: posY, width: posX, height: posX))
        line.addTarget(self, action: #selector(lineSend), for: .touchUpInside)
        line.setImage(#imageLiteral(resourceName: "line"), for: .normal)
        
        let twitter = UIButton(frame: CGRect(x: posX * 4, y: posY, width: posX, height: posX))
        twitter.setImage(#imageLiteral(resourceName: "twitter"), for: .normal)
        
        let facebook = UIButton(frame: CGRect(x: posX * 6, y: posY, width: posX, height: posX))
        facebook.setImage(#imageLiteral(resourceName: "facebook"), for: .normal)
        
        view.addSubview(line)
        view.addSubview(twitter)
        view.addSubview(facebook)
    }
    
    @objc func ViewReturn() {
        let returnView = presentingViewController
        returnView?.viewWillAppear(true)
        
        dismiss(animated: true, completion: nil)
    }
    
    @objc func lineSend() {
        let urlscheme: String = "line://msg/text"
        let message = "iPhone X\n\n私たちはずっと変わらないビジョンを持ち続けてきました。\nすべてがスクリーンのiPhoneを作ること。\n\nhttps://www.apple.com/jp/iphone-x/"
        
        // line:/msg/text/(メッセージ)
        let urlstring = urlscheme + "/" + message
        
        // URLエンコード
        guard let  encodedURL = urlstring.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed) else {
            return
        }
        
        // URL作成
        guard let url = URL(string: encodedURL) else {
            return
        }
        
        if UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: { (succes) in
                    //  LINEアプリ表示成功
                })
            }else{
                UIApplication.shared.openURL(url)
            }
        }else {
            // LINEアプリが無い場合
            let alertController = UIAlertController(title: "エラー",message: "LINEがインストールされていません",preferredStyle: UIAlertController.Style.alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default))
            present(alertController,animated: true,completion: nil)
        }
    }
    
    
    
}
