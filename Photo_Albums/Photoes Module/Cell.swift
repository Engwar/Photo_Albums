//
//  Cell.swift
//  Photo_Albums
//
//  Created by Igor Shelginskiy on 2/18/20.
//  Copyright © 2020 Igor Shelginskiy. All rights reserved.
//

import Foundation
import UIKit

final class PhotoCell: UITableViewCell {

	private var titleLabel = UILabel()
	private var photoView = UIImageView()
	private var activityInd = UIActivityIndicatorView(style: .large)
	static let cellId = Constants.cellId

	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		backgroundColor = .clear
		layer.masksToBounds = false
		layer.shadowOpacity = 0.23
		layer.shadowRadius = 4
		layer.shadowOffset = CGSize(width: 0, height: 0)
		layer.shadowColor = CGColor(srgbRed: 0, green: 0, blue: 0, alpha: 1)
		contentView.backgroundColor = .white
		contentView.layer.cornerRadius = 8
		activityInd.startAnimating()
		activityInd.isHidden = false
		configureView()
		setConstraints()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	private func configureView() {
		addSubview(photoView)
		addSubview(titleLabel)
		addSubview(activityInd)
		titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
		titleLabel.textAlignment = .left
		titleLabel.numberOfLines = 0
		//titleLabel.adjustsFontSizeToFitWidth = true
		photoView.contentMode = .scaleAspectFit
	}

	private func setConstraints() {
		photoView.translatesAutoresizingMaskIntoConstraints = false
		titleLabel.translatesAutoresizingMaskIntoConstraints = false
		activityInd.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			photoView.centerXAnchor.constraint(equalTo: centerXAnchor),
			photoView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
			photoView.widthAnchor.constraint(equalToConstant: 400),
			photoView.heightAnchor.constraint(equalTo: photoView.widthAnchor),
			titleLabel.topAnchor.constraint(equalTo: photoView.bottomAnchor),
			titleLabel.leadingAnchor.constraint(equalTo: photoView.leadingAnchor),
			titleLabel.heightAnchor.constraint(equalToConstant: 40),
			titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
			titleLabel.trailingAnchor.constraint(equalTo: photoView.trailingAnchor),
			activityInd.centerXAnchor.constraint(equalTo: photoView.centerXAnchor),
			activityInd.centerYAnchor.constraint(equalTo: photoView.centerYAnchor)
		])
	}

	func set(photoImage: UIImage?) {
		self.photoView.image = photoImage
		activityInd.stopAnimating()
		activityInd.isHidden = true
	}
	func set(text: String?) {
		titleLabel.text = text
	}
}
