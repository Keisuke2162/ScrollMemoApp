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
    
    var testTableView = UITableView()
    //セーブデータ格納用
    var inputData: [SaveData] = []
    //データ一時格納用
    var editData = SaveData()
    
    //ホーム画面から受け取るデータ
    var receiveTag = 0
    var receiveColor: UIColor = .clear
    var receiveTitle = ""
    //var receiveText = ""
    var returnKey = ""
    var receiveArr: Data?
    
    var strArr: [String] = []
    
    var buttonIconName: String = ""
    
    //タイトル記入用
    let titleView = UITextField()
    
    //キーボードにつけるツールバー（doneボタン用）
    let keyboardBar = UIToolbar()
    
    
    //もらってきたデータを格納
    init(sendTag: Int, sendColor: UIColor, sendTitle: String, sendArr: Data?, sendIconName: String, receiveArray: [SaveData], viewKey: String, sendSubject: String) {
        self.receiveTag = sendTag
        self.receiveColor = sendColor
        self.receiveTitle = sendTitle
        //self.receiveText = sendText
        self.inputData = receiveArray
        self.buttonIconName = sendIconName
        self.returnKey = viewKey
        self.receiveArr = sendArr
        
        super.init(nibName: nil, bundle: nil)
    }
    
    // 新しく init を定義した場合に必須
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //tableView設定項目
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return strArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //TableViewCellの識別子（todoCell）を使って再利用可能セルを生成
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoCell", for: indexPath)
        //行番号に適したTodoのデータを取得
        let data = strArr[indexPath.row]
        //セルのラベルにTodoのタイトルをセット
    
        cell.textLabel?.text = data
        cell.textLabel?.tintColor = .black
        cell.accessoryType = UITableViewCell.AccessoryType.none
        
        return cell
    }
    
    //セルをタップした時に発生する処理
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("selectCell")
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            strArr.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.fade)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        //tableViewを表示
        testTableView = UITableView(frame: CGRect(x: 0, y: view.frame.height / 4, width: view.frame.width, height: view.frame.height / 4 * 2.5))
        testTableView.delegate = self
        testTableView.dataSource = self
        testTableView.estimatedRowHeight = 100
        testTableView.rowHeight = UITableView.automaticDimension
        testTableView.register(UITableViewCell.self, forCellReuseIdentifier: "todoCell")
        
        view.addSubview(testTableView)
        
        //Data?型の配列データをアンラップ
        if let strData = receiveArr {
            strArr = try! JSONDecoder().decode([String].self, from: strData)
        }
        
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

        
        //ツールバーを表示
        //toolArea()
        
        //アイコン設定画面へ繊維するボタン
        SetButton()
        
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
    
    func SetButton() {
        
        /*
        //アイコン選択画面への遷移ボタン
        iconEditButton.frame = CGRect(x: view.frame.width - 75, y: view.frame.height - 75, width: 50, height: 50)
        iconEditButton.setImage(UIImage(named: buttonIconName), for: .normal)
        iconEditButton.addTarget(self, action: #selector(ViewMove), for: .touchUpInside)
        view.addSubview(iconEditButton)
 */
        
        let addButton = UIButton(frame: CGRect(x: view.center.x - 25, y: view.frame.height - 75, width: 50, height: 50))
        addButton.setImage(#imageLiteral(resourceName: "new"), for: .normal)
        addButton.addTarget(self, action: #selector(AddTask), for: .touchUpInside)
        view.addSubview(addButton)
    }
    
    //アイコン選択画面へ遷移
    @objc func ViewMove() {
        let nextView = IconList()
        present(nextView, animated: true, completion: nil)
    }
    
    @objc func AddTask() {
        //Todo追加ダイアログのUI作成
        let alertController = UIAlertController(title: "AddTodo", message: "Please input", preferredStyle: UIAlertController.Style.alert)
        //テキストエリアを追加
        alertController.addTextField(configurationHandler: nil)
        //ダイアログにのせるOKボタンを定義
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) { (action: UIAlertAction) in
            //OKボタンた押下時の処理（テキストが入力されている場合）
            if let textFiled = alertController.textFields?.first {
                //Todoの配列に入力値（テキスト）を挿入。
                self.strArr.insert(textFiled.text!, at: 0)
                //行が追加されたことをテーブルに通知する
                self.testTableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: UITableView.RowAnimation.right)
            }
        }
        //作ったOKボタンをダイアログに追加
        alertController.addAction(okAction)
        
        //CANCELボタンを定義
        let cancelButton = UIAlertAction(title: "CANCEL", style: UIAlertAction.Style.cancel, handler: nil)
        //CANCELボタンをダイアログに追加
        alertController.addAction(cancelButton)
        
        //ダイアログを表示する
        present(alertController, animated: true, completion: nil)
        
    }
    
    //ヘッダー作成
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
    
    @objc func commitButtonTapped() {
        self.view.endEditing(true)
    }
    
    //データ保存⇨ホームに戻る
    func dataSave() {
        
        let arrAsString = strArr.description
        let saveArr = arrAsString.data(using: String.Encoding.utf16)
    
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
        
        data.text = ""
        data.title = titleView.text
        data.tag = Int64(receiveTag)
        data.iconName = buttonIconName
        data.iconColor = saveColor
        data.strArr = saveArr
        data.subject = "List"
        
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

//独自のクラスをエンコード、デコードするのでNSObjectを継承
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
