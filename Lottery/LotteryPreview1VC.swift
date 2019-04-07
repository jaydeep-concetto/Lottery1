//
//  LotteryPreview1VC.swift
//  Lottery
//
//  Created by Vachhani Jaydeep on 13/02/19.
//  Copyright © 2019 Vachhani Jaydeep. All rights reserved.
//

import UIKit
import Firebase
class LotteryPreviewOneCell:UITableViewCell {
    
    @IBOutlet weak var lblLtteryName: UILabel!
    @IBOutlet weak var imgLottery: UIImageView!
}
class LotteryPreview1VC: BaseViewController,UITableViewDelegate, UITableViewDataSource,UINavigationControllerDelegate,UIImagePickerControllerDelegate,LotteryInstructionVCDelegate {
    var selectLotteryType:Int = -1
    var selectLotteryType1:Int = -1
    var timer = Timer()

    var imgLottery: LyEditImageView!
    @IBOutlet weak var imgLotterySuperView:UIView!
    @IBOutlet weak var viewLotteryType:UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnScan: UIButton!
    var mainDict:[String:Any] = [String:Any]()
    let arrTitle:[[String:String]] = [["title":"Fit the entire front ticket on the screen","btn":"Next"],["title":"Move the Box and Fix your numbers and draw date","btn":"Scan"],["title":"Fit the entire back ticket on the screen","btn":"Next"],["title":"Move the Box and Fix that sign","btn":"Scan"]]
    var arrImg:[UIImage] = [UIImage]()
    var lblSign:String = ""
    
    var arrTitleIndex:Int = 0
    var arrLotteryType:[[String:Any]] = [[String:Any]]()
    @IBOutlet weak var tblViewLotteryType: UITableView!
    @IBOutlet weak var conTblHeight: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        lblTitle.text = arrTitle[arrTitleIndex]["title"]
        btnScan.setTitle(arrTitle[arrTitleIndex]["btn"], for: .normal)
    }
  
    override func viewWillAppear(_ animated: Bool) {
        if selectLotteryType == -1{
            self.view.backgroundColor = UIColor.clear

        UIView.animate(withDuration: 0.4, delay: 0.2, options: .curveLinear, animations: {
            self.view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        }, completion: nil)
        }
        self.tabBarController?.tabBar.isHidden=true
        if users.signature != "" && arrTitleIndex == 1
        {
            
            arrTitleIndex += 1
            lblTitle.text = arrTitle[arrTitleIndex]["title"]
            btnScan.setTitle(arrTitle[arrTitleIndex]["btn"], for: .normal)
            let vc = UIImagePickerController()
            vc.sourceType = .camera
            vc.allowsEditing = false
            vc.delegate = self
            present(vc, animated: true)
        }
      
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
      
        picker.dismiss(animated: true)
        //  self.dismiss(animated: false, completion: nil)
    }
    func setData(arrTitleIndexs:Int) {
        let a = self.view.viewWithTag(1004)
        a!.isHidden = true
        let a1 = self.view.viewWithTag(1005)
        a1!.isHidden = true
        self.arrTitleIndex = arrTitleIndexs
        if arrTitleIndex == 2
        {
            arrTitleIndex += 1
            lblTitle.text = arrTitle[arrTitleIndex]["title"]
            btnScan.setTitle(arrTitle[arrTitleIndex]["btn"], for: .normal)
        }
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        guard let image = info[.originalImage] as? UIImage else {
            print("No image found")
            return
        }
        self.view.backgroundColor = UIColor.white
       selectLotteryType = selectLotteryType1
        viewLotteryType.isHidden = true
        self.view.viewWithTag(1001)?.isHidden = false
        self.view.viewWithTag(1002)?.isHidden = false
        self.view.viewWithTag(1003)?.isHidden = false
        self.view.backgroundColor = UIColor.white
        imgLottery = LyEditImageView(frame:CGRect(x: 0, y: 0, width: imgLotterySuperView.frame.size.width, height: imgLotterySuperView.frame.size.height))
        imgLottery.initWithImage(image: image)
        for i in self.imgLotterySuperView.subviews
        {
            i.removeFromSuperview()
        }
        self.imgLotterySuperView.addSubview(imgLottery)
    }
    
    func back()
    {
        NotificationCenter.default.post(name: Notification.Name("peru2"), object: nil)
        self.view.backgroundColor = UIColor.clear
        
        self.dismiss(animated: (selectLotteryType == -1), completion: nil)
    }
    @IBAction func btnBackClicked(_ sender: UIButton) {
        NotificationCenter.default.post(name: Notification.Name("peru2"), object: nil)
        self.view.backgroundColor = UIColor.clear

        self.dismiss(animated: (selectLotteryType == -1), completion: nil)
            
    }
    @IBAction func btnScanClicked(_ sender: UIButton) {
        switch arrTitleIndex {
        case 0:
            if arrImg.count > 0
            {
                arrImg[0] = imgLottery.getCroppedImage()
            }
            else
            {
                arrImg.append(imgLottery.getCroppedImage())
            }
            imgLottery.initWithImage(image:arrImg[0])
            self.imgLotterySuperView.addSubview(imgLottery)
            
            arrTitleIndex += 1
            lblTitle.text = arrTitle[arrTitleIndex]["title"]
            btnScan.setTitle(arrTitle[arrTitleIndex]["btn"], for: .normal)
        case 1:
            recognizeText(img: imgLottery.getCroppedImage(), WhatRecognize: "number")
            
        case 2:
            if arrImg.count > 2
            {
                arrImg[2] = imgLottery.getCroppedImage()
            }
            else
            {
                arrImg.append(imgLottery.getCroppedImage())
            }
            imgLottery.initWithImage(image:arrImg[2])
            self.imgLotterySuperView.addSubview(imgLottery)
            
            arrTitleIndex += 1
            lblTitle.text = arrTitle[arrTitleIndex]["title"]
            btnScan.setTitle(arrTitle[arrTitleIndex]["btn"], for: .normal)
        default:
            let url = URL(string:users.signature)
            if let data = try? Data(contentsOf: url!)
            {
                recognizeText(img: UIImage(data: data)!, WhatRecognize: "selfsign")
            }
            
        }
        
    }
    func numberOfSections(in tableView: UITableView) -> Int
    {
        conTblHeight.constant = CGFloat((arrLotteryType.count == 0) ? 60 : arrLotteryType.count*70)
        conTblHeight.constant = CGFloat((conTblHeight.constant > self.view.frame.size.height-150) ? (self.view.frame.size.height-150) : conTblHeight.constant)
        tableView.backgroundView  = (arrLotteryType.count == 0) ? noDataView(str: Constant_String.No_Friend_To_Display,tableView: tableView) : nil
        return (arrLotteryType.count == 0) ? 0 : 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrLotteryType.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "LotteryPreviewOneCell", for: indexPath) as! LotteryPreviewOneCell
        cell.imgLottery.kf.indicatorType = .activity
        cell.imgLottery.kf.setImage(with:  URL(string: arrLotteryType[indexPath.row]["image"] as? String ?? ""))
        
        cell.lblLtteryName.text = arrLotteryType[indexPath.row]["name"] as? String ?? ""
        
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectLotteryType1 = indexPath.row
        mainDict = arrLotteryType[selectLotteryType1]
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.allowsEditing = false
        vc.delegate = self
        present(vc, animated: true)
    }
    func recognizeText(img:UIImage,WhatRecognize:String)
    {
        let vision = Vision.vision()
        let textRecognizer = vision.onDeviceTextRecognizer()
        let image = VisionImage(image:img)
        var b:[[String:Any]] = [[String:Any]]()
        textRecognizer.process(image) { result, error in
            guard error == nil, let result = result else {
                if WhatRecognize == "number"
                {
                    self.view.makeToast("Scanning was not properly made. Please scan the  lottery number and result date again.", duration: 2, position:CGPoint(x:self.view.frame.size.width/2,y:self.view.frame.size.height-80))
                }
                else
                {
                    self.lblTitle.text = "Choose one of the two"
                    
                    let a = self.view.viewWithTag(1005)
                    a!.isHidden = false
                }
                
                
                return
            }
            let resultText = result.text
            print("text:-",resultText)
            for block in result.blocks {
                //                let blockText = block.text
                //                //   print("block:-",blockText)
                //                let blockConfidence = block.confidence
                //                let blockLanguages = block.recognizedLanguages
                //                let blockCornerPoints = block.cornerPoints
                //                let blockFrame = block.frame
                for line in block.lines {
                    //                    let lineText = line.text
                    //                    //   print("line:-",lineText)
                    //
                    //                    let lineConfidence = line.confidence
                    //                    let lineLanguages = line.recognizedLanguages
                    //                    let lineCornerPoints = line.cornerPoints
                    //                    let lineFrame = line.frame
                    for element in line.elements {
                        let elementText = element.text
                        
                        b.append(["e":elementText,"f":element.frame])
                        //                        let elementConfidence = element.confidence
                        //                        let elementLanguages = element.recognizedLanguages
                        //                        let elementCornerPoints = element.cornerPoints
                        //                        let elementFrame = element.frame
                    }
                }
            }
            b = b.sorted(by: { (g, h) -> Bool in
                (g["f"] as! CGRect).origin.y < (h["f"] as! CGRect).origin.y
            })
            var b1:[[String:Any]] = [[String:Any]]()
            var b2:[Any] = [Any]()
            
            for i in 0..<b.count
            {
                
                if i < b.count-1 && ((b[i]["f"] as! CGRect).origin.y + ((b[i]["f"] as! CGRect).size.height/2) < (b[i+1]["f"] as! CGRect).origin.y || (b[i]["f"] as! CGRect).origin.y - ((b[i]["f"] as! CGRect).size.height/2) > (b[i+1]["f"] as! CGRect).origin.y)
                {
                    b1.append(b[i])
                    b1 = b1.sorted(by: { (g, h) -> Bool in
                        (g["f"] as! CGRect).origin.x < (h["f"] as! CGRect).origin.x
                    })
                    b2.append(b1)
                    b1 = [[String:Any]]()
                }
                else if i == b.count-1
                {
                    b1.append(b[i])
                    b1 = b1.sorted(by: { (g, h) -> Bool in
                        (g["f"] as! CGRect).origin.x < (h["f"] as! CGRect).origin.x
                    })
                    b2.append(b1)
                }
                else
                {
                    b1.append(b[i])
                }
            }
            var arrFinal:[String] = []
            for i in 0..<b2.count
            {
                let tarr = b2[i] as? [[String:Any]] ?? []
                var tempStr:String = ""
                for j in 0..<tarr.count
                {
                    tempStr = "\(tempStr)\((tarr[j]["e"] as? String  ?? ""))"
                    
                }
                arrFinal.append(tempStr)
            }
            print(arrFinal)
            if WhatRecognize == "number"
            {
                self.checkForNumberAndDate(arrFinal: arrFinal)
            }
            else if WhatRecognize == "selfsign"
            {
                self.lblSign = arrFinal.joined(separator: "")
               
                self.recognizeText(img: self.imgLottery.getCroppedImage(), WhatRecognize: "matchsign")
            }
            else
            {
                self.checkForSign(arrFinal: arrFinal.joined(separator: ""))
            }
            // Recognized text
        }
        
    }
    @IBAction func btnCheckForSignClicked(_ sender: UIButton) {
        timer.invalidate()
        let SecondVC = self.storyboard?.instantiateViewController(withIdentifier: "LotteryInstructionVC") as! LotteryInstructionVC
        SecondVC.delegate = self
        self.navigationController?.pushViewController(SecondVC, animated: true)
    }
    @IBAction func btnSignatureClicked(_ sender: UIButton) {
        let SecondVC = self.storyboard?.instantiateViewController(withIdentifier: "Signature1VC") as! Signature1VC
        SecondVC.delegate = self
       SecondVC.strTitle = "Re-create your signature."
        self.navigationController?.pushViewController(SecondVC, animated: true)
    }
    @objc func timerAction() {
        let l1 = self.view.viewWithTag(1004)?.subviews[0] as! UILabel
        let i1 = Int("\(l1.text!.prefix(1))")!-1
        l1.text = "\(i1)sec..."
        if i1 == 0
        {
            timer.invalidate()
            let SecondVC = self.storyboard?.instantiateViewController(withIdentifier: "LotteryInstructionVC") as! LotteryInstructionVC
            SecondVC.delegate = self
        self.navigationController?.pushViewController(SecondVC, animated: true)
        }
    }
    func checkForSign(arrFinal:String)
    {
        var lblLotto:String = "lssllottoclub"
        lblSign = lblSign.lowercased()
        for i in arrFinal.lowercased() {
            if "\(i)" == "\(lblLotto.prefix(1))"
            {
                lblLotto.remove(at: lblLotto.startIndex)
            }
        }
        for i in arrFinal.lowercased() {
            if "\(i)" == "\(lblSign.prefix(1))"
            {
                lblSign.remove(at: lblSign.startIndex)
            }
        }
        if lblLotto != ""
        {
            lblTitle.text = "Does not match"

            let a = self.view.viewWithTag(1004)
            a!.isHidden = false
            timer.invalidate()
            let l1 = a?.subviews[0] as! UILabel
            l1.text = "7sec..."
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
        }
        else if lblSign != ""
        {
            lblTitle.text = "Choose one of the two"
            
            let a = self.view.viewWithTag(1005)
            a!.isHidden = false
            
        }
        else
        {
            if arrImg.count > 3
            {
                arrImg[3] = imgLottery.getCroppedImage()
            }
            else
            {
                arrImg.append(imgLottery.getCroppedImage())
            }
            mainDict["lotteryImg"] = arrImg
            
            let SecondVC = self.storyboard?.instantiateViewController(withIdentifier: "LotteryPreview2VC") as! LotteryPreview2VC
            SecondVC.mainDict = mainDict
           SecondVC.delegate = self
            self.navigationController?.pushViewController(SecondVC, animated: true)

        }
//        else
//        {
//            self.view.makeToast("Scanning was not properly made. Please scan the signature again.", duration: 2, position:CGPoint(x:self.view.frame.size.width/2,y:self.view.frame.size.height-80))
//        }
    }
    func checkForNumberAndDate(arrFinal:[String])
    {
        var date:String = ""
        var numberArr:[String] = []
        for i in arrFinal {
            var isDate:Bool = false
            if i.length > 9 && !isDate
            {
                for j in 0..<i.length-10 {
                    let dateFormatterGet = DateFormatter()
                    dateFormatterGet.dateFormat = "EMMMddYY"
                    let ss = i.subString(startIndex: j, endIndex: j+9)
                    if let _ = dateFormatterGet.date(from: ss) {
                        for (index, character) in ss.enumerated() {
                            date.append(String(character))
                            
                            if index == 2 || index == 7 {
                                date.append(" ")
                            }
                        }
                        
                        isDate = true
                    }
                }
            }
            let tempStr = i.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
            if tempStr.length == 12 && !isDate
            {
                numberArr.append(tempStr.separate(every:2, with: " "))
            }
        }
        if date == "" || numberArr.count == 0
        {
            self.view.makeToast("Scanning was not properly made. Please scan the  lottery number and result date again.", duration: 2, position:CGPoint(x:self.view.frame.size.width/2,y:self.view.frame.size.height-80))
        }
       
        else
        {
            mainDict["date"] = date
            mainDict["lotteryNumber"] = numberArr
            if arrImg.count > 1
            {
                arrImg[1] = imgLottery.getCroppedImage()
            }
            else
            {
                arrImg.append(imgLottery.getCroppedImage())
            }
             if users.signature == ""
            {
                let SecondVC = self.storyboard?.instantiateViewController(withIdentifier: "Signature1VC") as! Signature1VC
                SecondVC.delegate = self
                SecondVC.strTitle = "Create your signature."
                SecondVC.firstSign = true
                self.navigationController?.pushViewController(SecondVC, animated: true)
            }
            else
             {
            arrTitleIndex += 1
            lblTitle.text = arrTitle[arrTitleIndex]["title"]
            btnScan.setTitle(arrTitle[arrTitleIndex]["btn"], for: .normal)
            let vc = UIImagePickerController()
            vc.sourceType = .camera
            vc.allowsEditing = false
            vc.delegate = self
            present(vc, animated: true)
            }
        }
    }
}
