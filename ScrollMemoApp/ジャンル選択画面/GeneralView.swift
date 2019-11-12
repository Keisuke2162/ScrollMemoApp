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
    
    
    let iconName = ["text","list","todo","image"]
    let subject = ["memo","list","graph","map","diary","photo","A","B","C"]
    let buttonColor = ["00A2E9","89C3EB","1D50A2","004F7A","829AC8","1760A0","00B8EE","5C6EB1","384D9F","AFC0E2","005481","89A3D3"]
    let kidsColor = ["de6c31","fed500","00a0e8","153692","008542","ea6088","efa72b","aecfed","efcfe2"]
    let rainbow = ["e50011","ee7700","fff000","00a73b","0064b3","5f1885","2a2489","fefefe","000000"]
    
    //キーボードにつけるツールバー（doneボタン用）
    let keyboardBar = UIToolbar()
    
    var titleStr: String = ""
    
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
    var headder = UIView()

    func HeadderView() {
        headder.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height / 10 * 3)
        view.addSubview(headder)
        
        /* カラーピッカー
        let colorPickerView = ColorPickerView(frame: CGRect(x: 0, y: view.frame.height / 10 * 9, width: view.frame.width, height: view.frame.height / 10))
        view.addSubview(colorPickerView)
        */
        
        titleField.frame = CGRect(x: view.frame.width / 4, y: headder.frame.height / 5 * 3.5, width: view.frame.width / 2, height: headder.frame.height / 5)
        titleField.text = "test"
        titleField.backgroundColor = .white
        titleField.layer.borderColor = UIColor.white.cgColor
        titleField.layer.cornerRadius = 10.0
        titleField.layer.borderWidth = 1.0
        // textViewのキーボードにツールバーを設定
        titleField.inputAccessoryView = keyboardBar
        
        headder.addSubview(titleField)
        
        /*カラーピッカーに合わせて動的にヘッダーの色を変更
        colorPickerView.onColorDidChange = { color in
            DispatchQueue.main.async {
                
                // use picked color for your needs here...
                headder.backgroundColor = color
                self.headderColor = color
                
            }
            
        }*/
        let x = view.frame.width / 6
        let y = view.frame.height / 10
        
        for i in 0 ..< 8 {
            let xNum = CGFloat(i % 4)
            let yNum = CGFloat(i / 4 + 8)
            
            let colorButton = UIButton(frame: CGRect(x: (xNum + 0.1) * x, y: yNum * y, width: x * 0.8, height: x * 0.8))
            colorButton.layer.cornerRadius = x / 2 * 0.8
            colorButton.backgroundColor = UIColor(colorCode: buttonColor[i])
            colorButton.addTarget(self, action: #selector(changeHeadder), for: .touchUpInside)
            colorButton.tag = i
            view.addSubview(colorButton)
        }
    }
    
    @objc func changeHeadder(_ sender: UIButton) {
        headderColor = UIColor(colorCode: buttonColor[sender.tag])
        headder.backgroundColor = headderColor
    }
    
    func SetView() {
        
        let width = view.frame.width / 9
        let height = view.frame.height / 10
        
        scrollView.frame = CGRect(x: 0, y: height * 3.5, width: view.frame.width, height: height * 5)
        scrollView.contentSize = CGSize(width: view.frame.width * 3, height: height * 5)
        scrollView.delegate = self
        scrollView.isPagingEnabled = true
        scrollView.showsVerticalScrollIndicator = false
        view.addSubview(scrollView)

        //ページ１
        let view1 = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: height * 4))
        view1.backgroundColor = .white
        scrollView.addSubview(view1)
        //選択種目ボタン
        for i in 0 ..< 4 {
            let generalButton = UIButton()
            let x = CGFloat(i % 2)
            let y = CGFloat(i / 2)
            
            generalButton.tag = i
            generalButton.frame = CGRect(x: width * 5 * x, y: view1.frame.height / 2 * y, width: width * 4, height: width * 4)
            generalButton.setImage(UIImage(named: iconName[i]), for: .normal)
            generalButton.addTarget(self, action: #selector(ChooseButton), for: .touchUpInside)
            
            //generalButton.layer.borderColor = UIColor.black.cgColor
            //generalButton.layer.borderWidth = 2.0
            
            view1.addSubview(generalButton)
        }
        
        /*
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
 */

    }
    
    var sendData: Data?
    
    //
    func MoveNextView(subject: String) {
        let titleTxt = String(titleField.text!)
        var nextView = UIViewController()
        
       
        switch subject {
        case "memo":
            print("Go to memo")
            nextView = EditView(sendTag: sendTag, sendColor: headderColor, sendTitle: titleTxt, sendText: "", sendIconName: "", receiveArray: inputData, viewKey: "General", sendSubject: "Text")
        case "list":
            print("Go to list")
            nextView = ListView(sendTag: sendTag, sendColor: headderColor, sendTitle: titleTxt, sendArr: sendData, sendIconName: "", receiveArray: inputData, viewKey: "General", sendSubject: "List")
        case "graph":
            print("Go to graph")
        case "map":
            print("Go to map")
        default:
            print("Other")
        }
        self.navigationController?.pushViewController(nextView, animated: true)
    }
    
    
    //ページ１＆２でボタンを押したら次のページにスクロール
    var chooseButton = UIButton()
    @objc func ChooseButton(_ sender: UIButton) {
        chooseButton.layer.borderColor = UIColor.clear.cgColor
        
        chooseButton = sender
        chooseButton.layer.borderColor = UIColor.blue.cgColor
        chooseButton.layer.borderWidth = 1.0
        
        let chooseSub = subject[sender.tag]
        MoveNextView(subject: chooseSub)
        
        //ViewScroll()
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
        
        
        //pageControl.currentPage = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
    }
}


