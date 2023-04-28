//
//  ViewController.swift
//  lab2
//
//  Created by Julia Avila on 4/28/23.
//

import UIKit

class ViewController: UIViewController {
    
    var data = [Quote]()
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchApiData(URL: "http://api.kanye.rest") { result in
            self.data = result
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    func fetchApiData(URL url:String, completion: @escaping ([Quote]) -> Void) {
        
        let url = URL(string: url)
        let session = URLSession.shared
        let dataTask = session.dataTask(with: url!) { data, response, error in
            if data != nil && error == nil {
                do {
                    let parsingData = try JSONDecoder().decode([Quote].self, from: data!)
                    completion(parsingData)
                } catch {
                    print(error)
                }
            }
        }

        dataTask.resume()
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        cell?.textLabel?.text = data[indexPath.row].quote
        return cell!
    }
}

struct Quote: Decodable {
    let quote: String
}
