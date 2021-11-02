//
//  CellForAlbum.swift
//  ITunesTestTask
//
//  Created by Кирилл Тарасов on 02.11.2021.
//

import UIKit

class CellForAlbum: UICollectionViewCell {
    
    
    @IBOutlet weak var artwork: UIImageView!
    @IBOutlet weak var albumName: UILabel!
    @IBOutlet weak var artistName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        albumName.adjustsFontSizeToFitWidth = false
        artistName.adjustsFontSizeToFitWidth = false
        albumName.lineBreakMode = .byTruncatingTail
        artistName.lineBreakMode = .byTruncatingTail
        artwork.layer.cornerRadius = 5.0
    }

}

extension UIImageView {
  func loadImage(url: URL) -> URLSessionDownloadTask {
    let session = URLSession.shared
    let downloadTask = session.downloadTask(with: url) {
        [weak self] url, response, error in
      if error == nil,
         let url = url,
         let data = try? Data(contentsOf: url),
         let image = UIImage(data: data) {
        DispatchQueue.main.async {
          if let weakSelf = self {
            weakSelf.image = image
          }
        }
      }
    }
    downloadTask.resume()
    return downloadTask
  }
}
