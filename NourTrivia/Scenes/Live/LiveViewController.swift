//
//  LiveViewController.swift
//  NourTrivia
//
//  Created by Nour Helmi on 3/7/18.
//  Copyright © 2018 Nour Helmi. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import RxAnimated
import AVFoundation

class LiveViewController: UIViewController {
    var disposeBag = DisposeBag()
    
    @IBOutlet weak var youtubePlayerView: UIView!
    @IBOutlet weak var closeButton: UIButton!
    
    var avplayer: AVPlayer!
    var avplayerLayer: AVPlayerLayer!
    
    var liveViewModel: LiveViewModelType!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // This should come through dependency injection
        liveViewModel = LiveViewModel()
        
        liveViewModel.inputs.viewDidLoad()
        
        self.bindViewModel()
        self.loadVideo()
    }
    
    private func bindViewModel() {
        self.liveViewModel
            .outputs
            .isCloseButtonHiddenDriver
            .drive(self.closeButton.rx.animated.fade(duration: 1).isHidden)
            .disposed(by: self.disposeBag)
        
        self.closeButton
            .rx.tap.asDriver()
            .drive(onNext: { [weak self] _ in
                self?.liveViewModel.inputs.closeButtonTapped()
                self?.dismiss(animated: true, completion: nil)
            })
            .disposed(by: self.disposeBag)
    }
    
    private func loadVideo() {
        
        let url = URL(string: "http://live.hkstv.hk.lxdns.com/live/hks/playlist.m3u8")!
        let playerItem = AVPlayerItem(url: url)
        
        self.avplayer = AVPlayer(playerItem: playerItem)
        
        self.avplayerLayer = AVPlayerLayer(player: self.avplayer)
        
        self.avplayer.replaceCurrentItem(with: playerItem)
        
        self.avplayer.play()
        self.avplayer.isMuted = true
        self.youtubePlayerView
            .layer.insertSublayer(self.avplayerLayer, at: 0)
        
        
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.avplayerLayer.frame = self.youtubePlayerView.bounds
    }
}
