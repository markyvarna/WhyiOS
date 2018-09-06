//
//  PostController.swift
//  WhyiOS
//
//  Created by Markus Varner on 9/6/18.
//  Copyright © 2018 Markus Varner. All rights reserved.
//
//https://whydidyouchooseios.firebaseio.com/

import Foundation

class PostController {
    
    static let shared = PostController()
    //this makes it so there can only be one shared instance of this class
    private init() {}
    
    
     //MARK: - Properties
    
    private let baseURL = URL(string: "https://whydidyouchooseios.firebaseio.com/")
    var posts: [Post] = []
    
    
     //MARK: - Put Post - Create
    
    //1) know what we are completing with
    //2)URLSession - Reverse Engineer
    //3) Build URL
    //4) Handle Data
    
    func putPost(reason: String, name: String, cohort: String, completion: @escaping (Bool) -> Void) {
        
        guard let url = baseURL else {
            fatalError("🤬Bad baseUrl🤬")
        }
        
        //Post Obj
        let post = Post(name: name, cohort: cohort, reason: reason)
        
        //Built URL
        let builtURL = url.appendingPathComponent("reasons").appendingPathComponent(post.uuid.uuidString).appendingPathExtension("json")
        
        //Request
        var request = URLRequest(url: builtURL)
        //define request protocol
        request.httpMethod = "PUT"
        //the body of the requests data must be jsonData, this is found in our post model
        request.httpBody = post.jsonData
        
        //URLSession
        //request - you need to define the http protocol (get, put, post, patch are the protocol options)
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            
            if let error = error {
                print("Error with datatask \(error.localizedDescription)")
                completion(false); return
            }
            
            //Unwrap Data
            guard let data = data else {completion(false); return}
            
            //Response
            //if it works handle response
            let response = String(data: data, encoding: .utf8)
            //this prints a human readable data
            print(response ?? "No response")
            self.posts.append(post)
            completion(true)
            
        }.resume()
        
    }
    
    
     //MARK: - Fetch Post
    
    func fetchPost(completion: @escaping (_ success: Bool) -> Void) {
        
        guard let url = baseURL else {fatalError("Error with Fetch, BAD URL")}
        let requestURL = url.appendingPathComponent("reasons").appendingPathExtension("json")
        
        
        //this data task has "GET" http  protocol built withing it
        URLSession.shared.dataTask(with: requestURL) { (data, _, error) in
            if let error = error {
                print("Error fetching \(error) \(error.localizedDescription)")
                completion(false);return
            }
            
            guard let data = data else {completion(false); return}
            do{
                
                //this is very similar to JSONDecoder
                guard  let postDictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String : [String: String]] else {
                    print("Cannot Deserialize or Decode")
                    completion(false); return
                    
                }
                
                let post = postDictionary.compactMap{Post(dictionary: $0.value, identifier: $0.key)}
                self.posts = post
                completion(true)
                
            } catch {
                print("Error within do catch block of fetching post \(error)")
                completion(false); return
            }
        }.resume()
        
    }
    
    
}
