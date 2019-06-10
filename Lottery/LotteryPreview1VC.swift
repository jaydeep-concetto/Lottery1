//
//  LotteryPreview1VC.swift
//  Lottery
//
//  Created by Vachhani Jaydeep on 13/02/19.
//  Copyright © 2019 Vachhani Jaydeep. All rights reserved.
//

import UIKit
import Firebase
import AVFoundation

class LotteryPreviewOneCell:UITableViewCell {
    
    @IBOutlet weak var lblLtteryName: UILabel!
    @IBOutlet weak var imgLottery: UIImageView!
}
class LotteryPreview1VC: BaseViewController,UITableViewDelegate, UITableViewDataSource,UINavigationControllerDelegate,UIImagePickerControllerDelegate,LotteryInstructionVCDelegate,AVCapturePhotoCaptureDelegate {
    @IBOutlet weak var previewView : UIView!
    var session: AVCaptureSession?
    var stillImageOutput: AVCapturePhotoOutput?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    
    var selectLotteryType:Int = -1
    var selectLotteryType1:Int = -1
    var timer = Timer()
    
    var imgLottery: LyEditImageView!
    @IBOutlet weak var imgLotterySuperView:UIView!
    @IBOutlet weak var viewLotteryType:UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnScan: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    var arrMainDict:[[String:Any]] = [[String:Any]]()

    var mainDict:[String:Any] = [String:Any]()
    let arrTitle:[[String:String]] = [["title":"Fit the entire front ticket on the screen","btn":""],["title":"Move the Box and Fix your numbers and draw date","btn":"Scan"],["title":"Fit the entire back ticket on the screen","btn":""],["title":"Move the Box and Fix that sign","btn":"Scan"]]
    var arrImg:[UIImage] = [UIImage]()
    var lblSign:String = ""
    
    var arrTitleIndex:Int = 0
    var arrLotteryType:[[String:Any]] = [[String:Any]]()
    @IBOutlet weak var tblViewLotteryType: UITableView!
    @IBOutlet weak var conTblHeight: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            setCamera()
        }
        
       
        
    }
    func initialView()
    {
        selectLotteryType = -1
        selectLotteryType1 = -1
       
        
        mainDict = [String:Any]()
        
        arrImg = [UIImage]()
        lblSign = ""
        
        arrTitleIndex = 0
        viewLotteryType.isHidden = false
        self.view.viewWithTag(999)?.isHidden = true
        self.view.viewWithTag(1001)?.isHidden = true
        self.view.viewWithTag(1002)?.isHidden = true
        self.view.viewWithTag(1003)?.isHidden = true
        self.view.backgroundColor = UIColor.clear
        previewView.isHidden = true
    }
    override func viewWillAppear(_ animated: Bool) {
        if selectLotteryType == -1{
            self.view.backgroundColor = UIColor.clear
            
            UIView.animate(withDuration: 0.4, delay: 0.2, options: .curveLinear, animations: {
                self.view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
            }, completion: nil)
        }
        self.tabBarController?.tabBar.isHidden=true
        
        
    }
    func fromFirstSign()
    {
        let a = self.view.viewWithTag(1004)
        a!.isHidden = true
        let a1 = self.view.viewWithTag(1005)
        a1!.isHidden = true
        if users.signature != ""
        {
            
            arrTitleIndex = 2
            setBtn()
            if UIImagePickerController.isSourceTypeAvailable(.camera){
                previewView.isHidden = false
                videoPreviewLayer!.frame = previewView.bounds
                session!.startRunning()
            }
            else{
                let vc = UIImagePickerController()
                vc.sourceType = .photoLibrary
                vc.allowsEditing = false
                vc.delegate = self
                present(vc, animated: true)
            }
        }
    }
    func fromSecondSign()
    {
        let a = self.view.viewWithTag(1004)
        a!.isHidden = true
        let a1 = self.view.viewWithTag(1005)
        a1!.isHidden = true
        
        arrTitleIndex = 3
        setBtn()
        
        
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        picker.dismiss(animated: true)
        NotificationCenter.default.post(name: Notification.Name("peru2"), object: nil)
        self.view.backgroundColor = UIColor.clear
        
        self.dismiss(animated: false, completion: nil)
        //  self.dismiss(animated: false, completion: nil)
    }
    func setData() {
        let a = self.view.viewWithTag(1004)
        a!.isHidden = true
        let a1 = self.view.viewWithTag(1005)
        a1!.isHidden = true
        arrTitleIndex = 2
        setBtn()
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            previewView.isHidden = false
            videoPreviewLayer!.frame = previewView.bounds
            session!.startRunning()
        }
        else{
            let vc = UIImagePickerController()
            vc.sourceType = .photoLibrary
            vc.allowsEditing = false
            vc.delegate = self
            present(vc, animated: true)
        }
    }
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        
        guard let imageData = photo.fileDataRepresentation()
            else { return }
        let image = UIImage(data: imageData)
        selectLotteryType = selectLotteryType1
        
        imgLottery = LyEditImageView(frame:CGRect(x: 0, y: 0, width: imgLotterySuperView.frame.size.width, height: imgLotterySuperView.frame.size.height))
        imgLottery.initWithImage(image: image!)
        
        for i in self.imgLotterySuperView.subviews
        {
            i.removeFromSuperview()
        }
        self.imgLotterySuperView.addSubview(imgLottery)
        switch arrTitleIndex {
        case 0:
            if arrImg.count > 0
            {
                arrImg[0] = image!
            }
            else
            {
                arrImg.append(image!)
            }
        case 2:
            if arrImg.count > 2
            {
                arrImg[2] = image!
            }
            else
            {
                arrImg.append(image!)
            }
        default:
            print("")
        }
        self.session?.stopRunning()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.2) {
            self.previewView.isHidden = true
        }
        arrTitleIndex += 1
        setBtn()
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        guard let image = info[.originalImage] as? UIImage else {
            print("No image found")
            return
        }
        selectLotteryType = selectLotteryType1
        
        imgLottery = LyEditImageView(frame:CGRect(x: 0, y: 0, width: imgLotterySuperView.frame.size.width, height: imgLotterySuperView.frame.size.height))
        imgLottery.initWithImage(image: image)
        
        for i in self.imgLotterySuperView.subviews
        {
            i.removeFromSuperview()
        }
        self.imgLotterySuperView.addSubview(imgLottery)
        switch arrTitleIndex {
        case 0:
            if arrImg.count > 0
            {
                arrImg[0] = image
            }
            else
            {
                arrImg.append(image)
            }
        case 2:
            if arrImg.count > 2
            {
                arrImg[2] = image
            }
            else
            {
                arrImg.append(image)
            }
        default:
            print("")
        }
        arrTitleIndex += 1
        setBtn()
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
    @IBAction func btnCancelClicked(_ sender: UIButton) {
        if sender.titleLabel!.text! == "Cancel"
        {
            NotificationCenter.default.post(name: Notification.Name("peru2"), object: nil)
            self.view.backgroundColor = UIColor.clear
            
            self.dismiss(animated:false, completion: nil)
        }
        else
        {
            arrTitleIndex -= 1
            setBtn()
            if UIImagePickerController.isSourceTypeAvailable(.camera){
                previewView.isHidden = false
                videoPreviewLayer!.frame = previewView.bounds
                session!.startRunning()
            }
            else{
                let vc = UIImagePickerController()
                vc.sourceType = .photoLibrary
                vc.allowsEditing = false
                vc.delegate = self
                present(vc, animated: true)
            }
        }
    }
    @objc func timerAction1() {
        switch arrTitleIndex {
        case 1:
        recognizeText(img: imgLottery.getCroppedImage(), WhatRecognize: "number")
        default:
            let url = URL(string:users.signature)
            if let data = try? Data(contentsOf: url!)
            {
                recognizeText(img: UIImage(data: data)!, WhatRecognize: "selfsign")
            }
        }
    }
    @IBAction func btnScanClicked(_ sender: UIButton) {
        switch arrTitleIndex {
        case 0:
            let settings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])
            stillImageOutput!.capturePhoto(with: settings, delegate: self)
            session!.stopRunning()
            
        case 1:
//            let t = imgLottery.getCroppedImage()
//            imgLottery = LyEditImageView(frame:CGRect(x: 0, y: 0, width: imgLotterySuperView.frame.size.width, height: imgLotterySuperView.frame.size.height))
//            imgLottery.initWithImage(image: t)
//
//            for i in self.imgLotterySuperView.subviews
//            {
//                i.removeFromSuperview()
//            }
//            self.imgLotterySuperView.addSubview(imgLottery)
            imgLottery.startav()
            lblTitle.text = "It will take 2-3 seconds"
            timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(timerAction1), userInfo: nil, repeats: false)
            
            
        case 2:
            let settings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])
            stillImageOutput!.capturePhoto(with: settings, delegate: self)
            session!.stopRunning()
        default:
            imgLottery.startav()
            lblTitle.text = "It will take 2-3 seconds"
            timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(timerAction1), userInfo: nil, repeats: false)
           
            
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
        viewLotteryType.isHidden = true
        self.view.viewWithTag(999)?.isHidden = false
        self.view.viewWithTag(1001)?.isHidden = false
        self.view.viewWithTag(1002)?.isHidden = false
        self.view.viewWithTag(1003)?.isHidden = false
        self.view.backgroundColor = UIColor.white
        arrTitleIndex = 0
        setBtn()
        selectLotteryType1 = indexPath.row
        mainDict = arrLotteryType[selectLotteryType1]
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            previewView.isHidden = false
            videoPreviewLayer!.frame = previewView.bounds
            session!.startRunning()
        }
        else{
            let vc = UIImagePickerController()
            vc.sourceType = .photoLibrary
            vc.allowsEditing = false
            vc.delegate = self
            present(vc, animated: true)
        }
    }
    func recognizeText(img:UIImage,WhatRecognize:String)
    {
        let vision = Vision.vision()
        let textRecognizer = vision.onDeviceTextRecognizer()
        let image = VisionImage(image:img)
        var b:[[String:Any]] = [[String:Any]]()
        textRecognizer.process(image) { result, error in
            guard error == nil, let result = result else {
                self.imgLottery.stopav()
                self.setBtn()
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
            self.setBtn()
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
            self.imgLottery.stopav()
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
        
            timer.invalidate()
            let SecondVC = self.storyboard?.instantiateViewController(withIdentifier: "LotteryInstructionVC") as! LotteryInstructionVC
            SecondVC.delegate = self
            self.navigationController?.pushViewController(SecondVC, animated: true)
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
            self.view.makeToast("Does not match the text of “LSSL lotto club” Please use another lottery ticket", duration: 3, position:CGPoint(x:self.view.frame.size.width/2,y:self.view.frame.size.height-80))
            
            timer.invalidate()
           
            timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(timerAction), userInfo: nil, repeats: false)
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
            arrMainDict.append(mainDict)
            let SecondVC = self.storyboard?.instantiateViewController(withIdentifier: "LotteryPreview2VC") as! LotteryPreview2VC
            SecondVC.arrMainDict = arrMainDict
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
        for var i in arrFinal {
            var isDate:Bool = false
            i = i.replacingOccurrences(of: ",", with: "")
            i = i.replacingOccurrences(of: ".", with: "")
            if i.length > 6 && !isDate
            {
                for j in 0..<i.length-6 {
                    let dateFormatterGet = DateFormatter()
                    dateFormatterGet.dateFormat = "MMMddyy"
                    let ss = i.subString(startIndex: j, endIndex: j+6)
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
            if i.length > 9 && !isDate
            {
                for j in 0..<i.length-9 {
                    let dateFormatterGet = DateFormatter()
                    dateFormatterGet.dateFormat = "MM/dd/yyyy"
                    let ss = i.subString(startIndex: j, endIndex: j+9)
                    if let _ = dateFormatterGet.date(from: ss) {
                        for (_, character) in ss.enumerated() {
                            date.append(String(character))
                            
                        
                        }
                        
                        isDate = true
                    }
                }
            }
            if i.length > 9 && !isDate
            {
                for j in 0..<i.length-9 {
                    let dateFormatterGet = DateFormatter()
                    dateFormatterGet.dateFormat = "yyyy/MM/dd"
                    let ss = i.subString(startIndex: j, endIndex: j+9)
                    if let _ = dateFormatterGet.date(from: ss) {
                        for (_, character) in ss.enumerated() {
                            date.append(String(character))
                            
                            
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
        if  numberArr.count == 0
        {
            self.view.makeToast("Scanning was not properly made. Please scan the  lottery number and result date again.", duration: 3, position:CGPoint(x:self.view.frame.size.width/2,y:self.view.frame.size.height-80))
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
                setBtn()
                if UIImagePickerController.isSourceTypeAvailable(.camera){
                    previewView.isHidden = false
                    videoPreviewLayer!.frame = previewView.bounds
                    session!.startRunning()
                }
                else{
                    let vc = UIImagePickerController()
                    vc.sourceType = .photoLibrary
                    vc.allowsEditing = false
                    vc.delegate = self
                    present(vc, animated: true)
                }
            }
        }
    }
    func setCamera() {
        session = AVCaptureSession()
        session!.sessionPreset = AVCaptureSession.Preset.photo
        let backCamera =  AVCaptureDevice.default(for: AVMediaType.video)
        var error: NSError?
        var input: AVCaptureDeviceInput!
        do {
            input = try AVCaptureDeviceInput(device: backCamera!)
        } catch let error1 as NSError {
            error = error1
            input = nil
            print(error!.localizedDescription)
        }
        if error == nil && session!.canAddInput(input) {
            session!.addInput(input)
            stillImageOutput = AVCapturePhotoOutput()
            //  stillImageOutput?.outputSettings = [AVVideoCodecKey:  AVVideoCodecJPEG]
            if session!.canAddOutput(stillImageOutput!) {
                session!.addOutput(stillImageOutput!)
                videoPreviewLayer = AVCaptureVideoPreviewLayer(session: session!)
                videoPreviewLayer!.videoGravity =    AVLayerVideoGravity.resizeAspectFill
                videoPreviewLayer!.connection?.videoOrientation =   AVCaptureVideoOrientation.portrait
                previewView.layer.addSublayer(videoPreviewLayer!)
                
            }
        }
    }
    func setBtn() {
        lblTitle.text = arrTitle[arrTitleIndex]["title"]
        btnScan.setTitle(arrTitle[arrTitleIndex]["btn"], for: .normal)
        btnScan.setImage(arrTitle[arrTitleIndex]["btn"] == "" ? UIImage(named: "img_camera") : nil, for: .normal)
        btnCancel.setTitle(arrTitle[arrTitleIndex]["btn"] == "" ? "Cancel" : "Re-Shot", for: .normal)
    }
}
