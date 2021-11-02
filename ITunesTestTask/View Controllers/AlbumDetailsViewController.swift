//
//  AlbumDetailsViewController.swift
//  ITunesTestTask
//
//  Created by Кирилл Тарасов on 02.11.2021.
//

import UIKit

class AlbumDetailsViewController: UIViewController {

    var album: Album? = nil
    var image: UIImage!
    private var trackList: [Track] = []
    private var isLoading = false
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var artwork: UIImageView!
    @IBOutlet weak var albumName: UILabel!
    @IBOutlet weak var artistName: UILabel!
    @IBOutlet weak var releaseDate: UILabel!
    @IBOutlet weak var copyrightInfo: UILabel!
    @IBOutlet weak var trackCount: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let album = album {
            NetworkSession.dataTask?.cancel()
            isLoading = true
            albumName.text = album.collectionName
            artistName.text = album.artistName
            copyrightInfo.text = album.copyright
            trackCount.text = String(album.trackCount) + " tracks."
            artwork.image = image
            releaseDate.text = convertDate(album.releaseDate!)
            findSongs()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NetworkSession.dataTask?.cancel()
    }
    
    func parse(data: Data) -> [Track] {
      do {
        let decoder = JSONDecoder()
        let result = try decoder.decode(foundTracks.self, from: data)
        return result.results
      } catch {
        print("JSON Error: \(error)")
        return []
      }
    }
    
    private func findSongs(){
        let urlString = String(format: "https://itunes.apple.com/lookup?id=\(album!.collectionId)&entity=song")
        guard let url = URL(string: urlString) else {
            print("URL Error")
            return
        }
        NetworkSession.shared.performRequest(with: url) {
            result in
            switch result {
            case .success(let data):
                self.trackList = self.parse(data: data)
                DispatchQueue.main.async {
                  self.isLoading = false
                  self.tableView.reloadData()
                }
            case .failure(_):
                return
            }
        }
    }
    
    // MARK: - Converting date&time
    private func convertDate(_ date: String) -> String {
        let dateDecoder = DateFormatter()
        dateDecoder.dateFormat = "yyy'-'MM'-'dd'T'HH':'mm':'ssZZZ"
        guard let tempDate = dateDecoder.date(from: date) else { return ""}
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
        let dateToDisplay = dateFormatter.string(from: tempDate)
        return dateToDisplay
    }
    
    private func converteTime(_ timeInMS: Int) -> String {
        let trackTime = timeInMS / 1000
        let mins = trackTime / 60
        let secs = trackTime % 60
        let time = String(format: "%0.2d:%0.2d", mins, secs)
        return time
    }


}

//MARK: - Table View
extension AlbumDetailsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard !isLoading else { return 1 }
        return trackList.count - 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SongCell") as! TrackCell
        if isLoading {
            cell.songName.text = "\tLoading..."
            cell.trackLength.isHidden = true
        } else {
            let orderNum = indexPath.row+1
            cell.songName.adjustsFontSizeToFitWidth = false
            cell.songName.lineBreakMode = .byTruncatingTail
            cell.songName.text = "\(orderNum).  " + trackList[orderNum].trackName!
            let trackTime = trackList[orderNum].trackTimeMillis ?? 0
            cell.trackLength.text = converteTime(trackTime)
            cell.trackLength.isHidden = false
            }
        return cell

        }
    
}
