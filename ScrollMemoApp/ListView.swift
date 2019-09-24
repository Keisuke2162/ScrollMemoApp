//
//  ListView.swift
//  ScrollMemoApp
//
//  Created by 植田圭祐 on 2019/09/23.
//  Copyright © 2019 Keisuke Ueda. All rights reserved.
//


import UIKit

//ボタンの内容を表示する画面

class ListView: UIViewController, UITabBarDelegate, UITextViewDelegate, UITableViewDataSource, UITableViewDelegate {

    
    var testStr = ["testA","testB","testC","testD","testE","testF","testG"]
    
    var testTableView: UITableView!
    //セーブデータ格納用
    var inputData: [SaveData] = []
    //データ一時格納用
    var editData = SaveData()
    
    //ホーム画面から受け取るデータ
    var receiveTag = 0
    var receiveColor: UIColor = .clear
    var receiveTitle = ""
    var receiveText = ""
    var returnKey = ""
    
    
    //var buttonIcon: UIImage = #imageLiteral(resourceName: "add")
    var buttonIconName: String = ""
    
    //メモ記入用
    let text = UITextView()
    
    //タイトル記入用
    let titleView = UITextField()
    
    //キーボードにつけるツールバー（doneボタン用）
    let keyboardBar = UIToolbar()
    
    
    //もらってきたデータを格納
    init(sendTag: Int, sendColor: UIColor, sendTitle: String, sendText: String, sendIconName: String, receiveArray: [SaveData], viewKey: String) {
        
        self.receiveTag = sendTag
        self.receiveColor = sendColor
        self.receiveTitle = sendTitle
        self.receiveText = sendText
        self.inputData = receiveArray
        self.buttonIconName = sendIconName
        self.returnKey = viewKey
        
        super.init(nibName: nil, bundle: nil)
        
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return testStr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //TableViewCellの識別子（todoCell）を使って再利用可能セルを生成
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoCell", for: indexPath)
        //行番号に適したTodoのデータを取得
        let data = testStr[indexPath.row]
        //セルのラベルにTodoのタイトルをセット
        cell.textLabel?.text = data
        cell.textLabel?.tintColor = .black
        cell.accessoryType = UITableViewCell.AccessoryType.none
        
        return cell
    }
    
    //セルをタップした時に発動する処理
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print("selectCell")
    }
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    
    
    
    //myTableView1.estimatedRowHeight = 100
    //myTableView1.rowHeight = UITableViewAutomaticDimension
    
    // 新しく init を定義した場合に必須
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        testTableView = UITableView(frame: CGRect(x: 0, y: view.frame.height / 4, width: view.frame.width, height: view.frame.height / 4 * 2.5))
        testTableView.delegate = self
        testTableView.dataSource = self
        testTableView.estimatedRowHeight = 100
        testTableView.rowHeight = UITableView.automaticDimension
        
        view.addSubview(testTableView)
        
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
        
        //tableView表示
        ListView()
        
        //ツールバーを表示
        //toolArea()
        
        //アイコン設定画面へ繊維するボタン
        iconEdit()
        
        //戻るボタン
        //returnButton()
        
        print("受け取りデータ：\(receiveTitle), \(receiveText), \(receiveTag), \(receiveColor)")
    }
    
    //画面が帰ってきたときに再ロードする
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        iconEditButton.setImage(UIImage(named: buttonIconName), for: .normal)
        
    }
    
    @objc func returnSpring() {
        dataSave()
        
        //dismiss(animated: true, completion: nil)
        
        
        if returnKey == "Home" {
            dismiss(animated: true, completion: nil)
        } else if returnKey == "General" {
            let returnView = self.presentingViewController as! GeneralView
            returnView.returnViewTag = true
            dismiss(animated: true, completion: nil)
        }
        
    }
    
    func ListView() {
        
    }
    
    
    
    let iconEditButton = UIButton()
    
    func iconEdit() {
        
        iconEditButton.frame = CGRect(x: view.frame.width - 75, y: view.frame.height - 75, width: 50, height: 50)
        
        print("アイコン名は\(buttonIconName)")
        
        iconEditButton.setImage(UIImage(named: buttonIconName), for: .normal)
        
        if buttonIconName == "" {
            iconEditButton.setImage(#imageLiteral(resourceName: "noneicon"), for: .normal)
        }
        
        iconEditButton.addTarget(self, action: #selector(ViewMove), for: .touchUpInside)
        
        view.addSubview(iconEditButton)
    }
    
    //アイコン画像エディット画面へ遷移
    @objc func ViewMove() {
        //let sendTitle = titleView.text
        //let nextView = IconEditView(receiveTitle: sendTitle!, receiveColor: receiveColor)
        let nextView = IconList()
        
        present(nextView, animated: true, completion: nil)
        
    }
    
    
    
    //タイトル入力エリア
    func headder() {
        
        let headder = UIView()
        
        if receiveColor == .clear {
            headder.backgroundColor = .black
        } else {
            headder.backgroundColor = receiveColor
        }
        
        headder.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height / 4)
        
        view.addSubview(headder)
        
        titleView.frame = CGRect(x: 0, y: headder.frame.height / 2, width: headder.frame.width, height: headder.frame.height / 2)
        titleView.textColor = .white
        titleView.font = UIFont(name: "Avenir-Oblique", size: 40)
        titleView.text = receiveTitle
        
        headder.addSubview(titleView)
        
        let returnIcon = UIButton()
        
        returnIcon.frame = CGRect(x: headder.frame.width - 50, y: headder.frame.height - 50, width: 50, height: 50)
        returnIcon.setImage(#imageLiteral(resourceName: "doubledown"), for: .normal)
        returnIcon.setTitleColor(.white, for: .normal)
        returnIcon.addTarget(self, action: #selector(returnSpring), for: .touchUpInside)
        
        headder.addSubview(returnIcon)
    }
    
    //テキスト入力エリア

    
    @objc func commitButtonTapped() {
        self.view.endEditing(true)
    }
    
    //データ保存⇨ホームに戻る
    func dataSave() {
        
        let headderColor = receiveColor
        let saveColor = headderColor.rgbString
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let data = SaveData(context: context)
        
        
        for searchNum in 0 ..< inputData.count {
            if receiveTag == inputData[searchNum].tag {
                let deleteData = inputData[searchNum]
                context.delete(deleteData)
                
                break
            }
        }
        
        data.text = text.text
        data.title = titleView.text
        data.tag = Int64(receiveTag)
        data.iconName = buttonIconName
        data.iconColor = saveColor
        
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

//独自のクラスをエンコード、デコードするのでNSObjectを継承かつNSCodingプロトコルへの準拠が必須
class Todo: NSObject, NSSecureCoding {
    static var supportsSecureCoding: Bool = true
    
    //todoのタイトル
    var todoTitle: String?
    //todoの状態フラグ
    var todoDone: Bool = false
    //コントラクタ
    override init() {
        
    }
    
    //NSCodingsプロトコルに宣言されているデシリアライズ処理（デコード処理）
    required init?(coder aDecoder: NSCoder) {
        todoTitle = aDecoder.decodeObject(forKey: "todoTitle") as? String
        todoDone = aDecoder.decodeBool(forKey: "todoDone")
    }
    
    //NSCodingsプロトコルに宣言されているシリアライズ処理（エンコード処理）
    func encode(with aCoder: NSCoder) {
        aCoder.encode(todoTitle, forKey: "todoTitle")
        aCoder.encode(todoDone, forKey: "todoDone")
    }
}


/*
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
 */


