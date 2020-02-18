//
//  UsersTableViewController.swift
//  Photo_Albums
//
//  Created by Igor Shelginskiy on 2/17/20.
//  Copyright © 2020 Igor Shelginskiy. All rights reserved.
//

import UIKit

final class UsersTableViewController: UITableViewController {

	private let presenter: IUserPresenter
	private var users = [UsersByIDElement]()

	init(presenter: IUserPresenter) {
		self.presenter = presenter
		super.init(nibName: nil, bundle: nil)
	}

	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func viewDidLoad() {
        super.viewDidLoad()
		self.title = "Users"
    }

	

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return presenter.usersCount()
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
		users = presenter.showUsers()
		cell.textLabel?.text = users[indexPath.row].name
		cell.accessoryType = .disclosureIndicator
        return cell
    }

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		presenter.showAlbums(of: indexPath.row + 1)
	}
}
