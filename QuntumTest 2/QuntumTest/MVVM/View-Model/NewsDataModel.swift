//
//  NewsDataModel.swift
//  QuntumTest
//
//  Created by Rajeshwari Sharma on 29/11/23.
//

import Foundation
import Alamofire


class NewsDataModel:Decodable{

    var headNewsModel:NewsModel?
    
    
func NewsGetApi( completion: @escaping (Result<NewsModel, Error>) -> Void) {
            // URL of the XML data source
    
    let strurl="https://newsapi.org/v2/top-headlines?country=us&category=business&apiKey=3846db1af2974b6892f7f0bdc55321c3"
    print("strurl",strurl)
            guard let url = URL(string: strurl) else {
                print("Invalid URL")
                return
            }
            
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                    return
                }
                
                if let data = data {
                    // Parse the XML data and print it to the console
                    
                   
                                do {
                                    self.headNewsModel = try JSONDecoder().decode(NewsModel.self, from: data)
                                    print(self.headNewsModel!,"headNewsModel")
                                    completion(.success(self.headNewsModel!))
                                //    self.impNewsDataModel = jsonData // Assign the array of NotesDataModel
                               
                                    // Assign the parsed model to your property
                                    
                                } catch {
                                    print("Error decoding XML: \(error)")
                                    completion(.failure(error) )
                                }
                            }
                    
                }
            
            
   task.resume()
        }







}



