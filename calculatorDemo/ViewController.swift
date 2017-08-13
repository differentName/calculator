//
//  ViewController.swift
//  calculatorDemo
//
//  Created by 天桥艺人 on 2017/8/11.
//  Copyright © 2017年 天桥艺人. All rights reserved.
//

import UIKit
   
class ViewController: UIViewController {
    @IBOutlet weak var topLabelHeight: NSLayoutConstraint!

    @IBOutlet weak var topLabelTopHeight: NSLayoutConstraint!
    @IBOutlet weak var topLabel: UILabel!
    
    @IBOutlet weak var equal: TQYRbutton!
    //检测用户是否是第一次输入内容  以此判断刚开始显示器的0如何处理
    var isFirstInputNum :Bool = true
    //计算过程中的中间值
    var tempValue :Double = 0.0
    //存储运算符
    var tempSymbol :String = ""
    //是否点击过等于号
    var isClickEqual :Bool = true
    //存储点击过的运算符号
    var lastNum :Double = 0.0
    
    //存储计算过的结果值
    var resuletAry :[Double] = [Double]()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //设置字体根据文本长度调整
        topLabel!.adjustsFontSizeToFitWidth = true;
        //文本字体最小倍率
//        topLabel!.minimumScaleFactor = 0.499
        topLabel.sizeToFit()
        //截断方式
        topLabel!.lineBreakMode = NSLineBreakMode.byClipping
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    //设置导航栏状态
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return UIStatusBarStyle.lightContent
    }
    
    
    //屏幕翻转
    override func willRotate(to toInterfaceOrientation: UIInterfaceOrientation, duration: TimeInterval) {
//    print("\(toInterfaceOrientation.isLandscape)")
        if toInterfaceOrientation.isLandscape {//横屏
            topLabelHeight.constant = 80
            //UIFontWeightThin是用来设置字体的粗细的  这是个枚举
            topLabel.font = UIFont.systemFont(ofSize: 40, weight: UIFontWeightThin)
            topLabelTopHeight.constant = 5
        }else{
            topLabelHeight.constant = 150
            topLabel.font = UIFont.systemFont(ofSize: 90, weight: UIFontWeightThin)
            topLabelTopHeight.constant = 40
        }
    }
    //清除功能
    @IBAction func clear(_ sender: TQYRbutton) {
        topLabel!.text = "0"
        isFirstInputNum = true
        resuletAry.removeAll()
    }
    //数字按键
    @IBAction func clickNumbetBtn(_ sender: TQYRbutton) {
        print(sender.currentTitle!)
        if self.isAllowUserToInput() {
            if isFirstInputNum {
                if (topLabel!.text!.contains("-") && isClickEqual) {//
                    topLabel.text = "-"+sender.currentTitle!
                }else{
                    topLabel.text = sender.currentTitle!
                }
                isFirstInputNum = false
            }else{
                topLabel.text = topLabel.text! + sender.currentTitle!
            }
            
            //未点击等于号直接运算
            if tempSymbol != "" {
                switch tempSymbol {
                case "+":
                    resuletAry.append(Double(treatCalculateResult(str: String(replaceInsertPartitionWithNum(num: topLabel!.text!) + lastNum)))!)
                case "-":
                    resuletAry.append(Double(treatCalculateResult(str: String (lastNum - (replaceInsertPartitionWithNum(num: topLabel!.text!)))))!)
                case "×":
                    resuletAry.append(Double(treatCalculateResult(str: String(replaceInsertPartitionWithNum(num: topLabel!.text!) * lastNum)))!)
                case "÷":
                    resuletAry.append(Double(treatCalculateResult(str: String(lastNum / replaceInsertPartitionWithNum(num: topLabel!.text!))))!)
                default:
                    print(sender.currentTitle!)
                }
                
            }
            lastNum = replaceInsertPartitionWithNum(num: topLabel!.text!)

        }
       
        
    }
    //符号按钮
    @IBAction func clickSymbolBtn(_ sender: TQYRbutton) {
        switch sender.currentTitle! {
        case ".":
            if self.isAllowUserToInput() {
                
                if topLabel.text!.contains(".") {
                    return;
                }
                topLabel.text = topLabel.text! + sender.currentTitle!
                isFirstInputNum = false
            }
           
        case "+":
            tempValue = replaceInsertPartition()
            isFirstInputNum = true
            tempSymbol = "+"
            
        case "-":
            tempValue = replaceInsertPartition()
            isFirstInputNum = true
            tempSymbol = "-"
            
        case "×":
            tempValue = replaceInsertPartition()
            isFirstInputNum = true
            tempSymbol = "×"
            
        case "÷":
            tempValue = replaceInsertPartition()
            isFirstInputNum = true
            tempSymbol = "÷"
            
        case "=":
            if resuletAry.count >= 2 {
                tempValue = resuletAry[resuletAry.count - 2]
            }
            switch tempSymbol {
            case "+":
                topLabel!.text! = treatCalculateResult(str: String(replaceInsertPartitionWithNum(num: topLabel!.text!) + tempValue))
            case "-":
                topLabel!.text! = treatCalculateResult(str: String (tempValue - (replaceInsertPartitionWithNum(num: topLabel!.text!))))
            case "×":
                topLabel!.text! = treatCalculateResult(str: String(replaceInsertPartitionWithNum(num: topLabel!.text!) * tempValue))
            case "÷":
                topLabel!.text! = treatCalculateResult(str: String(tempValue / replaceInsertPartitionWithNum(num: topLabel!.text!)))
            default:
                print(sender.currentTitle!)
            }
            
            if topLabel!.text! == "inf" {
                topLabel!.text! = "错误"
            }else{
                resuletAry.append(Double(replaceInsertPartition()))
            }
            
            isFirstInputNum = true
            tempValue = replaceInsertPartition()
            tempSymbol = ""
            isClickEqual = false
            print(sender.currentTitle!)
            
        case "+/-":
            let topLabelNum = replaceInsertPartition()
            
            
            if topLabel.text!.contains(".") {//有小数部分
                topLabel!.text = String(0-topLabelNum)
            }else{//全是整数
                topLabel!.text = String(Int(0-topLabelNum))
            }
            print(sender.currentTitle!)
            
        case "%":
            //字符串转换为double类型
            let topLabelNum = replaceInsertPartition()
            topLabel!.text = String(topLabelNum/100.0)
            
        default:print(sender.currentTitle!)
            
        }
        
    }
    
    //是否允许用户继续输入
    func isAllowUserToInput() -> Bool {
        let maxLength = 11
        
        if ((topLabel!.text?.lengthOfBytes(using: String.Encoding.utf8)) == maxLength){
            return false
        }else{
            if (self.isInsertPartition()) {
                topLabel!.text! = topLabel!.text! + ","
            }
            return true
        }
    }
    //是否插入分割符
    func isInsertPartition() -> Bool{
        if (topLabel!.text!.contains(".")) {//有小数点则不需要分隔符
            return false
        }else{
            if ((topLabel!.text?.lengthOfBytes(using: String.Encoding.utf8)) == 3 || (topLabel!.text?.lengthOfBytes(using: String.Encoding.utf8)) == 7){
                return true
            }else{
                return false
            }
        }
        
    }
    
    
    //计算需要去掉分隔符
    func replaceInsertPartition() -> Double {
        if topLabel!.text! == "错误" {
            return 0.0
        }else{
            let topLabelNoInsertPartitionNum = Double(topLabel!.text!.replacingOccurrences(of: ",", with: ""))!
            return topLabelNoInsertPartitionNum
        }

    }
    
    //去掉特定文本的分隔符
    func replaceInsertPartitionWithNum(num :String) -> Double {
        let topLabelNoInsertPartitionNum = Double(topLabel!.text!.replacingOccurrences(of: ",", with: ""))!
        return topLabelNoInsertPartitionNum
        
    }
    
    //处理运算结果
    func treatCalculateResult(str :String) -> String {
        if str.contains(".") {
            if str.components(separatedBy: ".").last == "0" {
                return str.components(separatedBy: ".").first!
            }else{
                return str
            }
        }else{
            return str
        }
    }
    
}

