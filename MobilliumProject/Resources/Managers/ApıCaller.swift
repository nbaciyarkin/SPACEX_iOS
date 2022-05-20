//
//  ApıCaller.swift
//  MobilliumProject
//
//  Created by Yarkın Gazibaba on 16.05.2022.
//

import Foundation


struct Constants {
    static let API_KEY = "<<TMDB api-key>>"
    static let baseUrl = "https://api.spacexdata.com/v4"
    static let youtubeApıKey = "AIzaSyBT1pWm2eyLQNSTVaVWD51h3pIfHW8GJCQ"
    static let youtubeBaseUrl = "https://youtube.googleapis.com/youtube/v3/search?"
}

struct EndPoints {
    static let launches = "/launches"
}

enum APIError: Error {
    case failedToGetData
}


class ApıCaller {
    
    static let shared = ApıCaller()
    
    var launches: [LaunchesModel] = []
    
        func getAllLaunches(completion: @escaping (Result<[LaunchesModel],Error>) -> Void){
            guard let url = URL(string: "\(Constants.baseUrl+EndPoints.launches)") else {return}
        
            let task = URLSession.shared.dataTask(with: url) { data, _, error in
                guard let data = data, error == nil else {
                    return
                }
               
                do {
                    let results = try JSONDecoder().decode([LaunchesModel].self, from: data)
                    completion(.success(results))
                } catch {
                    completion(.failure(APIError.failedToGetData))
                }
            }
            task.resume()
        }
    
    
    
    func getLaunch(with query: String,completion: @escaping (Result<VideoElement, Error>) -> Void) {
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {return}
        
        guard let url = URL(string: "\(Constants.youtubeBaseUrl)q=\(query)&key=\(Constants.youtubeApıKey)") else {return}
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            do {
                let results = try JSONDecoder().decode(YoutubeSearchResponse.self, from: data)
                completion(.success(results.items[0]))
            } catch {
                completion(.failure(error))
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
    
    
    
}
    
    
    
    
    
    
    
    
    
