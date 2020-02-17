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
		let usersTableViewController = UsersTableViewController(repository: repository, router: router)
		router.viewController = usersTableViewController
		return usersTableViewController
	}

	func getPhotosModule(with userID: Int) -> PhotosTableViewController {
		let repository = UsersRepository()
		let photosViewController = PhotosTableViewController(userID: userID, repository: repository)
		return photosViewController
	}
}
