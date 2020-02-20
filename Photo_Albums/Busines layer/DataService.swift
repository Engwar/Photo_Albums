//
//  DataService.swift
//  Photo_Albums
//
//  Created by Igor Shelginskiy on 2/17/20.
//  Copyright © 2020 Igor Shelginskiy. All rights reserved.
//

import UIKit

typealias UsersResult = Result<[UsersByIDElement], ServiceError>
typealias AlbumsResult = Result<[AlbumsByIDElement], ServiceError>
typealias PhotosResult = Result<[PhotosByIDElement], ServiceError>

final class DataService {
	private let decoder = JSONDecoder()
	private let session = URLSession.shared
	private var dataTask: URLSessionDataTask?
	
	func loadUsers(completion: @escaping (UsersResult) -> Void) {
		if let url = URL(string: Constants.baseURL + Constants.users){
			dataTask = session.dataTask(with: url) { data, _, error in
				if let data = data {
					do {
						let object = try self.decoder.decode([UsersByIDElement].self, from: data)
						completion(.success(object))
					}
					catch {
						completion(.failure(.noData))
					}
				}
			}
			dataTask?.resume()
		}
	}

	func loadAlbums(_ userID: Int, completion: @escaping(AlbumsResult) -> Void) {
		if let url = URL(string: Constants.baseURL + Constants.users + String(userID) + Constants.slash + Constants.albums){
			dataTask = session.dataTask(with: url) { data, _, error in
				if let data = data {
					do {
						let object = try self.decoder.decode([AlbumsByIDElement].self, from: data)
						completion(.success(object))
					}
					catch {
						completion(.failure(.noData))
					}
				}
			}
			dataTask?.resume()
		}
	}
	func loadPhotos(_ albumID: Int, completion: @escaping(PhotosResult) -> Void) {
		if let url = URL(string: Constants.baseURL + Constants.albums + String(albumID) + Constants.photos){
			dataTask = session.dataTask(with: url) { data, _, error in
				if let data = data {
					do {
						let object = try self.decoder.decode([PhotosByIDElement].self, from: data)
						completion(.success(object))
					}
					catch {
						completion(.failure(.noData))
					}
				}
			}
			dataTask?.resume()
		}
	}
}

