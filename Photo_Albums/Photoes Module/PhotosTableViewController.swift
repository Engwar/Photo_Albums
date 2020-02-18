//
//  PhotosTableViewController.swift
//  Photo_Albums
//
//  Created by Igor Shelginskiy on 2/17/20.
//  Copyright © 2020 Igor Shelginskiy. All rights reserved.
//

import UIKit

class PhotosTableViewController: UITableViewController {

	private var albumsByUser = [AlbumsByIDElement]()
	private var photosInAlbum = [PhotosByIDElement]()
	private var allPhotos = [[PhotosByIDElement]]()
	private var presenter: IPhotoPresenter

	init(presenter: IPhotoPresenter){
		self.presenter = presenter
		super.init(nibName: nil, bundle: nil)
	}

	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		self.title = "Photos"
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return presenter.getPhotos().count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       guard let cell = tableView.dequeueReusableCell(withIdentifier: "photoCell", for: indexPath) as? PhotoCell
		else { return UITableViewCell() }
		let photo = presenter.getPhoto(by: indexPath.row)
		cell.set(text: photo.title)
		cell.set(photoImage: presenter.getImage(by: photo))
        return cell
    }
}
