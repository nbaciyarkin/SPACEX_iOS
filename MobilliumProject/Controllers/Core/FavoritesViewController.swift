//
//  FavoritesViewController.swift
//  MobilliumProject
//
//  Created by Yarkın Gazibaba on 19.05.2022.
//

import UIKit


class FavoritesViewController: UIViewController {
    private var favoriteLaunches: [RocketItem] = []
    
    private let favoriteLaunchesTable: UITableView = {
        let table = UITableView()
   
        table.register(LaunchesTableViewCell.self, forCellReuseIdentifier: LaunchesTableViewCell.identifier)
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .blue
        title = "Downloads"
        view.backgroundColor = .systemBackground
        view.addSubview(favoriteLaunchesTable)
        favoriteLaunchesTable.dataSource = self
        favoriteLaunchesTable.delegate = self
        
        fetchLocalStorageForDownload()
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "downloaded"), object: nil, queue: nil) { _ in
            self.fetchLocalStorageForDownload()
        }
        
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        favoriteLaunchesTable.frame = view.bounds
    }
    
    func fetchLocalStorageForDownload(){
        DatapersistenceManager.shared.fetchingTitleItemFromDatabase { [weak self] result in
            switch result {
            case .success(let favoriteLaunch):
                self?.favoriteLaunches = favoriteLaunch
                DispatchQueue.main.async {
                    self?.favoriteLaunchesTable.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

extension FavoritesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteLaunches.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: LaunchesTableViewCell.identifier, for: indexPath) as? LaunchesTableViewCell  else {
            return UITableViewCell()
        }
        let launch = favoriteLaunches[indexPath.row]
        
        let date = launch.date_local?.expectedString(str: launch.date_local!)
        
        cell.configure(with: LaunchesViewModel(launchName: launch.name ?? "launch no name", image_link:launch.linkModel ?? "https://images2.imgbox.com/4f/e3/I0lkuJ2e_o.png", date_local: date ?? "2012-10-08", details: launch.details ?? "no details"))
    
        cell.setButtonFilled()
        cell.backgroundColor = UIColor(white: 0.2, alpha: 0.9)
        cell.layer.cornerRadius = 15
        cell.layer.borderWidth = 2
        cell.layer.borderColor = CGColor(red: 0, green: 0, blue: 0, alpha: 1)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        switch editingStyle {
            case.delete:
            DatapersistenceManager.shared.deleteTitleWith(model: favoriteLaunches[indexPath.row]) { result in
                switch result {
                case .success():
                    print("Data deleted from the database")
                case .failure(let error):
                    print(error.localizedDescription)
                }
                self.favoriteLaunches.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .left)
            }
            default:
                break;
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        let launch = favoriteLaunches[indexPath.row]
        
        guard let titleName = launch.name else {return}
        
        ApıCaller.shared.getLaunch(with: titleName) { [weak self] result in
            switch result {
            case .success(let videoElement):
                DispatchQueue.main.async {
                    let vc = YoutubeViewController()

                    vc.configure(with: LaunchPreviewViewModel(title: titleName, youtubeView: videoElement, launchDetail: launch.details ?? "No Details", articleLink: launch.articleLink ?? "https://www.google.com"))
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    
}


