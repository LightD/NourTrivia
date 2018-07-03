//
//  LiveViewModel.swift
//  NourTrivia
//
//  Created by Nour Helmi on 3/7/18.
//  Copyright © 2018 Nour Helmi. All rights reserved.
//

import Foundation
import RxSwift
import RxSwiftExt
import RxCocoa
import RxStarscream
import Starscream
import AVFoundation


protocol LiveViewModelInputs {
    func closeButtonTapped()
    func viewDidLoad()
}

protocol LiveViewModelOutputs {
    var isCloseButtonHiddenDriver: Driver<Bool> { get }
}

protocol LiveViewModelType {
    var inputs: LiveViewModelInputs { get }
    var outputs: LiveViewModelOutputs { get }
}

class LiveViewModel: LiveViewModelType, LiveViewModelInputs, LiveViewModelOutputs {
    
    private var disposeBag = DisposeBag()
    private var timerDisposable: Disposable!
    
    private var isCloseButtonHiddenRelay = BehaviorRelay<Bool>(value: true)
    lazy var isCloseButtonHiddenDriver: SharedSequence<DriverSharingStrategy, Bool> = {
        return isCloseButtonHiddenRelay.asDriver()
    }()
    
    private var socket: WebSocket
    private var countdownTimer: Observable<Int>!
    private var avPlayer: AVPlayer!
    
    deinit {
        socket.disconnect()
        avPlayer.pause()
    }
    
    init() {
        socket = WebSocket(url: URL(string: "ws://demos.kaazing.com/echo")!)
        socket.connect()
        let item = AVPlayerItem(url: URL(string: "http://stream.radioreklama.bg:80/radio1.opus")!)
        self.avPlayer = AVPlayer(playerItem: item)
    }
    
    func viewDidLoad() {
        self.bind()
        self.avPlayer.volume = 1.0
        self.avPlayer.play()
    }
    
    private func bind() {
        self.avPlayer.rx.observe(AVPlayerItemStatus.self, "status", options: [.new])
            .subscribe(onNext: { [weak self] status in
                switch status {
                case let .some(stat):
                    switch stat{
                    case .readyToPlay:
                        self?.avPlayer.play()
                    default: break
                    }
                default: break
                }
                debugPrint(status)
            })
            .disposed(by: self.disposeBag)
        
        socket.rx.response
        .filter { (event) -> Bool in
            switch event {
            case .message(let msg):
                return msg == "pop"
            default:
                return false
            }
        }
        .subscribe(onNext: { [weak self] (event) in
            self?.isCloseButtonHiddenRelay.accept(false)
            self?.startCountdownTimer()
        })
        .disposed(by: disposeBag)
    }
    
    private func startCountdownTimer() {
        self.countdownTimer = Observable<Int>.interval(3, scheduler: MainScheduler.instance)
        timerDisposable = countdownTimer.take(1).subscribe(onNext: { [weak self] (_) in
            self?.isCloseButtonHiddenRelay.accept(true)
            self?.timerDisposable = nil
        })
    }
    
    func closeButtonTapped() {
        if timerDisposable != nil {
            timerDisposable.dispose()
            timerDisposable = nil
        }
    }
    
    var inputs: LiveViewModelInputs { return self }
    var outputs: LiveViewModelOutputs { return self }
}