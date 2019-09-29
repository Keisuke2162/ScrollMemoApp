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
    
    //セーブデータ格納用
    var inputData: [SaveData] = []
    //データ一時格納用
    var editData = SaveData()
    
    //ホーム画面から受け取るデータ
    var tag = 0
    var color: UIColor = .clear
    var textContent = ""
    var titleContent = ""
    var returnKey = ""
    var subject = ""
    
    
    //var buttonIcon: UIImage = #imageLiteral(resourceName: "add")
    var buttonIconName: String = ""
    
    //メモ記入用
    let text = UITextView()
    
    //タイトル記入用
    let titleView = UITextField()
    
    //キーボードにつけるツールバー（doneボタン用）
    let keyboardBar = UIToolbar()

    
    //もらってきたデータを格納
    init(sendTag: Int, sendColor: UIColor, sendTitle: String, sendText: String, sendIconName: String, receiveArray: [SaveData], viewKey: String, sendSubject: String) {
        
        self.tag = sendTag
        self.color = sendColor
        self.textContent = sendText
        self.titleContent = sendTitle
        self.inputData = receiveArray
        self.buttonIconName = sendIconName
        self.returnKey = viewKey
        self.subject = sendSubject

        super.init(nibName: nil, bundle: nil)
        
    }
    
    // 新しく init を定義した場合に必須
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        //ツールバーを表示
        //toolArea()
        
        //アイコン設定画面へ繊維するボタン
        iconEdit()
        
        //戻るボタン
        //returnButton()
        
    }
    
    //画面が帰ってきたときに再ロードする
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
     
       iconEditButton.setImage(UIImage(named: buttonIconName), for: .normal)
        
    }
    
    @objc func returnSpring() {
        dataSave()
        
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = CATransitionType.reveal
        transition.subtype = CATransitionSubtype.fromBottom
        navigationController?.view.layer.add(transition, forKey: nil)

        navigationController?.popToViewController(navigationController!.viewControllers[0], animated: false)
    }
    
    let iconEditButton = UIButton()
    
    func iconEdit() {
        
        iconEditButton.frame = CGRect(x: view.frame.width - 75, y: view.frame.height - 75, width: 50, height: 50)
        
        iconEditButton.setImage(UIImage(named: buttonIconName), for: .normal)
        
        if buttonIconName == "" {
            iconEditButton.setImage(#imageLiteral(resourceName: "noneicon"), for: .normal)
        }
        
        iconEditButton.addTarget(self, action: #selector(ViewMove), for: .touchUpInside)
        
        view.addSubview(iconEditButton)
    }

    //アイコン画像エディット画面へ遷移
    @objc func ViewMove() {
        let nextView = IconList()
        nextView.viewKey = "Text"
        self.navigationController?.pushViewController(nextView, animated: true)
    }
    
    //タイトル入力エリア
    func headder() {
        
        let headder = UIView()
        
        if color == .clear {
            headder.backgroundColor = .clear
        } else {
            headder.backgroundColor = color
        }
        
        headder.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height / 4)
        
        view.addSubview(headder)
        
        titleView.frame = CGRect(x: 0, y: headder.frame.height / 2, width: headder.frame.width, height: headder.frame.height / 2)
        titleView.textColor = .white
        titleView.font = UIFont(name: "Avenir-Oblique", size: 40)
        titleView.text = titleContent
        
        headder.addSubview(titleView)
        
        let returnIcon = UIButton()
        
        returnIcon.frame = CGRect(x: headder.frame.width - 50, y: headder.frame.height - 50, width: 50, height: 50)
        returnIcon.setImage(#imageLiteral(resourceName: "doubledown"), for: .normal)
        returnIcon.setTitleColor(.white, for: .normal)
        returnIcon.addTarget(self, action: #selector(returnSpring), for: .touchUpInside)
        
        headder.addSubview(returnIcon)
    }
    
    //テキスト入力エリア
    func viewText() {
        
        text.frame = CGRect(x: 0, y: view.frame.height / 4, width: view.frame.width, height: view.frame.height / 4 * 2.5)
        text.returnKeyType = .done
        //text.font = UIFont.systemFont(ofSize: 40)
        text.font = UIFont(name: "Avenir-Oblique", size: 20)
        text.backgroundColor = .clear
        // textViewのキーボードにツールバーを設定
        text.inputAccessoryView = keyboardBar
        //text.delegate = self
        text.text = textContent
        
        
        view.addSubview(text)
    }
    
    @objc func commitButtonTapped() {
        self.view.endEditing(true)
    }
    
    //データ保存⇨ホームに戻る
    func dataSave() {
        
        let headderColor = color
        let saveColor = headderColor.rgbString
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let data = SaveData(context: context)
        
        
        for searchNum in 0 ..< inputData.count {
            if tag == inputData[searchNum].tag {
                let deleteData = inputData[searchNum]
                context.delete(deleteData)

                break
            }
        }
        
        data.text = text.text
        data.title = titleView.text
        data.tag = Int64(tag)
        data.iconName = buttonIconName
        data.iconColor = saveColor
        data.subject = subject
        
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
    }
    


    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}


//キーボード以外のところを押したらキーボードが閉じる設計(意味ない)
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
