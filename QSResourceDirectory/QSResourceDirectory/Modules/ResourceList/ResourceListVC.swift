//
//  ResourceListVC.swift
//  QSResourceDirectory
//
//  Created by Ross Chea on 2020-08-07.
//  Copyright © 2020 Ross Chea. All rights reserved.
//


import UIKit

class ResourceListVC: UIViewController {

    lazy var tableView: UITableView = {
        let tv = UITableView(frame: CGRect.zero, style: .insetGrouped)
        tv.backgroundColor = .systemGray6
        tv.rowHeight = UITableView.automaticDimension
        tv.estimatedRowHeight = 200
        tv.delegate = self
        tv.dataSource = self
        tv.register(ResourceCell.self, forCellReuseIdentifier: ResourceCell.cellID)
        return tv
    }()
    private var dataModel: ResourceListDataModelInterface

    init(dataModel: ResourceListDataModelInterface = ResourceListVCDataModel()) {
        self.dataModel = dataModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Resources"
        view.backgroundColor = .blue
        setupViews()
        setupBarButtonItem()
    }

    func setCurrentCategorySelected(category: CategoryType) {
        dataModel.fetchDestinationsForCategory(category)
    }

    func setupViews() {
        view.addSubview(tableView)
        tableView.fullConstraint()
    }

    private func setupBarButtonItem() {
        let offLabel = UILabel()
        offLabel.font = UIFont.boldSystemFont(ofSize: UIFont.smallSystemFontSize)
        offLabel.text = "A-Z"

        let onLabel = UILabel()
        onLabel.font = UIFont.boldSystemFont(ofSize: UIFont.smallSystemFontSize)
        onLabel.text = "Z-A"

        let toggle = UISwitch()
        toggle.addTarget(self, action: #selector(toggleValueChanged(_:)), for: .valueChanged)
        toggle.onTintColor = .primaryRed

        let stackView = UIStackView(arrangedSubviews: [offLabel, toggle, onLabel])
        stackView.spacing = 8

        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: stackView)
    }

    @objc func toggleValueChanged(_ toggle: UISwitch) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.dataModel.sortedAlphabeticallyDestinationList(toggle.isOn)
            self.tableView.reloadData()
        }
    }
}

extension ResourceListVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if let destinationModel = dataModel.getDestinationByIndexPath(indexPath) {
            let resourceDetailsVC = ResourceDetailsVC(
                dataModel: ResourceDetailsDataModel(destination: destinationModel)
            )
            navigationController?.pushViewController(resourceDetailsVC, animated: true)
        } else {
            debugPrint("Error unable to push to resourceDetailsVC")
        }
    }
}

extension ResourceListVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataModel.getNumberOfPlacesForSection(section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: ResourceCell = tableView.dequeueReusableCell(
            withIdentifier: ResourceCell.cellID,
            for: indexPath
        ) as? ResourceCell else {
            debugPrint("Error with dequeuing cell.")
            return UITableViewCell()
        }
        guard let destinationModel = dataModel.getDestinationByIndexPath(indexPath) else {
            return cell
        }
        cell.setModel(destinationModel)
        return cell
    }
}


