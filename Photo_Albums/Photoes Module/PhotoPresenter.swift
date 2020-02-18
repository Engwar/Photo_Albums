//
//  PhotoPresenter.swift
//  Photo_Albums
//
//  Created by Igor Shelginskiy on 2/18/20.
//  Copyright © 2020 Igor Shelginskiy. All rights reserved.
//

import Foundation
import UIKit

protocol IPhotoPresenter {
	func getPhotos() -> [PhotosByIDElement]
	func photosCount() -> Int
	func getAlbums()
	func getPhoto(by iD: Int) -> PhotosByIDElement
	func getImage(by photo: PhotosByIDElement) -> UIImage
}

final class PhotoPresenter {
	private let userID: Int
	private var photo = UIImage()
	private var albumsByUser = [AlbumsByIDElement]()
	private var photosInAlbums = [PhotosByIDElement]()
	private var allPhotos = [[PhotosByIDElement]]()
	private var repository: IUsersRepository
	weak var photoVC: PhotosTableViewController?

	init(userID: Int, repository: IUsersRepository){
		self.userID = userID
		self.repository = repository
	}

	private func loadAlbums() {
		self.repository.getAlbums(by: userID) { [weak self] result in
			guard let self = self else { return }
			switch result {
				case .success(let albums):
					self.albumsByUser = albums
					self.loadPhoto()
				sleep(2)
					self.photoVC?.tableView.reloadData()
					print(self.photosInAlbums = self.allPhotos.flatMap{$0})
				case .failure(.noData):
					self.albumsByUser = []
				case .failure(.noResponse):
					self.albumsByUser = []
				case .failure(.invalidURL( _)):
					self.albumsByUser = []
			}
		}
	}
	private func loadPhoto() {
		for album in albumsByUser {
			self.repository.getPhotos(by: album.id) { [weak self] result in
				guard let self = self else { return }
				switch result {
					case .success(let photos):
						self.allPhotos.append(photos)
					case .failure(.noData):
						self.albumsByUser = []
					case .failure(.noResponse):
						self.albumsByUser = []
					case .failure(.invalidURL( _)):
						self.albumsByUser = []
				}
			}
		}
	}
}

extension PhotoPresenter: IPhotoPresenter {
	func getImage(by photo: PhotosByIDElement) -> UIImage {
		let imagePath = photo.url
		if let url = URL(string: imagePath), let photoDataImage = try? Data(contentsOf: url){
				if let photo = UIImage(data: photoDataImage) {
					self.photo = photo
				}
			}
		return self.photo
	}

	func getPhoto(by iD: Int) -> PhotosByIDElement {
		return photosInAlbums[iD]
	}

	func getAlbums() {
		loadAlbums()
	}

	func getPhotos() -> [PhotosByIDElement] {
		photosInAlbums
	}

	func photosCount() -> Int {
		photosInAlbums.count
	}
}
