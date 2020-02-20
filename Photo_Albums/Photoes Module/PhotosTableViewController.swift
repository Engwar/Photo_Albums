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
	private var imageCache = NSCache<NSString, UIImage>()

	init(presenter: IPhotoPresenter){
		self.presenter = presenter
		super.init(nibName: nil, bundle: nil)
	}

	deinit {
		print("photoController dead")
	}

	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	private func setCell(of index: Int) -> UITableViewCell{
		let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellId) as! PhotoCell
		let photo = photosInAlbums[index]
		cell.set(text: photo.title)
		DispatchQueue.global(qos: .utility).async {
			if let url = URL(string: photo.url){
				if let cachedImage = self.imageCache.object(forKey: url.absoluteString as NSString){
					DispatchQueue.main.async {
						cell.set(photoImage: cachedImage)
					}
				} else {
					let photoData = try? Data(contentsOf: url)
					if let photo = photoData, let image = UIImage(data: photo) {
						DispatchQueue.main.async {
							cell.set(photoImage: image)
							self.imageCache.setObject(image, forKey: url.absoluteString as NSString)
							cell.layoutSubviews()
						}
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
		let cell = setCell(of: indexPath.row)
		cell.layoutSubviews()
		return cell
	}
}

extension PhotosTableViewController: IPhotosView {
	func showPhotos(photos: [PhotosByIDElement]) {
		self.photosInAlbums = photos
		DispatchQueue.main.async {
			self.tableView.reloadData()
		}
	}

}
