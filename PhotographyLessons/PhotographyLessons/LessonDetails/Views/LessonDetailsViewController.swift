//
//  LessonDetailsViewController.swift
//  PhotographyLessons
//
//  Created by Shimaa on 31/12/2022.
//

import UIKit
import AVKit
import Combine

class LessonDetailsViewController: UIViewController {
    var videoContainer = UIView()
    var player: AVPlayer?
    var playerLayer: AVPlayerLayer?
    var playBtn = UIButton()
    let videoPlayerController = AVPlayerViewController()
    var titleLabel = UILabel()
    var descriptionLabel = UILabel()
    var nextBtn = UIButton()
    
    var fullScreenOn = false
    var viewModel: LessonDetailsViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        AppDelegate.orientationLock = .all
        setUpObservables()
        setUpUI()
        setUpVideoState()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        refreshViewsData()
        setUpPlayBtnState()
        UIDevice.current.setValue(UIInterfaceOrientation.portrait, forKey: "orientation")
        self.navigationController?.setNeedsUpdateOfSupportedInterfaceOrientations()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if !fullScreenOn {
            AppDelegate.orientationLock = .portrait
            player?.pause()
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        if UIDevice.current.orientation.isLandscape {
            setUpFullScreenVideo()
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
                self?.videoPlayerController.dismiss(animated: true)
                self?.fullScreenOn = false
            }
            
        }
    }
    
    func setUpObservables() {
        guard let viewModel = viewModel else { return }
        viewModel.resetScreenPassThrough.sink { [weak self] in
            guard let self = self else { return }
            self.setUpVideoState()
            self.refreshViewsData()
        }.store(in: &viewModel.cancellableSet)
    }
    
    func setUpUI() {
        setUpVideoView()
        setUpPlayer()
        setUpPlayBtn()
        setUpTitleLabel()
        setUpDescriptionLbl()
        setUpNextBtn()
    }

    func setUpVideoView() {
        view.addSubview(videoContainer)
        videoContainer.translatesAutoresizingMaskIntoConstraints = false
        videoContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        videoContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        videoContainer.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.3).isActive = true
        videoContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        videoContainer.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showPauseBtn)))
    }
    
    func setUpPlayBtn() {
        view.addSubview(playBtn)
        playBtn.translatesAutoresizingMaskIntoConstraints = false
        playBtn.heightAnchor.constraint(equalToConstant: 50).isActive = true
        playBtn.widthAnchor.constraint(equalToConstant: 50).isActive = true
        playBtn.centerXAnchor.constraint(equalTo: videoContainer.centerXAnchor).isActive = true
        playBtn.centerYAnchor.constraint(equalTo: videoContainer.centerYAnchor).isActive = true
        playBtn.addTarget(self, action: #selector(playPauseVideo), for: .touchUpInside)
        playBtn.tintColor = .white
    }
    
    func setUpTitleLabel() {
        view.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15).isActive = true
        titleLabel.topAnchor.constraint(equalTo: videoContainer.bottomAnchor, constant: 20).isActive = true
        setUpTitleStyle()
    }

    func setUpTitleStyle() {
        titleLabel.font = .boldSystemFont(ofSize: 20)
        titleLabel.textColor = .white
        titleLabel.numberOfLines = 0
    }
    
    func setUpDescriptionLbl() {
        view.addSubview(descriptionLabel)
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor).isActive = true
        descriptionLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor).isActive = true
        descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10).isActive = true
        setUpDescStyle()
    }
    
    func setUpDescStyle() {
        descriptionLabel.font = .systemFont(ofSize: 16)
        descriptionLabel.textColor = .white
        descriptionLabel.numberOfLines = 0
    }
    
    func setUpNextBtn() {
        view.addSubview(nextBtn)
        nextBtn.translatesAutoresizingMaskIntoConstraints = false
        nextBtn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        nextBtn.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 15).isActive = true
        nextBtn.bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor, constant: -10).isActive = true
        setUpNextBtnStyle()
        nextBtn.addTarget(self, action: #selector(nextBtnPressed), for: .touchUpInside)
    }
    
    func setUpNextBtnStyle() {
        nextBtn.setTitle("Next Lesson  ", for: .normal)
        nextBtn.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        nextBtn.semanticContentAttribute = .forceRightToLeft
        nextBtn.tintColor = .systemBlue
        nextBtn.setTitleColor(.systemBlue, for: .normal)
    }
    
    func refreshViewsData() {
        setUpVideoLayer()
        titleLabel.text = viewModel?.getLessonTitle()
        descriptionLabel.text = viewModel?.getLessonDesc()
        nextBtn.isHidden = viewModel?.isLastLesson() ?? false
    }
    
    @objc func nextBtnPressed() {
        viewModel?.showNextLessonPassThrough.send(())
    }
}
