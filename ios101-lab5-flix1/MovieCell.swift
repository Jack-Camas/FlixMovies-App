//
//  MovieCell.swift
//  ios101-lab5-flix1
//
//  Created by Jack Camas on 12/25/23.
//

import UIKit
import Nuke

class MovieCell: UITableViewCell {
	
	static let id = "Cell"
	
	let image: UIImageView = {
		let image = UIImageView()
		image.contentMode = .scaleAspectFill
		image.clipsToBounds = true
		image.translatesAutoresizingMaskIntoConstraints = false
		image.backgroundColor = .red
		return image
	}()
	
	let titleLabel: UILabel = {
		let label = UILabel()
		label.numberOfLines = 2
		label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()
	
	let descriptionLabel: UILabel = {
		let label = UILabel()
		label.numberOfLines = 0
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		setupUI()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	public func configure(with movie: Movie){
		
		titleLabel.text = movie.title
		descriptionLabel.text = movie.overview
		
		guard let imagePath = movie.poster_path else { return }
		if let imageURL = URL(string: "https://image.tmdb.org/t/p/w500" + imagePath) {
			Nuke.loadImage(with: imageURL, into: image)
		}
		
	}
	
	private func setupUI(){
		contentView.addSubview(image)
		contentView.addSubview(titleLabel)
		contentView.addSubview(descriptionLabel)
		
		NSLayoutConstraint.activate([
			//image contraints
			image.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
			image.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
			image.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
			image.widthAnchor.constraint(equalToConstant: 100),
			
			//movie title contraints
			titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
			titleLabel.leadingAnchor.constraint(equalTo: image.trailingAnchor, constant: 10),
			titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
			
			//movie description contraints
			descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
			descriptionLabel.leadingAnchor.constraint(equalTo: image.trailingAnchor, constant: 10),
			descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -10),
			descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
			
		])
	}
	
}
