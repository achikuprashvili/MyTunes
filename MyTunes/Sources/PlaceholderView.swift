//
//  PlaceholderView.swift
//  MyTunes
//
//  Created by Archil on 1/31/21.
//

import UIKit

enum PlaceholderViewType {
    case typeToSearch
    case noResults
    
    var title: String {
        switch self {
        case .typeToSearch:
            return "type artist to search"
        case .noResults:
            return "artist wasn't found"
        }
    }
    
    
}

class PlaceholderView: UIView {
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = self.type.title
        label.font = .systemFont(ofSize: 20)
        label.textColor = .black
        return label
    }()
    
    private let type: PlaceholderViewType
    
    init(type: PlaceholderViewType) {
        self.type = type
        
        super.init(frame: .zero)
        
        backgroundColor = .white
        translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(titleLabel)
        titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        titleLabel.text = type.title
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
