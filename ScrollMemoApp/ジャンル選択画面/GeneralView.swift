//
//  GeneralView.swift
//  ScrollMemoApp
//
//  Created by 植田圭祐 on 2019/09/02.
//  Copyright © 2019 Keisuke Ueda. All rights reserved.
//

import UIKit

class GeneralView: UIViewController {
    
    var inputData: [SaveData] = []
    var sendTag = 0
    
    var returnViewTag = false
    
    var scrollView = UIScrollView()
    var pageControl: UIPageControl!
    var headderColor: UIColor = .clear
    
    
    let iconName = ["text","list","chart","map","night","noneicon","noneicon","noneicon","noneicon"]
    let subject = ["memo","list","graph","map","diary","photo","A","B","C"]
    
    //キーボードにつけるツールバー（doneボタン用）
    let keyboardBar = UIToolbar()
    
    var titleStr: String = ""
    var setSub: String = ""
    
    init(receiveArray: [SaveData], receiveTag: Int){
        self.inputData = receiveArray
        self.sendTag = receiveTag
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if returnViewTag == true {
            returnViewTag = false
            dismiss(animated: false, completion: nil)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        keyboardBar.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 40)
        keyboardBar.barStyle = .default
        keyboardBar.sizeToFit()
        let spacer = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: self, action: nil)
        // 閉じるボタン
        let commitButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(commitButtonTapped))
        // スペース、閉じるボタンを右側に配置
        keyboardBar.items = [spacer, commitButton]
        
        view.backgroundColor = .white
        SetView()
        HeadderView()
    }
    
    @objc func commitButtonTapped() {
        self.view.endEditing(true)
    }
    
    var titleField = UITextField()

    func HeadderView() {
        let headder = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height / 10 * 3))
        view.addSubview(headder)
        
        let colorPickerView = ColorPickerView(frame: CGRect(x: 0, y: view.frame.height / 10 * 9, width: view.frame.width, height: view.frame.height / 10))
        view.addSubview(colorPickerView)
        
        
        titleField.frame = CGRect(x: view.frame.width / 4, y: headder.frame.height / 5 * 3.5, width: view.frame.width / 2, height: headder.frame.height / 5)
        titleField.text = "test"
        titleField.backgroundColor = .white
        titleField.layer.borderColor = UIColor.white.cgColor
        titleField.layer.cornerRadius = 10.0
        titleField.layer.borderWidth = 1.0
        // textViewのキーボードにツールバーを設定
        titleField.inputAccessoryView = keyboardBar
        
        headder.addSubview(titleField)

        colorPickerView.onColorDidChange = { color in
            DispatchQueue.main.async {
                
                // use picked color for your needs here...
                headder.backgroundColor = color
                self.headderColor = color
                
            }
            
        }
    }
    
    func SetView() {
        
        let width = view.frame.width / 10
        let height = view.frame.height / 10
        
        scrollView.frame = CGRect(x: 0, y: height * 3.5, width: view.frame.width, height: height * 5)
        scrollView.contentSize = CGSize(width: view.frame.width * 3, height: height * 5)
        scrollView.delegate = self
        scrollView.isPagingEnabled = true
        scrollView.showsVerticalScrollIndicator = false
        view.addSubview(scrollView)

        //ページ１
        let view1 = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: height * 5))
        view1.backgroundColor = .white
        scrollView.addSubview(view1)
        //選択種目ボタン
        for i in 0 ..< 9 {
            let generalButton = UIButton()
            let x = CGFloat(i % 3 * 3 + 1)
            let y = CGFloat(i / 3)
            
            generalButton.tag = i
            generalButton.frame = CGRect(x: width * x, y: view1.frame.height / 3 * y, width: width * 2, height: width * 2)
            generalButton.setImage(UIImage(named: iconName[i]), for: .normal)
            generalButton.addTarget(self, action: #selector(ChooseButton), for: .touchUpInside)
            
            view1.addSubview(generalButton)
        }
        
        //ページ２
        let view2 = UIView(frame: CGRect(x: view.frame.width, y: 0, width: view.frame.width, height: height * 5))
        view2.backgroundColor = .blue
        scrollView.addSubview(view2)
        
        let nextButton = UIButton(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
        nextButton.setImage(#imageLiteral(resourceName: "exit"), for: .normal)
        nextButton.addTarget(self, action: #selector(ChooseButton2), for: .touchUpInside)
        view2.addSubview(nextButton)
        
        
        //ページ３
        let view3 = UIView(frame: CGRect(x: view.frame.width * 2, y: 0, width: view.frame.width, height: height * 5))
        view3.backgroundColor = .yellow
        scrollView.addSubview(view3)
        
        let resultButton = UIButton(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
        resultButton.setImage(#imageLiteral(resourceName: "exit"), for: .normal)
        resultButton.addTarget(self, action: #selector(ResultView), for: .touchUpInside)
        view3.addSubview(resultButton)

        
        // pageControlの表示位置とサイズ
        pageControl = UIPageControl(frame: CGRect(x: 0, y: height * 8.5, width: view.frame.width , height: 30))
        pageControl.numberOfPages = 3
        pageControl.pageIndicatorTintColor = .lightGray
        pageControl.currentPageIndicatorTintColor = .black
        view.addSubview(pageControl)

    }
    
    var sendData: Data?
    
    //ページ３の確定ボタンを押したら選択した情報を表示
    @objc func ResultView() {
        let titleTxt = String(titleField.text!)
        
        print("title: \(titleTxt) subject: \(setSub) color: \(headderColor)")
       
        switch setSub {
        case "memo":
            print("Go to memo")
            let nextView = EditView(sendTag: sendTag, sendColor: headderColor, sendTitle: titleTxt, sendText: "", sendIconName: "", receiveArray: inputData, viewKey: "General", sendSubject: "Text")
            present(nextView, animated: true, completion: nil)
        case "list":
            print("Go to list")
            let nextView = ListView(sendTag: sendTag, sendColor: headderColor, sendTitle: titleTxt, sendArr: sendData, sendIconName: "", receiveArray: inputData, viewKey: "General", sendSubject: "List")
            present(nextView, animated: true, completion: nil)
        case "graph":
            print("Go to graph")
        case "map":
            print("Go to map")
        case "diary":
            print("Go to diary")
        case "photo":
            print("Go to photo")
        case "A":
            print("Go to A")
        case "B":
            print("Go to B")
        case "C":
            print("Go to C")
        default:
            print("Other")
        }
    
    }
    
    
    //ページ１＆２でボタンを押したら次のページにスクロール
    var chooseButton = UIButton()
    @objc func ChooseButton(_ sender: UIButton) {
        chooseButton.layer.borderColor = UIColor.clear.cgColor
        
        chooseButton = sender
        chooseButton.layer.borderColor = UIColor.blue.cgColor
        chooseButton.layer.borderWidth = 1.0
        
        setSub = subject[sender.tag]
        
        ViewScroll()
    }
    
    @objc func ChooseButton2(_ sender: UIButton) {
        ViewScroll()
    }
    
    func ViewScroll() {
        let offsetX = scrollView.contentOffset.x
        let offsetY = scrollView.contentOffset.y
        
        scrollView.setContentOffset(CGPoint(x: offsetX + view.frame.width, y: offsetY), animated: true)
    }
}

//GeneralViewにページスクロールを設定する
extension GeneralView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //print(scrollView.contentOffset.x)
        //print("SIZE\(scrollView.frame.size.width)")
        
        
        pageControl.currentPage = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
    }
}
