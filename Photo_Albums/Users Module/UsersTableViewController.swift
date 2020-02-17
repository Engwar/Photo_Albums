//
//  UsersTableViewController.swift
//  Photo_Albums
//
//  Created by Igor Shelginskiy on 2/17/20.
//  Copyright © 2020 Igor Shelginskiy. All rights reserved.
//

import UIKit

final class UsersTableViewController: UITableViewController {

	private var users = [UsersByIDElement]()
	private var repository: IUsersRepository
	private var router: UsersRouter
	private var activityIndicator = UIActivityIndicatorView(style: .large)

	init(repository: IUsersRepository, router: UsersRouter) {
		self.repository = repository
		self.router = router
		super.init(nibName: nil, bundle: nil)
	}

	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func viewDidLoad() {
        super.viewDidLoad()
		self.title = "Users"
		setupUI()
		loadUsers()
    }

	private func loadUsers() {
			self.repository.getUsers { [weak self] result in
				guard let self = self else { return }
				switch result {
				case .success(let users):
					self.users = users
					self.tableView.reloadData()
					self.activityIndicator.stopAnimating()
				case .failure(.noData):
					self.users = []
				case .failure(.noResponse):
					self.users = []
				case .failure(.invalidURL( _)):
					self.users = []
				}
			}
	}

	private func setupUI() {
		activityIndicator.color = .black
		activityIndicator.startAnimating()
		view.addSubview(activityIndicator)
		setConstraints()
	}

	private func setConstraints() {
		activityIndicator.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			activityIndicator.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
			activityIndicator.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
		])
	}

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return users.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
		cell.textLabel?.text = users[indexPath.row].name
		cell.accessoryType = .disclosureIndicator
        return cell
    }

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		router.showPhoto(with: indexPath.row + 1)
	}
}
