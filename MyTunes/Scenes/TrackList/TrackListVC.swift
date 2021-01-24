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
    
    @IBOutlet weak var searchBar: UISearchBar!
    let tableView = UITableView()
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupObservers()
    }
    
    func setupUI() {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        setupSearchBar()
        setupTableView()
    }
    
    func setupTableView() {
        tableView.register(UINib(nibName: "TrackTableViewCell", bundle:nil), forCellReuseIdentifier:  TrackTableViewCell.cellIdentifier)
        tableView.separatorColor = .clear
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .white
        tableView.rowHeight = 100
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        viewModel.tracks.bind(to: tableView.rx.items(cellIdentifier: TrackTableViewCell.cellIdentifier)){ tableView, track, cell in
            if let cellToUse = cell as? TrackTableViewCell {
                cellToUse.config(with: track)
                
            }
        }.disposed(by: disposeBag)
        
    }
    
    func setupSearchBar() {
        searchBar.rx.text.orEmpty.debounce(.milliseconds(500), scheduler: MainScheduler.asyncInstance).bind { (artist) in
            print(artist)
            self.viewModel.getTracks(for: artist)
        }.disposed(by: disposeBag)
    }
    
    func setupObservers() {
        viewModel.screenState.observeOn(MainScheduler.asyncInstance).subscribe(onNext: { [weak self] (screenState) in
            guard let strongSelf = self else { return }
            
            switch screenState {
            case .loading:
                print("loading")
            case .empty:
                print("empty")
            case .tracks:
                print("showing tracks")
            case .loadingMore:
                print("loading more")
            }
        }).disposed(by: disposeBag)
    
    }
    
}
