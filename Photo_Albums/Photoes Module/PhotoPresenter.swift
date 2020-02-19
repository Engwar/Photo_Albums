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
	func getPhotos()
	func countPhotos() -> Int
}

final class PhotoPresenter {
	
	private let userID: Int
	private var albumsByUser = [AlbumsByIDElement]() 
	private var photosInAlbums = [PhotosByIDElement]()
	private var allPhotos = [[PhotosByIDElement]]()
	private var repository: IUsersRepository
	weak var photoVC: PhotosTableViewController?
	private let loadPhotosQueue = DispatchQueue(label: "loadPhotosQueue", qos: .userInteractive, attributes: .concurrent)

	init(userID: Int, repository: IUsersRepository){
		self.userID = userID
		self.repository = repository
	}

	private func loadPhoto() {
		loadPhotosQueue.async { [weak self] in
			guard let self = self else { return }
			DispatchQueue.main.async {
				for album in self.albumsByUser {
					self.repository.getPhotos(by: album.id, completion: { [weak self] result in
						guard let self = self else { return }
						switch result {
						case .success(let photosInAlb):
							self.allPhotos.append(photosInAlb)
							print(photosInAlb.count)
						case .failure(.noData):
							print(Error.self)
						}
					})
			}
				self.photosInAlbums = self.allPhotos.flatMap{$0}
				print(self.photosInAlbums.count)
				self.photoVC?.showPhotos(photos: self.photosInAlbums)
			}
		}
	}
}

extension PhotoPresenter: IPhotoPresenter {
	func getPhotos() {
		loadPhotosQueue.async { [weak self] in
			guard let self = self else { return }
			self.repository.getAlbums(by: self.userID, completion: { [weak self] result in
				guard let self = self else { return }
				DispatchQueue.main.async {
					switch result {
					case .success(let albumsWithPhoto):
						self.albumsByUser = albumsWithPhoto
						print(albumsWithPhoto)
						DispatchQueue.main.async {  
							self.loadPhoto()
						}
					case .failure(.noData):
						print(Error.self)
					}
				}
			})
		}
	}
	func countPhotos() -> Int {
		return photosInAlbums.count
	}
}
