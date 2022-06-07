//
//  StarredViewModel.swift
//  movie_list_searchable_api
//
//  Created by 10683830 on 06/06/22.
//

import SwiftUI

struct StarredViewModel: View {
    
    @Environment(\.managedObjectContext) private var managedObjectContext
    
    //    @FetchRequest(entity: Company.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Company.name, ascending: true)]) var companies: FetchedResults<Company>
    
    @FetchRequest(sortDescriptors: []) var companies: FetchedResults<Company>
    
    var body: some View {
//        NavigationView {
            VStack {
                HStack {
                    Button ("Add") {
                        let temp = Company(context: managedObjectContext)
                        temp.title = "Iron Man"
                        temp.imdbID = "tt0371746"
                        PersistenceController.shared.saveContext()
                    }
                    Button ("Clear") { companies.forEach(managedObjectContext.delete)}
                    Print("COUNT: \(companies.count)")
                }
                List {
                    ForEach(companies, id: \.self) { company in
                        
                        if company.title != "" {
                            NavigationLink(destination: MovieDetailsViewModel(starred: true, searchID: company.imdbID ?? "")) {
                                HStack {
                                    AsyncImage(url: URL(string: company.poster ?? "https://m.media-amazon.com/images/M/MV5BMTczNTI2ODUwOF5BMl5BanBnXkFtZTcwMTU0NTIzMw@@._V1_SX300.jpg")
                                               , content: { image in
                                        image.resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(maxWidth: 50)
                                    }, placeholder: {
                                        ProgressView()
                                    })

                                    Text(company.title ?? "")
                                    Text(company.imdbID ?? "")
//                                    Print(company.title ?? "")
//                                    Print(company.imdbID ?? "")\
                                    
                                }
                                .padding()
                            }
                        }

                    }
                    .onDelete(perform: deleteMovie)
                }
            }
            .navigationTitle("Starred")
//        }
    }
    
    
    private func deleteMovie(offsets: IndexSet) {
        withAnimation {
            offsets.map { companies[$0]}.forEach(managedObjectContext.delete)
            PersistenceController.shared.saveContext()
        }
    }
}

struct StarredViewModel_Previews: PreviewProvider {
    static var previews: some View {
        StarredViewModel()
            .environment(\.managedObjectContext, PersistenceController.shared.viewContext)
    }
}
