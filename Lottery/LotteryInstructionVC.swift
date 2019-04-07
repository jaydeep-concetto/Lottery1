//
//  LotteryInstructionVC.swift
//  Lottery
//
//  Created by Jaydeep Vachhani on 07/04/19.
//  Copyright © 2019 Vachhani Jaydeep. All rights reserved.
//

import UIKit
protocol LotteryInstructionVCDelegate {
    func setData(arrTitleIndexs:Int)
    func back()

}
class LotteryInstructionVC: UIViewController {
    var delegate: LotteryInstructionVCDelegate! = nil
    var fromSign:Bool = false
    var firstSign:Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func btnCancelClick(_ sender: Any) {
        delegate.back()
        
    }
    @IBAction func btnNextClick(_ sender: Any) {
       if fromSign
       {
        delegate.setData(arrTitleIndexs: firstSign ? 1 : 2)
        self.navigationController?.popViewControllers(viewsToPop: 2)
        }
        else
       {
        delegate.setData(arrTitleIndexs: 1)
 self.navigationController?.popViewController(animated: true)
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
