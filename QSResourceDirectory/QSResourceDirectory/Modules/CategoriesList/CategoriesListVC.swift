//
//  CategoriesListVC.swift
//  QSResourceDirectory
//
//  Created by Ross Chea on 2020-08-07.
//  Copyright © 2020 Ross Chea. All rights reserved.
//

import UIKit

class CategoriesListVC: UIViewController {

    lazy var tableView: UITableView = {
        let tv = UITableView(frame: CGRect.zero, style: .insetGrouped)
        tv.backgroundColor = .systemGray6
        tv.delegate = self
        tv.dataSource = self
        tv.register(CategoryTVCell.self, forCellReuseIdentifier: CategoryTVCell.cellID)
        return tv
    }()

    private let dataModel: CategoriesListDataModelInterface

    init(dataModel: CategoriesListDataModelInterface = CategoriesListDataModel()) {
        self.dataModel = dataModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Categories"
        setupViews()
        dataModel.fetchCategories()
    }

    func setupViews() {
        view.addSubview(tableView)
        tableView.fullConstraint()
    }
}

extension CategoriesListVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let resourceVC = ResourceListVC()
        if let cat = dataModel.getCategoryByIndexPath(indexPath) {
            resourceVC.setCurrentCategorySelected(category: cat.getCategoryType())
        }
        navigationController?.pushViewController(resourceVC, animated: true)
    }
}

extension CategoriesListVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataModel.getNumberOfCategoriesForSection(section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: CategoryTVCell = tableView.dequeueReusableCell(
            withIdentifier: CategoryTVCell.cellID,
            for: indexPath
        ) as? CategoryTVCell else {
            debugPrint("Error with dequeuing cell.")
            return UITableViewCell()
        }

        guard let cat = dataModel.getCategoryByIndexPath(indexPath) else {
            return cell
        }
        cell.setModel(cat)
        return cell
    }
}
