//
//  TrackListVC.swift
//  MyTunes
//
//  Created by Archil on 1/21/21.
//

import UIKit
import RxSwift
import RxCocoa


class TrackListVC: UIViewController, MVVMViewController {
    
    var viewModel: TrackListVMProtocol!
    
    private var musicPlayer: MusicPlayerView = MusicPlayerView()
    private let tableView = UITableView()
    private let searchBar = UISearchBar()
    private let disposeBag = DisposeBag()
    private let noResultsPlaceholder = PlaceholderView(type: .noResults)
    private let typeToSearchPlaceholder = PlaceholderView(type: .typeToSearch)
    
    private var activityIndicator: UIActivityIndicatorView = {
        let ai = UIActivityIndicatorView()
        ai.translatesAutoresizingMaskIntoConstraints = false
        return ai
    }()

    
    @IBOutlet weak var contentView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupObservers()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        viewModel.tracks
            .bind(to: tableView.rx.items(cellIdentifier: TrackTableViewCell.cellIdentifier)) { tableView, track, cell in
                if let cellToUse = cell as? TrackTableViewCell {
                    cellToUse.config(with: track)
                }
            }.disposed(by: disposeBag)
        
        tableView
            .rx
            .modelSelected(TrackCellModel.self).bind { (model) in
                self.addMusicPlayerView()
                self.musicPlayer.config(with: model)
            }.disposed(by: disposeBag)
        
        viewModel
            .selectRow
            .subscribe { (indexPath, model) in
                
                self.tableView.selectRow(at: indexPath, animated: true, scrollPosition: .top)
                self.musicPlayer.config(with: model)
            }.disposed(by: disposeBag)
    }
    
    func setupUI() {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        setupSearchBar()
        setupTableView()
    }
    
    func setupTableView() {
        tableView.separatorColor = .clear
        tableView.keyboardDismissMode = .onDrag
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .white
        tableView.rowHeight = 100
        tableView.register(UINib(nibName: "TrackTableViewCell", bundle:nil), forCellReuseIdentifier:  TrackTableViewCell.cellIdentifier)
    }
    
    func setupSearchBar() {
        searchBar.showsSearchResultsButton = false
        searchBar.enablesReturnKeyAutomatically = true
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.placeholder = "Type Artist Here"
        contentView.addSubview(searchBar)
        searchBar.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        searchBar.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        searchBar.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        
        searchBar.rx.searchButtonClicked.subscribe { (_) in
            self.searchBar.endEditing(true)
        }.disposed(by: disposeBag)
        
        searchBar.rx.text.orEmpty.debounce(.milliseconds(500), scheduler: MainScheduler.asyncInstance).bind { (artist) in
            self.viewModel.getTracks(for: artist)
        }.disposed(by: disposeBag)
    }
    
    func setupObservers() {
        viewModel
            .screenState
            .observeOn(MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] (screenState) in
                guard self != nil else { return }
                
                switch screenState {
                case .loading:
                    self?.showActivityIndicator()
                case .empty:
                    let searchText = self?.searchBar.text ?? ""
                    if searchText.isEmpty {
                        self?.showEmptySearchTextPlaceholder()
                    } else {
                        self?.showEmptyPlaceholder()
                    }
                    
                case .tracks:
                    self?.showTableView()
                }
            }).disposed(by: disposeBag)
    }
    
    func addMusicPlayerView() {
        musicPlayer.removeFromSuperview()

        musicPlayer = MusicPlayerView()
        musicPlayer.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(musicPlayer)
        musicPlayer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        musicPlayer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        musicPlayer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        musicPlayer.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        musicPlayer
            .didRequestToPlay
            .bind { (track) in
                self.viewModel.playMusic(model: track)
            }.disposed(by: disposeBag)
        
        musicPlayer.didSeekToTime.subscribe(onNext: { [weak self] value in
            guard let strongself = self else {
                return
            }
            strongself.viewModel.seekTrackTo(time: value)
        }).disposed(by: disposeBag)

    }
    
    func showActivityIndicator() {
        
        tableView.removeFromSuperview()
        noResultsPlaceholder.removeFromSuperview()
        activityIndicator.startAnimating()
        typeToSearchPlaceholder.removeFromSuperview()
        contentView.insertSubview(activityIndicator, at: 0)
        activityIndicator.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        
    }
    
    func showEmptyPlaceholder() {
        typeToSearchPlaceholder.removeFromSuperview()
        tableView.removeFromSuperview()
        contentView.insertSubview(noResultsPlaceholder, at: 0)
        activityIndicator.removeFromSuperview()
        noResultsPlaceholder.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        noResultsPlaceholder.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        noResultsPlaceholder.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        noResultsPlaceholder.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }
    
    func showEmptySearchTextPlaceholder() {
        tableView.removeFromSuperview()
        noResultsPlaceholder.removeFromSuperview()
        activityIndicator.removeFromSuperview()
        contentView.insertSubview(typeToSearchPlaceholder, at: 0)
        typeToSearchPlaceholder.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        typeToSearchPlaceholder.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        typeToSearchPlaceholder.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        typeToSearchPlaceholder.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }
    
    func showTableView() {
        noResultsPlaceholder.removeFromSuperview()
        typeToSearchPlaceholder.removeFromSuperview()
        activityIndicator.removeFromSuperview()
        contentView.insertSubview(tableView, at: 0)
        tableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }
}
