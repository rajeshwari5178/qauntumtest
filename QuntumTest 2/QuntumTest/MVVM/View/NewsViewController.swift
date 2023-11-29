//
//  NewsViewController.swift
//  QuntumTest
//
//  Created by Rajeshwari Sharma on 29/11/23.
//



import UIKit
import Kingfisher

class NewsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var mtableview: UITableView!
   
    let reachability = try! Reachability()
    
    var headlineViewModel=NewsDataModel()
   
 
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Helllloooooooooo")
        CallingApi()
    //    OrangeView.backgroundColor = UIColor(hex: 0xfd7e14)
        mtableview.delegate=self
        mtableview.dataSource=self
        mtableview.register(UINib(nibName: "NewsCell", bundle: Bundle.main), forCellReuseIdentifier: "NewsCell")
        mtableview.register(UINib(nibName: "HeaderTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "HeaderTableViewCell")
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        swipeRight.direction = .right
        view.addGestureRecognizer(swipeRight)
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.main.async { [self] in
            NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged(note:)), name: .reachabilityChanged, object: reachability)
                do{
                    try self.reachability.startNotifier()
                }catch{
                  print("could not start reachability notifier")
                }
        }
    }
    @objc func reachabilityChanged(note: Notification) {

      let reachability = note.object as! Reachability

      switch reachability.connection {
      case .wifi:
          print("Reachable via WiFi")
      case .cellular:
          print("Reachable via Cellular")
      case .none:
        print("Network not reachable")
          loadDataFromLocal()
          
          
          
          
          
          
      default:
          break
      }
    }
    
  deinit{
        reachability.stopNotifier()
        NotificationCenter.default.removeObserver(self, name: .reachabilityChanged, object: reachability)
    }
    @objc func handleSwipe(_ gesture: UISwipeGestureRecognizer) {
        if gesture.direction == .right {
            print("Swipee")
          
         
            self.navigationController?.popViewController(animated: true)
           
        }
    }

    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
switch section {
    case 0:
        return 1
    case 1:
    return headlineViewModel.headNewsModel?.articles?.count ?? 0
    
    default:
        break
    }
    return 0
    }
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        switch section {
        case 0:
            let section = indexPath.section
            
           
                let cell = tableView.dequeueReusableCell(withIdentifier: "HeaderTableViewCell") as! HeaderTableViewCell
            return cell
        case 1:
            
            let section = indexPath.section
            
           
                let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCell") as! NewsCell
    //            \(comissionerViewModel.comissionerDataModel?.dtVal?[indexPath.row].sTD_Code ?? "")"
            
                cell.nsamelbl.text = "\(headlineViewModel.headNewsModel?.articles![indexPath.row].source?.name ?? "")"
                cell.headlinelbl.text = "\(headlineViewModel.headNewsModel?.articles?[indexPath.row].title ?? "")"
            
            
            let originalDateString = "\(headlineViewModel.headNewsModel?.articles?[indexPath.row].publishedAt ?? "")"

            let isoDateFormatter = ISO8601DateFormatter()
            if let date = isoDateFormatter.date(from: originalDateString) {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                
                let extractedDate = dateFormatter.string(from: date)
                cell.date.text  = extractedDate
                print(extractedDate)
            } else {
                print("Invalid date format")
            }
            
            
    //
                if let imageUrlString = headlineViewModel.headNewsModel?.articles?[indexPath.row].urlToImage, !imageUrlString.isEmpty {
                    // Convert the URL string to a URL object
                    if let imageUrl = URL(string: imageUrlString) {
                        // Use Kingfisher to load and cache the image
                        cell.img.kf.setImage(with: imageUrl)
                    } else {
                        // Handle invalid URL
                        cell.img.image=UIImage(named: "ImageBack")
                        print("Invalid URL")
                    }
                } else {
                    cell.img.image=UIImage(named: "ImageBack")
                    print("Image URL not available or invalid in the model")
                }

                   
                
                return cell
       
        default:
            break
        }
        
      
      
     
        
        return UITableViewCell()
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let section = indexPath.section
        switch section {
        case 0:
            return 80
        case 1:
            
            return 280
            
       
        default:
            break
        }
        
        return 0
    }
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("hgg")
        
        let section = indexPath.section
        switch section {
        case 0:
            print("firstcell")
        case 1:
            
            guard let selectedArticle = headlineViewModel.headNewsModel?.articles?[indexPath.row] else {
                        return
                    }

                    let detailViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NewsDetailsViewController") as! NewsDetailsViewController
            detailViewController.articles=headlineViewModel.headNewsModel?.articles?[indexPath.row].description ?? ""
            detailViewController.titles=headlineViewModel.headNewsModel?.articles?[indexPath.row].title ?? ""
            detailViewController.authorss=headlineViewModel.headNewsModel?.articles?[indexPath.row].author ?? ""
            let originalDateString = headlineViewModel.headNewsModel?.articles?[indexPath.row].publishedAt ?? ""

            let isoDateFormatter = ISO8601DateFormatter()
            if let date = isoDateFormatter.date(from: originalDateString) {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
    
                let extractedDate = dateFormatter.string(from: date)
                detailViewController.dates = extractedDate
                print(extractedDate)
            } else {
                print("Invalid date format")
            }
    
    //
            
            
            
    //
            detailViewController.images=headlineViewModel.headNewsModel?.articles?[indexPath.row].urlToImage ?? ""
            detailViewController.modalPresentationStyle = .fullScreen
                 present(detailViewController, animated: true)
            
       
        default:
            break
        }
        
        
        
        
    }
    func CallingApi() {
           if reachability.connection != .none {
               // Network is available
               print("Calling API")
               headlineViewModel.NewsGetApi { [weak self] result in
                   switch result {
                   case .success(let data):
                       self?.headlineViewModel.headNewsModel = data
                       print(data)
                       self?.saveDataLocally() // Save data to local storage
                       DispatchQueue.main.async {
                           self?.mtableview.reloadData()
                       }
                   case .failure(let error):
                       print("Error fetching data: \(error)")
                   }
               }
           } else {
               // Network is not available, load data from local storage
               print("Loading data from local storage")
               loadDataFromLocal()
           }
       }

       func saveDataLocally() {
           // Save data to local storage (e.g., UserDefaults)
           let encoder = JSONEncoder()
           if let encodedData = try? encoder.encode(headlineViewModel.headNewsModel) {
               UserDefaults.standard.set(encodedData, forKey: "savedNewsData")
           }
       }

       func loadDataFromLocal() {
           // Load data from local storage (e.g., UserDefaults)
           if let savedData = UserDefaults.standard.data(forKey: "savedNewsData") {
               let decoder = JSONDecoder()
               if let decodedData = try? decoder.decode(NewsModel.self, from: savedData) {
                   headlineViewModel.headNewsModel = decodedData
                   mtableview.reloadData()
               }
           }
       }
       
}




