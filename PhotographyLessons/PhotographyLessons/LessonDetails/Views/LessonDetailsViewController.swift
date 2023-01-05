//
//  LessonDetailsViewController.swift
//  PhotographyLessons
//
//  Created by Shimaa on 31/12/2022.
//

import UIKit
import AVKit
import Combine
import ALProgressView

class LessonDetailsViewController: UIViewController {
    var videoContainer = UIView()
    var player: AVPlayer?
    var playerLayer: AVPlayerLayer?
    var playBtn = UIButton()
    let videoPlayerController = AVPlayerViewController()
    var titleLabel = UILabel()
    var descriptionLabel = UILabel()
    var nextBtn = UIButton()
    lazy var circularProgress = ALProgressRing()
    
    var fullScreenOn = false
    var viewModel: LessonDetailsViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpObservables()
        setUpUI()
        setUpVideoState()
        viewModel?.checkIfLessonDownloading()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        AppDelegate.orientationLock = .all
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        windowScene?.requestGeometryUpdate(.iOS(interfaceOrientations: .portrait))
        view.isHidden = false
        refreshViewsData()
        setUpPlayBtnState()
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
        
        viewModel.showProgressViewPassThrough.sink { [weak self] showProgress in
            guard let self = self else { return }
            if showProgress {
                self.setUpCancelButton()
                self.setUpProgressView()
            } else {
                self.setUpDownloadView()
            }
        }.store(in: &viewModel.cancellableSet)
        
        viewModel.progressCountPassThrough.sink { [weak self] progressValue in
            guard let self = self else { return }
            self.circularProgress.setProgress(Float(progressValue), animated: true)
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
        nextBtn.accessibilityIdentifier = "nextLessonButton"
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
    
    func setUpProgressView() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.circularProgress.lineWidth = 1
            self.circularProgress.startColor = .systemBlue
            self.circularProgress.endColor = .systemBlue
            self.circularProgress.translatesAutoresizingMaskIntoConstraints = false
            self.circularProgress.widthAnchor.constraint(equalToConstant: 30).isActive = true
            self.circularProgress.heightAnchor.constraint(equalToConstant: 30).isActive = true
            let progressBarButton = UIBarButtonItem(customView: self.circularProgress)
            self.navigationController?.navigationBar.topItem?.rightBarButtonItems?.append(progressBarButton)
        }
    }
    
    func setUpCancelButton() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            let cancelBtn = UIButton()
            cancelBtn.setTitle("Cancel", for: .normal)
            cancelBtn.setTitleColor(.systemBlue, for: .normal)
            cancelBtn.titleLabel?.font = .systemFont(ofSize: 16)
            cancelBtn.addTarget(self, action: #selector(self.cancelLesson), for: .touchUpInside)
            let cancelBarButton = UIBarButtonItem(customView: cancelBtn)
            self.navigationController?.navigationBar.topItem?.rightBarButtonItems = [cancelBarButton]
            cancelBtn.accessibilityIdentifier = "cancelButton"
        }
    }
    
    func setUpDownloadView() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            guard let self = self else { return }
            let downloadBtn = UIButton()
            downloadBtn.setImage(UIImage(systemName: "icloud.and.arrow.down"), for: .normal)
            downloadBtn.setTitle("Download", for: .normal)
            downloadBtn.setTitleColor(.systemBlue, for: .normal)
            downloadBtn.titleLabel?.font = .systemFont(ofSize: 16)
            downloadBtn.addTarget(self, action: #selector(self.downloadLesson), for: .touchUpInside)
            let downloadBarButton = UIBarButtonItem(customView: downloadBtn)
            self.navigationController?.navigationBar.topItem?.rightBarButtonItems = [downloadBarButton]
            downloadBtn.accessibilityIdentifier = "downloadButton"
        }
    }
    
    @objc func downloadLesson() {
        viewModel?.downloadLesson()
    }
    
    @objc func cancelLesson() {
        viewModel?.cancelLessonDownloading()
    }
}
