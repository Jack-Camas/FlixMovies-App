//
//  ViewController.swift
//  ios101-lab5-flix1
//

import UIKit
import Nuke

// TODO: Add table view data source conformance
class ViewController: UIViewController {
	private var movies = [Movie]()
	
    // TODO: Add table view outlet
	lazy var tableview: UITableView = {
		let table = UITableView(frame: .zero, style: .plain)
		table.register(MovieCell.self, forCellReuseIdentifier: MovieCell.id)
		table.delegate = self
		table.dataSource = self
		table.translatesAutoresizingMaskIntoConstraints = false
		return table
	}()

    // TODO: Add property to store fetched movies array


    override func viewDidLoad() {
        super.viewDidLoad()

        // TODO: Assign table view data source
		setupUI()
        fetchMovies()
    }
	
	private func setupUI(){
		view.addSubview(tableview)
		
		NSLayoutConstraint.activate([
			tableview.topAnchor.constraint(equalTo: view.topAnchor),
			tableview.bottomAnchor.constraint(equalTo: view.bottomAnchor),
			tableview.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			tableview.trailingAnchor.constraint(equalTo: view.trailingAnchor),
		])
	}

    // Fetches a list of popular movies from the TMDB API
    private func fetchMovies() {

        // URL for the TMDB Get Popular movies endpoint: https://developers.themoviedb.org/3/movies/get-popular-movies
        let url = URL(string: "https://api.themoviedb.org/3/movie/popular?api_key=b1446bbf3b4c705c6d35e7c67f59c413&language=en-US&page=1")!

        // ---
        // Create the URL Session to execute a network request given the above url in order to fetch our movie data.
        // https://developer.apple.com/documentation/foundation/url_loading_system/fetching_website_data_into_memory
        // ---
        let session = URLSession.shared.dataTask(with: url) { data, response, error in

            // Check for errors
            if let error = error {
                print("🚨 Request failed: \(error.localizedDescription)")
                return
            }

            // Check for server errors
            // Make sure the response is within the `200-299` range (the standard range for a successful response).
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                print("🚨 Server Error: response: \(String(describing: response))")
                return
            }

            // Check for data
            guard let data = data else {
                print("🚨 No data returned from request")
                return
            }

            // The JSONDecoder's decode function can throw an error. To handle any errors we can wrap it in a `do catch` block.
            do {

                // Decode the JSON data into our custom `MovieResponse` model.
                let movieResponse = try JSONDecoder().decode(MovieResponse.self, from: data)

                // Access the array of movies
                let movies = movieResponse.results

                // Run any code that will update UI on the main thread.
                DispatchQueue.main.async { [weak self] in

                    // We have movies! Do something with them!
                    print("✅ SUCCESS!!! Fetched \(movies.count) movies")

                    // Iterate over all movies and print out their details.
                    for movie in movies {
                        print("🍿 MOVIE ------------------")
                        print("Title: \(movie.title)")
                        print("Overview: \(movie.overview)")
                    }

                    // TODO: Store movies in the `movies` property on the view controller
					self?.movies = movies
					self?.tableview.reloadData()
                }
            } catch {
                print("🚨 Error decoding JSON data into Movie Response: \(error.localizedDescription)")
                return
            }
        }

        // Don't forget to run the session!
        session.resume()
    }


}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return movies.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: MovieCell.id, for: indexPath) as! MovieCell
		let movie = movies[indexPath.row]
		cell.configure(with: movie)
		return cell
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 150
	}
}
