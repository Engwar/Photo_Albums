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
	private var albumsByUser = [AlbumsByIDElement]() //получаем массив альбомов
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
			for album in self.albumsByUser {
				self.repository.getPhotos(by: album.id, completion: { [weak self] result in
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
					self.photosInAlbums = self.allPhotos.flatMap{$0}
				})
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
					case .success(let albums):
						self.albumsByUser = albums
						self.loadPhoto()
					case .failure(.noData):
						self.albumsByUser = []
					case .failure(.noResponse):
						self.albumsByUser = []
					case .failure(.invalidURL( _)):
						self.albumsByUser = []
					}
					self.photoVC?.showPhotos(photos: self.photosInAlbums)
				}
				return
			})
		}
	}
	func countPhotos() -> Int {
		return photosInAlbums.count
	}
}
