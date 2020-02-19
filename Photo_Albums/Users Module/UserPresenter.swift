//
//  UserPresenter.swift
//  Photo_Albums
//
//  Created by Igor Shelginskiy on 2/18/20.
//  Copyright © 2020 Igor Shelginskiy. All rights reserved.
//

import UIKit

protocol IUserPresenter {
	func getUsers()
	func showPhotos(of userID: Int)
}

final class UserPresenter {
	private var repository: IUsersRepository
	private var router: IUserRouter
	weak var userVC: UsersTableViewController?
	var users = [UsersByIDElement]()
	private let loadUsersQueue = DispatchQueue(label: "loadUsersQueue", qos: .userInteractive, attributes: .concurrent)

	init(repository: IUsersRepository, router: IUserRouter){
		self.repository = repository
		self.router = router
	}
}

extension UserPresenter: IUserPresenter {

	func getUsers() {
		loadUsersQueue.async { [weak self] in
			guard let self = self else { return }
 			self.repository.getUsers { [weak self] result in
				guard let self = self else { return }
				DispatchQueue.main.async {
					switch result {
					case .success(let users):
						self.users = users
					case .failure(.noData):
						print(Error.self)
					}
					self.userVC?.show(users: self.users)
					self.userVC?.tableView.reloadData()
				}
			}
		}

	}

	func showPhotos(of userID: Int) {
		router.showPhotos(with: userID)
	}
}
