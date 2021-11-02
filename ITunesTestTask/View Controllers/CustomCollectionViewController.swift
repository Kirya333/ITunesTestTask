//
//  CustomCollectionViewController.swift
//  ITunesTestTask
//
//  Created by Кирилл Тарасов on 02.11.2021.
//

import UIKit

class CustomCollectionViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var searchResults = [Album]()
    var spinner = UIActivityIndicatorView(style: .large)
    var dataTask: URLSessionDataTask?
    var downloadTask: URLSessionDownloadTask?
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var searchHistory = [SearchRequest]()
    
    var itemsPerRow = 2
    let insets = UIEdgeInsets(
      top: 20.0,
      left: 20.0,
      bottom: 20.0,
      right: 20.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let customCell = UINib.init(nibName: "CellForAlbum", bundle: nil)
        self.collectionView.register(customCell, forCellWithReuseIdentifier: "CellForAlbum")
        dataTask = NetworkSession.dataTask
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonTapped))
        navigationItem.rightBarButtonItem!.tintColor = .systemRed
    }
        
    override func viewWillAppear(_ animated: Bool) {
        do {
            searchHistory = try context.fetch(SearchRequest.fetchRequest())
        } catch let error as NSError {
        print("could not fetch, error: \(error)")
        }
        collectionView.collectionViewLayout = UICollectionViewFlowLayout.init()
        spinner.center = self.view.center
        spinner.hidesWhenStopped = true
        self.view.addSubview(spinner)
    }
    
    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowAlbumDetails" {
            if let detailsConntroller = segue.destination as? AlbumDetailsViewController,
               let cell = sender as? CellForAlbum,
               let indexPath = collectionView.indexPath(for: cell) {
                let albumToPass = searchResults[indexPath.row]
                detailsConntroller.album = albumToPass
                if let photo = cell.artwork.image {
                    detailsConntroller.image = photo
                }
                dataTask?.cancel()
            }
        }
    }
    
    //MARK: - Networking Methods
    func parse(data: Data) -> [Album] {
      do {
        let decoder = JSONDecoder()
        let result = try decoder.decode(foundAlbums.self, from: data)
        return result.results
      } catch {
        print("JSON Error: \(error)")
        return []
      }
    }
    
    func findAlbums(searchText: String) {
        self.spinner.isHidden = false
        self.spinner.startAnimating()
        
        let encodedText = searchText.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        let urlString = String(format: "https://itunes.apple.com/search?term=%@&entity=album&limit=1000", encodedText)
        guard let url = URL(string: urlString) else {
            print("URL Error")
            return
        }
        
        NetworkSession.shared.performRequest(with: url) {
            [weak self] result in
            switch result {
            case .success(let data):
                if let self = self {
                    self.searchResults = self.parse(data: data)
                    self.searchResults.sort(by: <)
                    DispatchQueue.main.async {
                        self.spinner.stopAnimating()
                        if self.searchResults.isEmpty {
                            let alert = UIAlertController(title: "Nothing found", message: "Try to change your request", preferredStyle: UIAlertController.Style.alert)
                            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                        } else {
                            self.collectionView.reloadData()
                        }
                        self.navigationItem.rightBarButtonItem!.isEnabled = false
                    }
                }

            case .failure(_):
                return
            }
        }
    }
    
    @objc func cancelButtonTapped() {
        NetworkSession.dataTask?.cancel()
        self.downloadTask?.cancel()
        navigationItem.rightBarButtonItem!.isEnabled = false
        spinner.stopAnimating()
    }
    
}

// MARK: UICollectionViewDataSource, UICollectionViewDelegate

extension CustomCollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func configureCell(for collectionViewCell: UICollectionViewCell, by albumData: Album) {
        if let cell = collectionViewCell as? CellForAlbum {
            cell.albumName.text = albumData.collectionName
            cell.artistName.text = albumData.artistName
            cell.artwork.image = UIImage(named: "artworkPlaceholder")
            if let artworkURL = albumData.artworkUrl100,
               let smallURL = URL(string: artworkURL) {
                downloadTask = cell.artwork.loadImage(url: smallURL)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellForAlbum", for: indexPath) as! CellForAlbum
        configureCell(for: cell, by: searchResults[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! CellForAlbum
        performSegue(withIdentifier: "ShowAlbumDetails", sender: cell)
    }
    
    
}

// MARK: Flow Layout
extension CustomCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if self.view.traitCollection.horizontalSizeClass == UIUserInterfaceSizeClass.regular {
            self.itemsPerRow = 4
        }
        let paddingSpace = (insets.left ) * CGFloat(itemsPerRow) + insets.right
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / CGFloat(itemsPerRow)
        return CGSize(width: widthPerItem, height: widthPerItem+43)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return self.insets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20.0
    }

 
}

func < (lhs: Album, rhs: Album) -> Bool {
  return lhs.collectionName.localizedStandardCompare(rhs.collectionName) == .orderedAscending
}
