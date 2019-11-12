//
//  ScrollButton.swift
//  scrollTest
//
//  Created by 植田圭祐 on 2019/08/06.
//  Copyright © 2019 Keisuke Ueda. All rights reserved.
//

import UIKit
import CoreData


//ホーム画面

class MyScrollView: UIScrollView {
    

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        superview?.touchesBegan(touches, with: event)
    }
    
}

class ScrollButton: UIViewController {

    var iconString: [String] = ["adidas","android","bigben","captain","dragon","ferrari","flower","ios","king",
                                "magic","mazda","monster48","nasa","pharao","pika","pirates","premier",
                                "psyduck","real","mercedes","sagrada","samurai"]
    
    //セーブデータ格納用
    var inputData: [SaveData] = []
    var saveData = SaveData()
    
    
    //CoreDataからデータを取ってくる
    func getData() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        do {
            let fetchequest: NSFetchRequest<SaveData> = SaveData.fetchRequest()
            inputData = try context.fetch(fetchequest)
            
        }catch {
            print("error")
        }
        
        print("\(inputData.count)件のデータを取得しました")
    }
    
    //アイコンのデフォルト行数
    var row = 10
    var color: UIColor = .clear
    
    let scrollView = MyScrollView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Top Page"
        

        // Do any additional setup after loading the view.
    }
    
    let headder = UIView()
    let headderTitle = UILabel()
    let deleteButton = UIButton()
    
    //画面が帰ってきたときに再ロードする
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //view.isOpaque = true
        
        view.backgroundColor = UIColor(colorCode: "3389ca")
        
        removeAllSubviews(parentView: scrollView)
        
        getData()
        
        scrollView.frame = CGRect(x: 0.0, y: view.frame.width / 10 * 2.5, width: view.frame.width, height: view.frame.height)
        scrollView.contentSize = CGSize(width:view.frame.width, height:view.frame.height)
        //scrollView.backgroundColor = UIColor(colorCode: "0023A8")
        scrollView.backgroundColor = .clear
        
        deleteButton.frame = CGRect(x: view.frame.width - 50, y: 50, width: 50, height: 50)
        deleteButton.setTitle("🙅‍♂️", for: .normal)
        deleteButton.addTarget(self, action: #selector(DataDelete), for: .touchUpInside)
        
        //headder.addSubview(headderTitle)
        view.addSubview(deleteButton)
        //view.addSubview(headder)
        view.addSubview(scrollView)
        
        SetButton(row: row)
    }
    
    //CoreData内のデータを全て削除
    @objc func DataDelete() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<SaveData> = SaveData.fetchRequest()
        do{
            let task = try context.fetch(fetchRequest)
            for i in 0..<task.count {
                context.delete(task[i])
            }
        }catch {
            print("error")
        }
        
        viewWillAppear(true)
    }
    
    //view内のsubViewを全て削除する
    func removeAllSubviews(parentView: MyScrollView){
        let subviews = parentView.subviews
        for subview in subviews {
            subview.removeFromSuperview()
        }
    }
    
    //行を増加する
    @objc func AddRow() {
        row += 1
        SetButton(row: row)
    }
    
    func SetButton(row: Int) {
        var tag: Int = 0
        for i in 0 ..< row {
            for j in 0 ..< 3 {
                let button = UIButton()
                
                /**********カード型ホーム*******j の最大値を4に設定する事****/
                /*
                button.frame.origin.x = scrollView.frame.width / 4 * CGFloat(j) + 5
                button.frame.origin.y = scrollView.frame.height / 5.5 * CGFloat(i) + 5
                button.frame.size = CGSize(width: scrollView.frame.width / 4 - 10, height: view.frame.height / 5.5 - 10)
                button.layer.cornerRadius = 10.0
                button.tag = tag
                */
                
                
                /*********サークル型ホーム**********jの最大値を3に設定する事**/
                
                
                let blank = (scrollView.frame.width - (scrollView.frame.width / 3.5 * 3)) / 4
                
                button.frame.origin.x = scrollView.frame.width / 3 * CGFloat(j) + blank
                button.frame.origin.y = scrollView.frame.width / 3 * CGFloat(i)
                button.frame.size = CGSize(width: scrollView.frame.width / 3.5 - 10, height: scrollView.frame.width / 3.5 - 10)
                button.layer.cornerRadius = (scrollView.frame.width / 3.5 - 10) / 2
                button.tag = tag
                
                
                /*******************************************************/
                
                button.imageEdgeInsets = UIEdgeInsets(top: -30.0, left: 0, bottom: 0, right: 0)
                
                for searchNum in 0 ..< inputData.count {
                    if tag == inputData[searchNum].tag {
                        
                        if let colorCode = inputData[searchNum].iconColor {
                            button.backgroundColor = UIColor(colorCode: colorCode)
                        }

                        
                        button.setImage(UIImage(named: inputData[searchNum].iconName!), for: .normal)
                        
                        let label = UILabel(frame: CGRect(x: 0, y: button.frame.height / 4 * 2.5, width: button.frame.width, height:  button.frame.height / 4))
                        label.text = inputData[searchNum].title
                        label.textAlignment = NSTextAlignment.center
                        label.font = UIFont(name: "Avenir-Oblique", size: 20)
                        label.adjustsFontSizeToFitWidth = true
                        button.addSubview(label)
                        
                        
                        break
                    }
                }
                
                tag += 1
                
                if button.backgroundColor == nil {
                    button.backgroundColor = .clear
                    //button.setBackgroundImage(UIImage(named: "62085-OB2I1K-498"), for: .normal)
                    button.layer.borderColor = UIColor.white.cgColor
                    button.layer.masksToBounds = true
                    button.layer.borderWidth = 1.5
                }
                /*
                let longPress = UILongPressGestureRecognizer(target: self, action: #selector(self.onLongPressed(_:)))
                button.tag = 123
                button.addGestureRecognizer(longPress)
 */
                let longPress = UILongPressGestureRecognizer(target: self, action: #selector(self.onLongPress(_:)))
                button.addGestureRecognizer(longPress)
                button.addTarget(self, action: #selector(tagPrint), for: .touchUpInside)
                //button.addTarget(self, action: #selector(ButtonAnimation), for: .touchUpInside)
                scrollView.addSubview(button)
            }
        }
        
        scrollView.contentSize = CGSize(width:view.frame.width, height:view.frame.height / 6 * CGFloat(row))
        //addButton()
    }
    
    @objc func onLongPress(_ gesture: UILongPressGestureRecognizer) {
        guard let sender = gesture.view as? UIButton else {
            print("Sender is not a button")
            return
        }
        
        switch (gesture.state) {
        case .began:
            print("longPress start")
            sender.layer.borderWidth = 5.0
            sender.layer.borderColor = UIColor.black.cgColor
            
            
            let sendButton = sender
            nextView = SendView(sendButton: sendButton)
            nextView.modalPresentationStyle = .overCurrentContext

            present(nextView, animated: true, completion: nil)
 
            
            /*
            let transition = CATransition()
            transition.duration = 0.3
            transition.type = CATransitionType.moveIn
            transition.subtype = CATransitionSubtype.fromBottom
            */
            //navigationController?.view.layer.add(transition, forKey: nil)
        
        case .ended:
            print("longPress end")
            sender.layer.borderWidth = 0.0
            sender.layer.borderColor = UIColor.black.cgColor
            ButtonAnimation(sender: sender)
        default:
            break
        }
        
        // 長押しされたボタンは sender.tag で判別
    }

    
    //ボタン（カード）を裏返す処理
    func ButtonAnimation(sender: UIButton) {
        let width = sender.frame.width / 2
        let x = sender.frame.origin.x + width
        
        UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveEaseIn, animations: {
            sender.frame = CGRect(x: x, y: sender.frame.origin.y, width: 1, height: sender.frame.height)
        }) { _ in
            UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveEaseOut, animations: {
                sender.setBackgroundImage(#imageLiteral(resourceName: "pattern2"), for: .normal)
                sender.frame = CGRect(x: sender.frame.origin.x - width, y: sender.frame.origin.y, width: width * 2, height: sender.frame.height)
            }, completion: nil)
        }
    }
    
    var nextView = UIViewController()
    
    @objc func tagPrint(_ sender: UIButton) {
        var sendViewFlg = false
        
        var sendText = ""
        var sendTitle = ""
        var sendIconName = ""
        var sendData: Data?
        var subject = ""
        
        print(sender.tag)
        
        color = (sender.backgroundColor)!
        
        
        for searchNum in 0 ..< inputData.count {
            if sender.tag == inputData[searchNum].tag {
                
                sendText = inputData[searchNum].text!
                sendTitle = inputData[searchNum].title!
                sendIconName = inputData[searchNum].iconName!
                sendData = inputData[searchNum].strArr
                if let optSubject = inputData[searchNum].subject {
                    subject = optSubject
                }
               
                
                saveData = inputData[searchNum]
                
                sendViewFlg = true
                
                break
            }
        }
        
        if sendViewFlg == true {
            switch subject {
            case "Text":
                nextView = EditView(sendTag: sender.tag, sendColor: color, sendTitle: sendTitle, sendText: sendText, sendIconName: sendIconName,  receiveArray: inputData, viewKey: "Home", sendSubject: subject)
            case "List":
                nextView = ListView(sendTag: sender.tag, sendColor: color, sendTitle: sendTitle, sendArr: sendData, sendIconName: sendIconName, receiveArray: inputData, viewKey: "Home", sendSubject: subject)
                
            default:
                nextView = EditView(sendTag: sender.tag, sendColor: color, sendTitle: sendTitle, sendText: sendText, sendIconName: sendIconName,  receiveArray: inputData, viewKey: "Home", sendSubject: subject)
            }
            
        } else {
            nextView = GeneralView(receiveArray: inputData, receiveTag: sender.tag)
        }
        
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = CATransitionType.moveIn
        transition.subtype = CATransitionSubtype.fromBottom
        navigationController?.view.layer.add(transition, forKey: nil)

        self.navigationController?.pushViewController(nextView, animated: false)
    }
    


    /*
     @IBAction func byPresent(_ sender: Any) {
     let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "presentView") as! PresentViewController
     nextVC.text = "fromViewController"
     self.present(nextVC, animated: true, completion: nil)
     }
     }
     */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
