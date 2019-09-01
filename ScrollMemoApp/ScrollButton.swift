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
        
        /*************CoreData削除(テスト用)***************/
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
        // Do any additional setup after loading the view.
    }
    
    let headder = UIView()
    let headderTitle = UILabel()
    
    //画面が帰ってきたときに再ロードする
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        removeAllSubviews(parentView: scrollView)
        
        getData()
        
        scrollView.frame = CGRect(x: 0.0, y: view.frame.width / 10 * 2.5, width: view.frame.width, height: view.frame.height)
        scrollView.contentSize = CGSize(width:view.frame.width, height:view.frame.height)
        scrollView.backgroundColor = .white
        
        headder.frame = CGRect(x: 0.0, y:0.0 , width: view.frame.width, height: view.frame.width / 10 * 2.5)
        headder.backgroundColor = .lightGray
        
        headderTitle.text = "TEST"
        headderTitle.frame = CGRect(x: headder.frame.width / 2 - 25, y: headder.frame.height / 2 - 25, width: 50, height: 50)
        
        headder.addSubview(headderTitle)
        view.addSubview(headder)
        view.addSubview(scrollView)
        
        SetButton(row: row)
    }
    
    //view内のsubViewを全て削除する
    func removeAllSubviews(parentView: MyScrollView){
        let subviews = parentView.subviews
        for subview in subviews {
            subview.removeFromSuperview()
        }
    }

    
    @objc func AddRow() {
        row += 1
        SetButton(row: row)
        print("\(row)行目")
    }
    
    let colorName: [UIColor] = [.blue, .red, .yellow, .green, .orange, .gray, .white, .cyan, .magenta, .purple, .brown]
    
    var random: Int = 0
    
    func SetButton(row: Int) {
        var tag: Int = 0
        for i in 0 ..< row {
            for j in 0 ..< 4 {
                let button = UIButton()
                button.frame = CGRect(x: scrollView.frame.width / 4 * CGFloat(j), y: view.frame.height / 6 * CGFloat(i), width: scrollView.frame.width / 4, height: view.frame.height / 6)
                random = Int(arc4random_uniform(11))

                button.tag = tag

                button.layer.borderColor = UIColor.black.cgColor
                //button.layer.borderWidth = 0.25
                
                
                
                for searchNum in 0 ..< inputData.count {
                    if tag == inputData[searchNum].tag {
                        button.backgroundColor = colorName[tag % 11]
                        button.setImage(UIImage(named: inputData[searchNum].iconName!), for: .normal)
                        
                        break
                    }
                }
                
                tag += 1
                
                if button.backgroundColor == nil {
                    button.backgroundColor = .black
                    button.setImage(#imageLiteral(resourceName: "around"), for: .normal)
                }
                
                button.addTarget(self, action: #selector(tagPrint), for: .touchUpInside)
                scrollView.addSubview(button)
            }
        }
        
        scrollView.contentSize = CGSize(width:view.frame.width, height:view.frame.height / 6 * CGFloat(row))
        //addButton()
    }
    

    
    @objc func tagPrint(_ sender: UIButton) {
        
        var sendText = ""
        var sendTitle = ""
        
        print(sender.tag)
        
        color = (sender.backgroundColor)!
        
        for searchNum in 0 ..< inputData.count {
            if sender.tag == inputData[searchNum].tag {
                
                sendText = inputData[searchNum].text!
                sendTitle = inputData[searchNum].title!
                break
            }
        }
        
        let nextView = EditView(sendTag: sender.tag, sendColor: color, sendTitle: sendTitle, sendText: sendText)
        
        self.present(nextView, animated: true, completion: nil)
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
