//
//  Factory.swift
//  Photo_Albums
//
//  Created by Igor Shelginskiy on 2/17/20.
//  Copyright © 2020 Igor Shelginskiy. All rights reserved.
//

import Foundation

final class ModulesFactory {
	func getUsersModule() -> UsersTableViewController {
		let repository = UsersRepository()
		let router = UsersRouter(factory: self)
		let presenter = UserPresenter(repository: repository, router: router)
		let usersTableViewController = UsersTableViewController(presenter: presenter)
		router.viewController = usersTableViewController
		presenter.getUsers()
		presenter.userVC = usersTableViewController
		return usersTableViewController
	}

	func getPhotosModule(with userID: Int) -> PhotosTableViewController {
		let repository = UsersRepository()
		let presenter = PhotoPresenter(userID: userID, repository: repository)
		let photosViewController = PhotosTableViewController(presenter: presenter)
		presenter.getAlbums()
		return photosViewController
	}
}
