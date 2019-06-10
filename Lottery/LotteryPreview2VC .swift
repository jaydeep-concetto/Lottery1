//
//  LotteryPreview1VC.swift
//  Lottery
//
//  Created by Vachhani Jaydeep on 13/02/19.
//  Copyright © 2019 Vachhani Jaydeep. All rights reserved.
//

import UIKit
class LotteryPreviewTwoCell:UITableViewCell {
    @IBOutlet weak var imgLotteryType: UIImageView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var conSVWidth: NSLayoutConstraint!

    
}
class LotteryPreview2VC: BaseViewController,UITableViewDelegate, UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    var delegate: LotteryInstructionVCDelegate! = nil

    @IBOutlet weak var lblTotalNumber: UILabel!
    @IBOutlet weak var clnView: UICollectionView!
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var contblViewHeight: NSLayoutConstraint!
    var arrMainDict:[[String:Any]] = [[:]]
    var arrLotteryNumber:[String] = []
    var arrLotteryImg:[UIImage] = []
    var arrCompanyImg:[String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        for td in arrMainDict {
            arrLotteryNumber += td["lotteryNumber"] as! [String]
            arrLotteryImg.append((td["lotteryImg"] as! [UIImage])[0])
           
            for _ in 0..<arrLotteryNumber.count
            {
                arrCompanyImg.append(td["image"] as! String)
            }
        }
        lblTotalNumber.text = "total : \(arrLotteryNumber.count)"
        contblViewHeight.constant = CGFloat(arrLotteryNumber.count * 70)
        // Do any additional setup after loading the view.
    }
    @IBAction func btnCancelClicked(_ sender: UIButton) {
        delegate.back()
    }
    @IBAction func btnMorePhotoClicked(_ sender: UIButton) {
        delegate.initialView()
         self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnNextClicked(_ sender: UIButton) {
        let SecondVC = self.storyboard?.instantiateViewController(withIdentifier: "LotteryPreview3VC") as! LotteryPreview3VC
       SecondVC.mainDict = arrMainDict[0]
        SecondVC.arrlotteryNumber = arrLotteryNumber
       SecondVC.arrMainDict = arrMainDict
       SecondVC.delegate = delegate
        self.navigationController?.pushViewController(SecondVC, animated: true)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return arrLotteryNumber.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         
            let cell = tableView.dequeueReusableCell(withIdentifier: "LotteryPreviewTwoCell", for: indexPath) as! LotteryPreviewTwoCell
            SVSetValues(SV: cell.stackView, number: arrLotteryNumber[indexPath.row], removeSpace: 111)
            
cell.imgLotteryType.kf.indicatorType = .activity
            cell.imgLotteryType.kf.setImage(with: URL(string: arrCompanyImg[indexPath.row]), placeholder: UIImage(named: ""), options: nil, progressBlock: nil)
            return cell
        }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrLotteryImg.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LotteryPreviewTopTwoCell", for: indexPath) as! LotteryPreviewTopTwoCell
        cell.imageView.image = arrLotteryImg[indexPath.row]
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.size.width/3, height: 90)
    }

}
