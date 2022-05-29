//
//  HomeViewController.swift
//  MobilliumProject
//
//  Created by Yarkın Gazibaba on 16.05.2022.
//

import UIKit
import CoreMedia

class HomeViewController: UIViewController {
    
    private var launches: [LaunchesModel] = []
    
    let backgroundImage = UIImage(named: "space_background")
    
    private let launchesTable: UITableView = {
        let table = UITableView()
        let backgroundImage = UIImage(named: "launch_screen")
        let imageView = UIImageView(image: backgroundImage)
        imageView.contentMode = .scaleAspectFill
        table.backgroundView = imageView
        table.register(LaunchesTableViewCell.self, forCellReuseIdentifier: LaunchesTableViewCell.identifier)
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Launches"
        view.backgroundColor = .systemBackground
        view.addSubview(launchesTable)
        launchesTable.dataSource = self
        launchesTable.delegate = self
        callLaunches()
    }
    
    func callLaunches(){
        ApıCaller.shared.getAllLaunches { result in
            switch result {
            case .success(let launchsData):
                self.launches = launchsData
                DispatchQueue.main.async {
                    self.launchesTable.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func downloadLaunchAt(indexPath: IndexPath){
        DatapersistenceManager.shared.saveRocket(model: launches[indexPath.row]) { result in
            switch result{
            case .success():
                NotificationCenter.default.post(name: NSNotification.Name("downloaded"), object: nil)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
   }


    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        launchesTable.frame = view.bounds
    }
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return launches.count
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let config = UIContextMenuConfiguration(
            identifier: nil,
            previewProvider: nil) { [weak self] _ in
                let downloadAction = UIAction(title: "Download", subtitle: nil, image: UIImage(systemName: "arrow.down.square.fill"), identifier: nil, discoverabilityTitle: nil, state:.off)
                { _ in
                    self?.downloadLaunchAt(indexPath: indexPath)
                }
                return UIMenu(title: "", image:nil, identifier: nil, options: .displayInline, children: [downloadAction])
            }
        return config
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: LaunchesTableViewCell.identifier, for: indexPath) as? LaunchesTableViewCell  else {
            return UITableViewCell()
        }
        let launch = launches[indexPath.row]
        
        let date = launch.date_local?.expectedString(str: launch.date_local!)
        
        cell.configure(with: LaunchesViewModel(launchName: launch.name ?? "launch no name", image_link: launch.links?.patch?.small ?? "https://images2.imgbox.com/4f/e3/I0lkuJ2e_o.png", date_local: date ?? "2012-10-08", details: launch.details ?? "no details"))
        
        cell.backgroundColor = UIColor(white: 0.2, alpha: 0.9)
        cell.layer.cornerRadius = 15
        cell.layer.borderWidth = 2
        cell.layer.borderColor = CGColor(red: 0, green: 0, blue: 0, alpha: 1)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    
    // Set the spacing between sections
        func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
            return 5
        }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        let launch = launches[indexPath.row]
        
        guard let launchName = launch.name else {return}
        
        ApıCaller.shared.getLaunch(with: launchName) { [weak self] result in
            switch result {
            case .success(let videoElement):
                DispatchQueue.main.async {
                    let vc = YoutubeViewController()
                    vc.configure(with: LaunchPreviewViewModel(title: launchName, youtubeView: videoElement, launchDetail: launch.details ?? "No Details", articleLink: launch.links?.article ?? "no article"))
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}



