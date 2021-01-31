//
//  MusicPlayerView.swift
//  MyTunes
//
//  Created by Archil on 1/26/21.
//

import UIKit
import RxSwift
import RxCocoa

class MusicPlayerView: UIView {
    
    let didSeekToTime: PublishSubject<Int> = PublishSubject<Int>.init()
    let didRequestToPlay: PublishSubject<TrackCellModel> = PublishSubject<TrackCellModel>.init()
    
    private let disposeBag = DisposeBag()
    private var sliderIsDragging = false
    private weak var track: TrackCellModel?

    private var playButton: UIButton = {
        let button = UIButton()
        button.setTitle("", for: .normal)
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    } ()
    
    private var progressSlider: UISlider = {
        let slider = UISlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.minimumValue = 0
        slider.maximumValue = 1
        return slider
    } ()
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 20)
        return label
    } ()
    
    private var progressTimeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.textColor = .white
        label.font = .systemFont(ofSize: 12)
        return label
    } ()
    
    init() {
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    func config(with model: TrackCellModel) {
        track = model
        titleLabel.text = String(format: "%@ - %@", model.trackName, model.artistName)
        setupObservers(track: model)
    }
    
    private func setupObservers(track: TrackCellModel) {
        track.currentTime
            .bind(to: progressTimeLabel.rx.text)
            .disposed(by: disposeBag)
        
        track.isPlaying
            .bind{ [weak self] value in
                
                self?.playButton.setImage(value ? UIImage(named: "Pause") : UIImage(named: "Play"), for: .normal)
                
            }.disposed(by: disposeBag)

        track.progress
            .subscribe(onNext: {[weak self] value in
                
                guard self?.sliderIsDragging == false else {
                    return
                }
                self?.progressSlider.setValue(Float(value), animated: true)
            }
            ).disposed(by: disposeBag)
    }
    
    private func setupUI() {
        setBlurredBackground()
        addPlayButton()
        addSlider()
        addProgressLabel()
        addNextButton()
        addPreviousButton()
        addTrackNameLabel()
    }
    
    private func addSlider() {
        addSubview(progressSlider)
        progressSlider.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
        progressSlider.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20).isActive = true
        progressSlider.topAnchor.constraint(equalTo: playButton.bottomAnchor, constant: 15).isActive = true
        
        progressSlider
            .rx
            .dragStarted
            .bind {  [weak self] value in
                
                guard let strongself = self else {
                    return
                }
                strongself.sliderIsDragging = true
            
            }.disposed(by: disposeBag)

        progressSlider
            .rx
            .dragFinnished
            .bind { [weak self] value in
                self?.sliderIsDragging = false
                guard let track = self?.track else {
                    return
                }
                let isPlaying: Bool = (try? track.isPlaying.value()) ?? false
                if isPlaying  {
                    self?.didSeekToTime.onNext(Int(Double(value) * 30))
                }
            }.disposed(by: disposeBag)
    }
    
    
    private func addPlayButton() {
        playButton = UIButton()
        playButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(playButton)
        playButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        playButton.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        playButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        playButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        playButton
            .rx
            .tap
            .bind { _ in
                guard let track = self.track else {
                    return
                }
                self.didRequestToPlay.onNext(track)
            }.disposed(by: disposeBag)
    }
    
    private func setBlurredBackground() {
        if !UIAccessibility.isReduceTransparencyEnabled {
            backgroundColor = .clear
            let blurEffect = UIBlurEffect(style: .dark)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            blurEffectView.frame = bounds
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            addSubview(blurEffectView)
        } else {
            backgroundColor = .black
        }
    }
    
    private func addProgressLabel() {
        addSubview(progressTimeLabel)
        progressTimeLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
        progressTimeLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20).isActive = true
        progressTimeLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10).isActive = true
    }
    
    private func addNextButton() {
        //not implemented
    }
    
    private func addPreviousButton() {
        //not implemented
    }
    
    private func addTrackNameLabel() {
        addSubview(titleLabel)
        titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20).isActive = true
        titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 20).isActive = true
    }
}
