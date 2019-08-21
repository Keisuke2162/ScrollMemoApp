//
//  File.swift
//  scrollTest
//
//  Created by 植田圭祐 on 2019/08/10.
//  Copyright © 2019 Keisuke Ueda. All rights reserved.
//

import UIKit

//ボタンの内容を表示する画面

class EditView: UIViewController, UITabBarDelegate, UITextViewDelegate {
    
    //ホーム画面から受け取るデータ
    var receiveTag = 0
    var receiveColor: UIColor = .clear
    var receiveTitle = ""
    var receiveText = ""
    
    
    //メモ記入用
    let text = UITextView()
    
    //タイトル記入用
    let titleView = UITextField()
    
    //キーボードにつけるツールバー（doneボタン用）
    let keyboardBar = UIToolbar()
    
    //もらってきたデータを格納
    init(tag: Int, colorB: UIColor, title: String, text: String) {
        receiveTag = tag
        receiveColor = colorB
        receiveTitle = title
        receiveText = text
        
        super.init(nibName: nil, bundle: nil)
    }
    
    // 新しく init を定義した場合に必須
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //受け取ったボタンのタグ番号を代入
        //let receiveData = receiveTag
        //print(receiveData)
        
        view.backgroundColor = .white
        
        //画面上部にボタンと同じ色のヘッダー
        headder()

        // キーボードcloseツールバー生成
        keyboardBar.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 40)
        keyboardBar.barStyle = .default
        keyboardBar.sizeToFit()
        let spacer = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: self, action: nil)
        // 閉じるボタン
        let commitButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(commitButtonTapped))
        // スペース、閉じるボタンを右側に配置
        keyboardBar.items = [spacer, commitButton]
        
        //textviewを表示
        viewText()
        
        toolArea()
        
        //アイコン設定画面へ繊維するボタン
        iconEdit()
        
        print("受け取りデータ：\(receiveTitle), \(receiveText), \(receiveTag)")
        
    }
    
    func iconEdit() {
        let iconEditButton = UIButton()
        iconEditButton.frame = CGRect(x: view.frame.width - 50, y: view.frame.height - 100, width: 50, height: 50)
        iconEditButton.layer.cornerRadius = 25
        //iconEditButton.backgroundColor = .black
        iconEditButton.setImage(#imageLiteral(resourceName: "text"), for: .normal)
        
        iconEditButton.addTarget(self, action: #selector(ViewMove), for: .touchUpInside)
        
        view.addSubview(iconEditButton)
    }
    
    @objc func ViewMove() {
        let sendTitle = titleView.text
        let nextView = IconEditView(receiveTitle: sendTitle!, receiveColor: receiveColor)
        
        present(nextView, animated: true, completion: nil)
        
    }
    
    //タイトル入力エリア
    func headder() {
        let headder = UIView()
        headder.backgroundColor = receiveColor
        headder.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height / 3.5)
        
        view.addSubview(headder)
        
        titleView.frame = CGRect(x: 0, y: headder.frame.height / 2, width: headder.frame.width, height: headder.frame.height / 2)
        titleView.textColor = .white
        titleView.font = UIFont(name: "Avenir-Oblique", size: 60)
        titleView.text = receiveTitle
        
        headder.addSubview(titleView)
    }
    
    //テキスト入力エリア
    func viewText() {
        
        text.frame = CGRect(x: 0, y: view.frame.height / 3.5, width: view.frame.width, height: view.frame.height / 3.5 * 2.5)
        text.returnKeyType = .done
        //text.font = UIFont.systemFont(ofSize: 40)
        text.font = UIFont(name: "Avenir-Oblique", size: 30)
        text.backgroundColor = .clear
        // textViewのキーボードにツールバーを設定
        text.inputAccessoryView = keyboardBar
        text.delegate = self
        text.text = receiveText
        
        
        view.addSubview(text)
    }
    
    @objc func commitButtonTapped() {
        self.view.endEditing(true)
    }
    
    
    //画面下部にツールバーを表示
    func toolArea() {
        //let
        let tabBar = UITabBar()
        tabBar.barTintColor = receiveColor
        tabBar.unselectedItemTintColor = .white
        tabBar.tintColor = .black
        
        //tabBar.frame = CGRect(x: 0, y: view.frame.height / 10 * 9, width: view.frame.width, height: view.frame.height / 10 * 1)
        tabBar.frame = CGRect(x: 0, y: view.frame.height - 50, width: view.frame.width, height: 55)
        
        let test1 = UITabBarItem(title: "remove", image: #imageLiteral(resourceName: "remove"), tag: 1)
        let test2 = UITabBarItem(title: "text", image: #imageLiteral(resourceName: "text"), tag: 2)
        let test3 = UITabBarItem(title: "color", image: #imageLiteral(resourceName: "color"), tag: 3)
        let test4 = UITabBarItem(title: "exit",image: #imageLiteral(resourceName: "exit"), tag: 4)
        
        
        tabBar.items = [test1, test2, test3, test4]
        tabBar.delegate = self
        
        view.addSubview(tabBar)
        
    }
    
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        switch item.tag {
        case 1:
            print("1")
        case 2:
            print("2")
        case 3:
            print("3")
        case 4:
            print("4")
            dataSave()
        default:
            return
        }
    }
    
    //データ保存⇨ホームに戻る
    func dataSave() {
        
        if text.text != "" || titleView.text != "" {
            //CoreDataにデータを保存する
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            let data = SaveData(context: context)
            
            data.text = text.text
            data.title = titleView.text
            data.tag = Int64(receiveTag)
            
            print("保存対象データ：\(String(describing: data.text)), \(String(describing: data.title)), \(data.tag)")
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
        }
        
        dismiss(animated: true, completion: nil)
    }
    


    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}


//キーボード以外のところを押したらキーボードが閉じる設計
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.hideKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
}
