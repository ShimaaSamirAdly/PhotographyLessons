//
//  LessonDetails+Video.swift
//  PhotographyLessons
//
//  Created by Shimaa on 01/01/2023.
//

import Foundation
import UIKit
import AVFoundation

extension LessonDetailsViewController {
    
    func setUpVideoState() {
        playPauseVideo(forceStop: true)
        setUpPlayer()
    }
    
    func setUpPlayer() {
        guard let videoUrl = URL(string: viewModel?.getLessonVideoUrl() ?? "") else { return }
        player = AVPlayer(url: videoUrl)
    }
    
    func setUpVideoLayer() {
        guard let playerLayer = playerLayer else {
            resetVideoLayer()
            return
        }
        playerLayer.player = player
        videoPlayerController.player = nil
    }
    
    func resetVideoLayer() {
        playerLayer = AVPlayerLayer(player: player)
        guard let playerLayer = playerLayer else { return }
        playerLayer.frame = videoContainer.bounds
        playerLayer.videoGravity = .resizeAspectFill
        videoContainer.layer.addSublayer(playerLayer)
    }
    
    func setUpFullScreenVideo() {
        if fullScreenOn { return }
        self.fullScreenOn = true
        videoPlayerController.player = player
        playerLayer?.player = nil
        self.present(videoPlayerController, animated: true)
    }
    
    @objc func playPauseVideo(forceStop: Bool = false) {
        if player?.timeControlStatus != .paused || forceStop {
            player?.pause()
        } else {
            player?.play()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            self?.setUpPlayBtnState()
        }
    }
    
    func setUpPlayBtnState() {
        if player?.timeControlStatus != .paused {
            playBtn.setImage(UIImage(named:  "ic_pauseVideo")?.withRenderingMode(.alwaysTemplate), for: .normal)
        } else {
            playBtn.setImage(UIImage(named: "ic_playVideo")?.withRenderingMode(.alwaysTemplate), for: .normal)
            
        }
        showHidePlayBtn()
    }
    
    func showHidePlayBtn() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            guard let self = self else { return }
            UIView.transition(with: self.playBtn, duration: 0.4,
                              options: .transitionCrossDissolve,
                              animations: {
                self.playBtn.isHidden = self.player?.timeControlStatus != .paused
            })
        }
    }
    
    @objc func showPauseBtn() {
        self.playBtn.isHidden = false
        showHidePlayBtn()
    }
}
