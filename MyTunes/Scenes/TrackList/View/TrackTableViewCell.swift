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
    private var disposeBag = DisposeBag()
    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var trackName: UILabel!
    @IBOutlet weak var artistName: UILabel!
    @IBOutlet weak var albumName: UILabel!
    @IBOutlet weak var playingIndicator: UIImageView!
    
    private weak var track: TrackCellModel?
    
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
        model.isPlaying.bind { [weak self] value in
            guard let strongself = self else {
                return
            }
            strongself.playingIndicator.image = value ? UIImage(named: "Audio") : nil
        }.disposed(by: disposeBag)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
}
