//
//  PhotosViewController.swift
//  Day2Lab
//
//  Created by Rhian Chavez on 6/21/17.
//  Copyright © 2017 Rhian Chavez. All rights reserved.
//

import UIKit
import AlamofireImage

class PhotosViewController: UIViewController,UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var posts: [[String: Any]] = []
    let refresh = UIRefreshControl()
    var isMoreDataLoading: Bool = false
    var loadingMoreView: InfiniteScrollActivityView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let frame = CGRect(x: 0, y: tableView.contentSize.height, width: tableView.bounds.size.width, height: InfiniteScrollActivityView.defaultHeight)
        loadingMoreView = InfiniteScrollActivityView(frame: frame)
        loadingMoreView!.isHidden = true
        tableView.addSubview(loadingMoreView!)
        
        var insets = tableView.contentInset
        insets.bottom += InfiniteScrollActivityView.defaultHeight
        tableView.contentInset = insets
        
        refresh.addTarget(self, action: #selector(PhotosViewController.refreshAction(_:)), for: .valueChanged)
        tableView.insertSubview(refresh, at: 0)
        
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        
        // Network request snippet
        loadData()
    }
    
    func refreshAction(_ refreshControl: UIRefreshControl){
        loadData()
    }
    
    func loadData(){
        let url = URL(string: "https://api.tumblr.com/v2/blog/humansofnewyork.tumblr.com/posts/photo?api_key=Q6vHoaVm5L1u2ZAW1fqv3Jw48gFzYVg9P0vH0VHl3GVy6quoGV")!
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        session.configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        let task = session.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print(error.localizedDescription)
            } else if let data = data,
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                //print(dataDictionary)
                // Get the dictionary from the response key
                let responseDictionary = dataDictionary["response"] as! [String: Any]
                // Store the returned array of dictionaries in our posts property
                self.posts = responseDictionary["posts"] as! [[String: Any]]
                //print(self.posts.count)
                // TODO: Reload the table view
                self.tableView.reloadData()
                self.refresh.endRefreshing()
            }
        }
        task.resume()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PhotoCell", for: indexPath) as! PhotoCellTableViewCell
        let post = posts[indexPath.section]
        if let photos = post["photos"] as? [[String: Any]] {
            // photos is NOT nil, we can use it!
            // get the photo url
            // 1.
            let photo = photos[0]
            // 2.
            let originalSize = photo["original_size"] as! [String: Any]
            // 3.
            let urlString = originalSize["url"] as! String
            // 4.
            let url = URL(string: urlString)
            cell.Picture.af_setImage(withURL: url!)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.posts.count
    }
    
    let format = DateFormatter()
    let prettyformat = DateFormatter()
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        headerView.backgroundColor = UIColor(white: 1, alpha: 0.9)
        
        let profileView = UIImageView(frame: CGRect(x: 10, y: 10, width: 30, height: 30))
        profileView.clipsToBounds = true
        profileView.layer.cornerRadius = 15;
        profileView.layer.borderColor = UIColor(white: 0.7, alpha: 0.8).cgColor
        profileView.layer.borderWidth = 1;
        
        // Set the avatar
        profileView.af_setImage(withURL: URL(string: "https://api.tumblr.com/v2/blog/humansofnewyork.tumblr.com/avatar")!)
        headerView.addSubview(profileView)
        
        // Add a UILabel for the date here
        let date = UILabel(frame: CGRect(x: 60, y: 10, width: 290, height: 30))
        // Use the section number to get the right URL
        let post = posts[section]
        let num = post["date"] as! String
        print(num)
        format.dateFormat = "yyyy-MM-dd HH:mm:ssZZZZ"
        
        let finalDate = format.date(from: num)
        prettyformat.dateFormat = "MMM dd, yyyy"
        date.text = prettyformat.string(from: finalDate!)
        //print(date.text)
        date.textColor = .black
        headerView.addSubview(date)
        // let label = ...
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func loadMoreData() {
        loadData()
        self.isMoreDataLoading = false
        self.loadingMoreView!.stopAnimating()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (!isMoreDataLoading){
            let scrollViewContentHeight = tableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
            if(scrollView.contentOffset.y > scrollOffsetThreshold && tableView.isDragging) {
                isMoreDataLoading = true
                let frame = CGRect(x: 0, y: tableView.contentSize.height, width: tableView.bounds.size.width, height: InfiniteScrollActivityView.defaultHeight)
                loadingMoreView?.frame = frame
                loadingMoreView!.startAnimating()
                loadMoreData()
                
                
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as! UITableViewCell
        let index = tableView.indexPath(for: cell)!
        let destination = segue.destination as! PhotoDetailsViewController
        let post = posts[index.section]
        let photos = post["photos"] as! [[String: Any]]
        let photo = photos[0]
        let originalSize = photo["original_size"] as! [String: Any]
        // 3.
        let urlString = originalSize["url"] as! String
        // 4.
        let url = URL(string: urlString)!
        destination.url = url
    }
}
