//
//  ResultDetailVC.swift
//  Lotery
//
//  Created by Bipin Patel on 2/7/19.
//  Copyright © 2019 Kavi Patel. All rights reserved.
//

import UIKit
class ResultDetailCell: UITableViewCell {

    @IBOutlet weak var stackView: UIStackView!
}
class ResultDetailVC: BaseViewController,UITableViewDataSource, UITableViewDelegate {
    
    var isAnimate:Bool = false
    @IBOutlet var seperator1: UIButton!
    @IBOutlet var seperator2: UIButton!
    
    @IBOutlet var tblView1: UITableView!
    @IBOutlet var tblView2: UITableView!
    @IBOutlet var lblClubno1: UILabel!
    @IBOutlet var svWinnigNo1: UIStackView!

    @IBOutlet var imgLottery1: UIImageView!
    @IBOutlet var lblMyPrize1: UILabel!
    @IBOutlet var svMyNo1: UIStackView!

    @IBOutlet var lblClubPrize1: UILabel!
    @IBOutlet var lblLotteryDate1: UIButton!
    @IBOutlet var lblClubno2: UILabel!
    @IBOutlet var svWinnigNo2: UIStackView!
    @IBOutlet var imgLottery2: UIImageView!
    @IBOutlet var lblMyPrize2: UILabel!
    @IBOutlet var svMyNo2: UIStackView!

    @IBOutlet var lblClubPrize2: UILabel!
    @IBOutlet var lblLotteryDate2: UILabel!
    @IBOutlet var scrlView: UIScrollView!
    var arrMain:[[String:Any]] = [[String:Any]]()
    var arrCurrentDate:[[String:Any]] = [[String:Any]]()
    var arrPastDate:[[String:Any]] = [[String:Any]]()
    var indexArrCurrentDate:Int = 0
    var indexArrPastDate:Int = 0
    var arrCurrentLotteryNo:[[String:Any]] = [[String:Any]]()
var arrPastLotteryNo:[[String:Any]] = [[String:Any]]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getResult()
        seperator1.isHidden = false
        seperator2.isHidden = true
        // Do any additional setup after loading the view.
    }
    func getResult() {
        
        postapi(url: URL_NAME.lottery_result, maindict:["user_id":users.id,"type":"PW"]) { (dict) in
            if dict.count != 0
            {
                self.arrMain = (dict["data"] as? [String:Any] ?? [:])["lottery_type_list"] as? [[String:Any]] ?? []
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                
                self.arrMain = self.arrMain.sorted{[dateFormatter] one, two in
                    return dateFormatter.date(from:one["lottery_result_date"] as! String )! > dateFormatter.date(from: two["lottery_result_date"] as! String )! }
                var td:String = ""
                let dateFormatter1 = DateFormatter()
                
                dateFormatter1.dateFormat = "yyyy-MM-dd"
                for i in 0..<self.arrMain.count
                {
                    if i == 0 || td == dateFormatter1.string(from:dateFormatter.date(from: self.arrMain[i]["lottery_result_date"] as! String)!)
                    {
                        td = dateFormatter1.string(from:dateFormatter.date(from: self.arrMain[i]["lottery_result_date"] as! String)!)
                        var tempDict = self.arrMain[i]
                        tempDict.removeValue(forKey: "club_list")
                        let clubarr = self.arrMain[i]["club_list"] as? [[String:Any]] ?? []
                        for var j in clubarr
                        {
                            j.merge(tempDict) {(_,new) in new}
                            self.arrCurrentDate.append(j)
                        }
                    }
                    else
                    {
                        var tempDict = self.arrMain[i]
                        tempDict.removeValue(forKey: "club_list")
                        let clubarr = self.arrMain[i]["club_list"] as? [[String:Any]] ?? []
                        for var j in clubarr
                        {
                            j.merge(tempDict) {(_,new) in new}
                            self.arrPastDate.append(j)
                        }
                    }
                    
                }
                self.setData()
                self.tblView1.superview?.viewWithTag(10000)?.isHidden = (self.arrCurrentDate.count != 0)
                self.tblView2.superview?.viewWithTag(10000)?.isHidden = (self.arrPastDate.count != 0)
                
            }
        }
    }
    func setData() {
        if indexArrCurrentDate < arrCurrentDate.count
        {
            lblClubno1.text = arrCurrentDate[indexArrCurrentDate]["club_number"] as? String ?? ""
            imgLottery1.kf.indicatorType = .activity
            imgLottery1.kf.setImage(with:  URL(string: arrCurrentDate[indexArrCurrentDate]["lottery_image"] as? String ?? ""))
            lblLotteryDate1.setTitle(convertDateyyyyMMdd(str:arrCurrentDate[indexArrCurrentDate]["lottery_result_date"] as? String ?? ""), for: .normal)
            
            lblClubPrize1.text = formatPoints(s: arrCurrentDate[indexArrCurrentDate]["clubwinamount"] as? String ?? "")
            lblMyPrize1.text = formatPoints(s:arrCurrentDate[indexArrCurrentDate]["userwinamount"] as? String ?? "")
            SVSetValues(SV: svWinnigNo1, number: arrCurrentDate[indexArrCurrentDate]["winner_number"] as? String ?? "", removeSpace: 130)
            
            let ta = arrCurrentDate[indexArrCurrentDate]["user_list"] as? [[String:Any]] ?? []
            svMyNo1.superview?.viewWithTag(10001)?.isHidden = false
            arrCurrentLotteryNo = [[String:Any]]()
            for j in ta
            {
                if (j["id"] as? String ?? "") == users.id
                {
                    SVSetValues(SV: svMyNo1, number: j["lottery_number"] as? String ?? "", removeSpace: 130)
                svMyNo1.superview?.viewWithTag(10001)?.isHidden = true
                }
                else
                {
                    arrCurrentLotteryNo.append(j)
                }
            }
            tblView1.reloadData()
        }
        if indexArrPastDate < arrPastDate.count
        {
            lblClubno2.text = arrPastDate[indexArrPastDate]["club_number"] as? String ?? ""
            imgLottery2.kf.indicatorType = .activity
            imgLottery2.kf.setImage(with:  URL(string: arrPastDate[indexArrPastDate]["lottery_image"] as? String ?? ""))
            lblLotteryDate2.text = convertDateyyyyMMdd(str:arrPastDate[indexArrPastDate]["lottery_result_date"] as? String ?? "")
            lblClubPrize2.text = formatPoints(s:arrPastDate[indexArrPastDate]["clubwinamount"] as? String ?? "")
            lblMyPrize2.text = formatPoints(s:arrPastDate[indexArrPastDate]["userwinamount"] as? String ?? "")
            SVSetValues(SV: svWinnigNo2, number: arrPastDate[indexArrPastDate]["winner_number"] as? String ?? "", removeSpace: 130)
            
            let ta = arrPastDate[indexArrPastDate]["user_list"] as? [[String:Any]] ?? []
           svMyNo2.superview?.viewWithTag(10001)?.isHidden = false
            arrPastLotteryNo = [[String:Any]]()

            for j in ta
            {
                if (j["id"] as? String ?? "") == users.id
                {
                SVSetValues(SV: svMyNo2, number: j["lottery_number"] as? String ?? "", removeSpace: 130)
                svMyNo2.superview?.viewWithTag(10001)?.isHidden = true
                }
                else
                {
                    arrPastLotteryNo.append(j)
                }
            }
            tblView2.reloadData()
        }
        
    }
    override func viewDidAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden=false
//        let l1 = noDataView1(str: Constant_String.No_Result_To_Display,fr: (tblView1.superview?.frame)!)
//        l1.tag = 10000
//        tblView1.superview?.addSubview(l1)
//        let l2 = noDataView1(str: Constant_String.No_Result_To_Display,fr: (tblView2.superview?.frame)!)
//        l2.tag = 10000
//        tblView2.superview?.addSubview(l2)
        let l3 = noDataView1(str: Constant_String.None,fr: (svMyNo1.superview?.frame)!)
        l3.tag = 10001
        svMyNo1.superview?.addSubview(l3)
        let l4 = noDataView1(str: Constant_String.None,fr: (svMyNo2.superview?.frame)!)
        l4.tag = 10001
        svMyNo2.superview?.addSubview(l4)
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == tblView1
        {
            let h = tblView1.frame.size.height
            if tblView1.contentOffset.y >= (tblView1.contentSize.height - h) && (tblView1.contentSize.height - h) > 0
            {
                tblView1.setContentOffset(CGPoint(x: tblView1.contentOffset.x, y: tblView1.contentSize.height - h), animated: false)
            }
            
            if !isAnimate && indexArrCurrentDate < arrCurrentDate.count - 1  && ((tblView1.contentOffset.y >= (tblView1.contentSize.height - h) && (tblView1.contentSize.height - h) > 0) || (tblView1.contentOffset.y > 0 && (tblView1.contentSize.height - h) <= 0))
            {
                self.indexArrCurrentDate += 1
                self.isAnimate = true
                UIView.transition(with: tblView1.superview!, duration: 1.0, options: .transitionCurlUp, animations: {
                    self.tblView1.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
                    self.setData()
                }) { (a) in
                    self.tblView1.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
                    self.isAnimate = false
                }
                
            }
            else if tblView1.contentOffset.y < 0  && indexArrCurrentDate > 0 && !isAnimate
            {
                self.indexArrCurrentDate -= 1
                self.isAnimate = true
                UIView.transition(with: tblView1.superview!, duration: 1.0, options: .transitionCurlDown, animations: {
                    self.tblView1.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
                    self.setData()
                }) { (a) in
                    self.tblView1.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
                    self.isAnimate = false
                }
            }
        }
        if scrollView == tblView2
        {
            let h = tblView2.frame.size.height
            if tblView2.contentOffset.y >= (tblView2.contentSize.height - h) && (tblView2.contentSize.height - h) > 0
            {
                tblView2.setContentOffset(CGPoint(x: tblView2.contentOffset.x, y: tblView2.contentSize.height - h), animated: false)
            }
            
            if !isAnimate && indexArrPastDate < arrPastDate.count - 1  && ((tblView2.contentOffset.y >= (tblView2.contentSize.height - h) && (tblView2.contentSize.height - h) > 0) || (tblView2.contentOffset.y > 0 && (tblView2.contentSize.height - h) <= 0))
            {
                
                self.indexArrPastDate += 1
                self.isAnimate = true
                UIView.transition(with: tblView2.superview!, duration: 1.0, options: .transitionCurlUp, animations: {
                    self.tblView2.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
                    self.setData()
                }) { (a) in
                    self.tblView2.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
                    self.isAnimate = false
                }
                
            }
            else if tblView2.contentOffset.y < 0 && indexArrPastDate > 0 && !isAnimate
            {
                self.indexArrPastDate -= 1
                self.isAnimate = true
                UIView.transition(with: tblView2.superview!, duration: 1.0, options: .transitionCurlDown, animations: {
                    self.tblView2.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
                    self.setData()
                }) { (a) in
                    self.tblView2.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
                    self.isAnimate = false
                }
            }
        }
    }
    @IBAction func btnSegment1Click(_ sender: Any) {
        seperator1.isHidden = false
        seperator2.isHidden = true
        self.scrlView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
    @IBAction func btnSegment2Click(_ sender: Any) {
        seperator1.isHidden = true
        seperator2.isHidden = false
        self.scrlView.setContentOffset(CGPoint(x: UIScreen.main.bounds.width, y: 0), animated: true)
    }
    
    @IBAction func btnCloseClick(_ sender: UIButton){
        let b = self.tabBarController?.viewControllers![0] as! UINavigationController
        b.popToRootViewController(animated: false)
        self.tabBarController?.selectedIndex = 0
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        if tableView == tblView1
        {
            tableView.backgroundView  = (arrCurrentLotteryNo.count == 0) ? noDataView2(str: Constant_String.None,fr: tableView.bounds) : nil
            return (arrCurrentLotteryNo.count == 0) ? 0 : 1
        }
        else
        {
            tableView.backgroundView  = (arrPastLotteryNo.count == 0) ? noDataView2(str: Constant_String.None,fr: tableView.bounds) : nil
            return (arrPastLotteryNo.count == 0) ? 0 : 1
        }
       
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return (tableView == tblView1) ? arrCurrentLotteryNo.count : arrPastLotteryNo.count
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ResultDetailCell", for: indexPath) as! ResultDetailCell
        var j = (tableView == tblView1) ? arrCurrentLotteryNo[indexPath.row] : arrPastLotteryNo[indexPath.row]
        SVSetValues(SV: cell.stackView, number: j["lottery_number"] as? String ?? "", removeSpace: 130)
        return cell
    }
    
    
}
