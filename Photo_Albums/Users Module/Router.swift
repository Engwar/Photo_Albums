//
//  Router.swift
//  Photo_Albums
//
//  Created by Igor Shelginskiy on 2/17/20.
//  Copyright © 2020 Igor Shelginskiy. All rights reserved.
//

import Foundation

protocol IUserRouter {

	func showPhoto(with userId: Int)
}

final class UsersRouter {
	weak var viewController: UsersTableViewController?
	private let factory: ModulesFactory

	init(factory: ModulesFactory) {
		self.factory = factory
	}
}

extension UsersRouter: IUserRouter {
	func showPhoto(with userId: Int) {
		let photoTableViewController = factory.getPhotosModule(with: userId)
		viewController?.navigationController?.pushViewController(photoTableViewController, animated: true)
	}
}
