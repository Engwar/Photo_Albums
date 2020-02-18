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
	func showAlbums(of userID: Int)
	func usersCount() -> Int
	func showUsers() -> [UsersByIDElement]
}

final class UserPresenter {
	private var repository: IUsersRepository
	private var router: IUserRouter
	weak var userVC: UsersTableViewController?
	var users = [UsersByIDElement]()

	init(repository: IUsersRepository, router: IUserRouter){
		self.repository = repository
		self.router = router
	}
}

extension UserPresenter: IUserPresenter {
	func showUsers() -> [UsersByIDElement] {
		users
	}

	func usersCount() -> Int {
		users.count
	}

	func getUsers() {
			self.repository.getUsers { [weak self] result in
			guard let self = self else { return }
			switch result {
			case .success(let users):
				self.users = users
				self.userVC?.tableView.reloadData()
			case .failure(.noData):
				self.users = []
			case .failure(.noResponse):
				self.users = []
			case .failure(.invalidURL( _)):
				self.users = []
			}
		}

	}

	func showAlbums(of userID: Int) {
		router.showPhoto(with: userID)
	}
}
