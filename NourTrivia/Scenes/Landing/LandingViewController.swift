//
//  LandingViewController.swift
//  NourTrivia
//
//  Created by Nour Helmi on 3/7/18.
//  Copyright © 2018 Nour Helmi. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import Rswift
class LandingViewController: UIViewController {
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func watchButtonTapped(_ sender: Any) {
        let vc = LiveViewController(nib: R.nib.liveViewController)
        self.present(vc, animated: true, completion: nil)
    }
}
