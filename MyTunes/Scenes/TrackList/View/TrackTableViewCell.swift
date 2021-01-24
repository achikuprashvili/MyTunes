//
//  TrackTableViewCell.swift
//  MyTunes
//
//  Created by Archil on 1/23/21.
//

import UIKit
import RxSwift
import SDWebImage

class TrackTableViewCell: UITableViewCell {
    
    static let cellIdentifier = "TrackTableViewCell"
    private let disposeBag = DisposeBag()
    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var trackName: UILabel!
    @IBOutlet weak var artistName: UILabel!
    @IBOutlet weak var albumName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func config(with model: TrackCellModel) {
        artistName.text = model.artistName
        trackName.text = model.trackName
        albumName.text = model.collectionName
        thumbnail.sd_setImage(with: URL(string: model.artworkUrl100 ?? ""), completed: nil)
        
    }
    
}
