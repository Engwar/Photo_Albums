//
//  Repository.swift
//  Photo_Albums
//
//  Created by Igor Shelginskiy on 2/17/20.
//  Copyright © 2020 Igor Shelginskiy. All rights reserved.
//

import Foundation

protocol IUsersRepository {
	func getUsers(_ completion: @escaping(UsersResult) -> Void )
	func getAlbums(by userID: Int, completion: @escaping(AlbumsResult) -> Void)
	func getPhotos(by albumID: Int, completion: @escaping(PhotosResult) -> Void )
}

final class UsersRepository {
	private let dataService = DataService()
}

extension UsersRepository: IUsersRepository {
	func getUsers(_ completion: @escaping (UsersResult) -> Void) {
		self.dataService.loadUsers { result in
			switch result {
			case .success(let people):
				completion(.success(people))
			case .failure(let error):
				completion(.failure(.noData))
				print(error)
			}
		}
	}
	
	func getPhotos(by albumID: Int, completion: @escaping (PhotosResult) -> Void) {
		self.dataService.loadPhotos(albumID) { result in
			switch result {
			case .success(let images):
				completion(.success(images))
			case .failure(let error):
				completion(.failure(.noData))
				print(error)
			}
		}
	}
	
	func getAlbums(by userID: Int, completion: @escaping (AlbumsResult) -> Void) {
		self.dataService.loadAlbums(userID) { result in
			switch result {
			case .success(let albums):
				completion(.success(albums))
			case .failure(let error):
				completion(.failure(.noData))
				print(error)
			}
		}
	}
}
