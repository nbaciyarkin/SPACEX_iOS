//
//  HomeViewController.swift
//  MobilliumProject
//
//  Created by Yarkın Gazibaba on 16.05.2022.
//

import UIKit

class HomeViewController: UIViewController {
    
    
    private var launches: [LaunchesModel] = []
    
    private let launchesTable: UITableView = {
        
        let table = UITableView()
        table.register(LaunchesTableViewCell.self, forCellReuseIdentifier: LaunchesTableViewCell.identifier)
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
    
  
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        launchesTable.frame = view.bounds
    }
}



extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        launches.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: LaunchesTableViewCell.identifier, for: indexPath) as? LaunchesTableViewCell  else {
            return UITableViewCell()
        }
        let launch = launches[indexPath.row]
        
        let date_local = launch.date_local

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YY-MM-d"
        dateFormatter.date(from: date_local ?? "01/02/2016")
        let stringDate = dateFormatter.string( for: dateFormatter.date(from: date_local ?? "01/02/2016")) ?? "01/02/2016"
        
        
        cell.configure(with: LaunchesViewModel(launchName: launch.name ?? "launch no name", image_link: launch.links?.patch?.small ?? "https://images2.imgbox.com/4f/e3/I0lkuJ2e_o.png", date_local: stringDate, details: launch.details ?? "no details"))
        
        if(cell.isFilled){
            print("filled kalp")
            cell.save(indexPath: launch)
            DispatchQueue.main.async {
                self.launchesTable.reloadData()
            }
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let launch = launches[indexPath.row]
        guard let titleName = launch.name else {return}
        
        ApıCaller.shared.getLaunch(with: titleName) { [weak self] result in
            switch result {
            case .success(let videoElement):
                DispatchQueue.main.async {
                    let vc = YoutubeViewController()
                    vc.configure(with: LaunchPreviewViewModel(title: titleName, youtubeView: videoElement, launchDetail: launch.details ?? "No Details"))
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}


extension HomeViewController: LaunchesTableViewTableViewCellDelegate {
    
    func tabelViewTableViewCellcheckTap(_cell cell: LaunchesTableViewCell, cellForRowAt indexPath: IndexPath, viewModel model: [LaunchesModel]) {
        

    }
    
}
