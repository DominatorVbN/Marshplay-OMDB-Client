//
//  SearchViewModel.swift
//  Marshplay OMDB Client
//
//  Created by dominator on 07/01/20.
//  Copyright © 2020 dominator. All rights reserved.
//

import Foundation

class SearchViewModel{
    var page = 1
    var isLast = false
    var searchText = ""
    
    enum SearchResultStatus{
        case loading
        case loaded(results: [Record])
        case error(msg: String)
    }
    
    var status: SearchResultStatus = .loading{
        didSet{
            DispatchQueue.main.async {
                self.didChangeClosure(self.status)
            }
        }
    }
    
    var isProcessing = false
    
    private var didChangeClosure: (_ status: SearchResultStatus)->Void = {_ in}
    
    func search(movie: String? = nil, shouldAppend: Bool = false,_ completion: @escaping ()->Void = {}){
        
        //this ins't the pretiest code i write but i decided to work without any third party
        if let movie = movie{
            searchText = movie
        }
        
        guard let url = URL(string: "http://www.omdbapi.com/?s=\(searchText.trimmingCharacters(in: .whitespaces).split(separator: " ").joined())&page=\(page)&apikey=eeefc96f")else{
            fatalError("Invalid url")
        }
        
        switch status {
        case .error,.loading:
            status = .loading
            Alert.shared.showLoader()
        default:
            break
        }
        
        let request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 5)
        
        isProcessing = true
        let dataTask = URLSession.shared.dataTask(with: request) {  (data, response, error) in
            self.isProcessing = false
            Alert.shared.hideLoader()
            completion()
            if let error = error{
                self.status = .error(msg: "Something went wrong pull down to retry!")
                debugPrint("SearchViewModel | search(movie: \(self.searchText) | Error : \(error)")
            }
            if let data = data{
                do{ 
                    let searchResponse = try JSONDecoder().decode(SearchResponse.self, from: data)
                    if searchResponse.search.count > 0{
                        // i assumed that limit of api per page in 10 records it may be wrong!
                        self.isLast = searchResponse.search.count < 10
                        
                        if shouldAppend{
                            switch self.status {
                            case .loaded(let results):
                                self.status = .loaded(results: searchResponse.search + results)
                            default:
                                self.status = .loaded(results: searchResponse.search)
                            }
                        }else{
                            self.status = .loaded(results: searchResponse.search)
                        }
                    }else{
                        self.status = .error(msg: "No movies found matching \(self.searchText)!")
                    }
                }catch{
                    do{
                        let error = try JSONDecoder().decode(ErrorResponse.self, from: data)
                        self.status = .error(msg: error.error)
                    }catch{
                        self.status = .error(msg: "Something went wrong pull down to retry!")
                        debugPrint("SearchViewModel | search(movie: \(self.searchText) | Error : \(error)")
                        debugPrint("SearchViewModel | search(movie: \(self.searchText) | Data : \(String(describing: String(data: data, encoding: .utf8)))")
                    }
                    debugPrint("SearchViewModel | search(movie: \(self.searchText) | Error : \(error)")
                    debugPrint("SearchViewModel | search(movie: \(self.searchText) | Data : \(String(describing: String(data: data, encoding: .utf8)))")
                }
            }
        }
        dataTask.resume()
    }
    
    func didChangeStatus(_ action: @escaping (_ status: SearchResultStatus)->Void){
        self.didChangeClosure = action
    }
    
    func refresh(text: String?){
        if let movie = text{
            searchText = movie
        }
        page = 1
        search()
    }
    
    func getNextPage(_ completion: @escaping ()->Void){
        page += 1
        search(shouldAppend: true, completion)
    }
    
}
