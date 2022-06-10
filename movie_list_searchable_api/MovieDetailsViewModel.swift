//
//  MovieDetailsViewModel.swift
//  movie_list_searchable_api
//
//  Created by 10683830 on 02/06/22.
//

import SwiftUI

class ViewModel: ObservableObject {
    @Published var movieItem: MovieItem = MovieItem(Title: "", Year: "", Rated: "", Released: "", Runtime: "", Genre: "", Director: "", Actors: "", Plot: "", Awards: "", Poster: "", imdbRating: "", imdbID: "")
    
    func fetch(searchID: String) {
        
        let urlString = "https://www.omdbapi.com/?i=\(searchID)&apikey=ad354109"
        
        guard let url = URL(string: urlString) else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) {
            [weak self]data, _, error in
            guard let data = data, error == nil else {
                return
            }
            do {
                let movies = try JSONDecoder().decode(MovieItem.self, from: data)
                
                DispatchQueue.main.async {
                    self?.movieItem = movies
                }
            } catch {
                print(error)
            }
        }
        task.resume()
        
    }
}

struct MovieDetailsViewModel: View {
    
    var starred: Bool
    var searchID: String
    @StateObject var viewModel = ViewModel()
    @Environment(\.managedObjectContext) private var managedObjectContext
    
    @State var isStarred: Bool = false
    
    var body: some View {
        ScrollView(.vertical) {
            HStack {
                Spacer()
                Button(action: addMovie, label: {
                    starred || isStarred ?
                    Label("", systemImage: "star.circle.fill")
                        .font(.largeTitle)
                        .foregroundColor(.blue)
                    :
                    Label("", systemImage: "star.circle")
                        .font(.largeTitle)
                        .foregroundColor(.gray)
                    
                    
                })
            }
            VStack {
                AsyncImage(url: URL(string: viewModel.movieItem.Poster ?? ""), content: { image in
                    image.resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: 350)
                        .cornerRadius(10)
                }, placeholder: {
                    ProgressView()
                })
                Text("")
                
                VStack {
                    
                    HStack {
                        ForEach(viewModel.movieItem.Genre?.components(separatedBy: ",") ?? [], id: \.self) { genre in
                            Text(genre)
                                .font(.footnote)
                                .bold()
                                .padding(2)
                                .background(.blue)
                                .cornerRadius(5)
                                .foregroundColor(.white)
                        }
                    }
                    
                    HStack {
                        //                                Text(".")
                        Text(Image(systemName: "heart.circle.fill"))
                            .foregroundColor(.red)
                            .font(.title2)
                        Text(viewModel.movieItem.imdbRating ?? "")
                        Text(".")
                        Text(Image(systemName: "clock.fill"))
                            .foregroundColor(.blue)
                            .font(.title2)
                        
                        Text(viewModel.movieItem.Runtime ?? "")
                        Text(".")
                        Text(Image(systemName: "calendar.circle.fill"))
                            .foregroundColor(.green)
                            .font(.title2)
                        
                        Text(viewModel.movieItem.Released ?? "")
                    }
                }
                .padding()
                
                VStack {
                    Text("Story")
                        .font(.title)
                        .bold()
                        .foregroundColor(.blue)
                    
                    Text(viewModel.movieItem.Plot ?? "")
                        .foregroundColor(.black)
                        .italic()
                        .padding(8)
                        .background(.yellow)
                        .cornerRadius(10)
                }
                
                VStack {
                    Text("Awards")
                        .font(.title)
                        .bold()
                        .foregroundColor(.blue)
                    HStack {
                        Text(viewModel.movieItem.Awards ?? "")
                            .bold()
                            .foregroundColor(.green)
                    }
                }
                .padding()
                
                VStack {
                    Text("Cast")
                        .font(.title)
                        .bold()
                        .foregroundColor(.blue)
                    
                    ForEach(viewModel.movieItem.Actors?.components(separatedBy: ",") ?? [], id: \.self) { actor in
                        HStack {
                            Text(actor)
                                .padding(3)
                                .background(.green)
                                .cornerRadius(5)
                                .foregroundColor(.white)
                        }
                    }
                }
            }
            .onAppear {
                viewModel.fetch(searchID: searchID)
                addMovie()
            }
        }
        .navigationTitle(viewModel.movieItem.Title ?? "")
        
    }
    
    
    private func addMovie() {
        
        withAnimation {
            if viewModel.movieItem.Title != "" {
                isStarred.toggle()
                
                let newCompany = MovieData(context: managedObjectContext)
                
                newCompany.title = viewModel.movieItem.Title
                newCompany.name = viewModel.movieItem.Genre
                newCompany.imdbID = viewModel.movieItem.imdbID
                newCompany.poster = viewModel.movieItem.Poster
                
                PersistenceController.shared.saveContext()
            }
        }
    }
}

struct MovieDetailsViewModel_Previews: PreviewProvider {
    static var previews: some View {
        MovieDetailsViewModel(starred: false, searchID: "tt10234724")
            .environment(\.managedObjectContext, PersistenceController.preview.viewContext)
    }
}



// tt0312528
