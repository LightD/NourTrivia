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
import youtube_ios_player_helper

class LiveViewController: UIViewController {
    var disposeBag = DisposeBag()
    
    @IBOutlet weak var youtubePlayerView: YTPlayerView!
    @IBOutlet weak var closeButton: UIButton!
    
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
//        let myVideoURL = URL(string: "https://www.youtube.com/watch?v=wQg3bXrVLtg")
        youtubePlayerView.load(withVideoId: "QPDX91iJ_RA")
        youtubePlayerView.playVideo()
        youtubePlayerView.delegate = self
//        youtubePlayerView.loadVideoURL(myVideoURL!)
//        youtubePlayerView.delegate = self
    }
    
}

extension LiveViewController: YTPlayerViewDelegate {
    func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
        debugPrint("ready..")
    }
    
    func playerView(_ playerView: YTPlayerView, didChangeTo state: YTPlayerState) {
        switch state {
        case .unstarted:
            playerView.playVideo()
        case .ended:
            playerView.playVideo()
        default:
            break
        }
    }
}

//extension LiveViewController: YouTubePlayerDelegate {
//    func playerReady(_ videoPlayer: YouTubePlayerView) {
//        videoPlayer.mute()
//        videoPlayer.play()
////        videoPlayer.play()
//    }
//
//    func playerStateChanged(_ videoPlayer: YouTubePlayerView, playerState: YouTubePlayerState) {
//        switch playerState {
//        case .Unstarted:
//            videoPlayer.play()
//        case .Ended:
//            videoPlayer.seekTo(0, seekAhead: false)
//        default: break
//        }
//    }
//}
