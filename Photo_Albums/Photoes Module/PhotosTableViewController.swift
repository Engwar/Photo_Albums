//
//  PhotosTableViewController.swift
//  Photo_Albums
//
//  Created by Igor Shelginskiy on 2/17/20.
//  Copyright © 2020 Igor Shelginskiy. All rights reserved.
//

import UIKit

protocol IPhotosView {
	func showPhotos(photos: [PhotosByIDElement])
}

class PhotosTableViewController: UITableViewController {

	private var photosInAlbums = [PhotosByIDElement]()
	private var presenter: IPhotoPresenter

	init(presenter: IPhotoPresenter){
		self.presenter = presenter
		super.init(nibName: nil, bundle: nil)
	}

	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	private func setCell(of index: Int) -> UITableViewCell{
		guard let cell = UITableView().dequeueReusableCell(withIdentifier: Constants.cellId) as? PhotoCell else { return UITableViewCell() }
		let photo = photosInAlbums[index]
		cell.set(text: photo.title)
		DispatchQueue(label: "loadPhoto", qos: .userInitiated, attributes: .concurrent).async {
			if let url = URL(string: photo.url){
				let photoData = try? Data(contentsOf: url)
				DispatchQueue.main.async {
					if let photo = photoData {
						cell.set(photoImage: UIImage(data: photo))
						cell.layoutSubviews()
					}
				}
			}
		}
		return cell
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		self.title = "Photos"
		tableView.register(PhotoCell.self, forCellReuseIdentifier: Constants.cellId)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return presenter.countPhotos()
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellId) as! PhotoCell
		cell.set(text: photosInAlbums[indexPath.row].title)
		cell.layoutSubviews()
        return cell
    }
}

extension PhotosTableViewController: IPhotosView {
	func showPhotos(photos: [PhotosByIDElement]) {
		self.photosInAlbums = photos
		self.tableView.reloadData()
	}

}
