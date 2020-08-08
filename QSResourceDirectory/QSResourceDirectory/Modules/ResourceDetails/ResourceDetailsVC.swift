//
//  ResourceDetailsVC.swift
//  QSResourceDirectory
//
//  Created by Ross Chea on 2020-08-07.
//  Copyright © 2020 Ross Chea. All rights reserved.
//

import UIKit
import MessageUI
import MapKit

protocol ResourceDetailsDelegate: class {
    func openWebBrowser(_ urlStr: String)
}


class ResourceDetailsVC: UIViewController {

    lazy var imageView: UIImageView = {
        let v = UIImageView()
        v.contentMode = .scaleAspectFit
        v.clipsToBounds = true
        v.image = UIImage(named: "placeholder")
        v.backgroundColor = .black
        v.loadURLString(self.dataModel.destination.photo)
        return v
    }()

    lazy var titleLabel: UILabel = {
        let v = UILabel()
        v.textColor = .black
        v.font = UIFont.boldSystemFont(ofSize: 21)
        return v
    }()
    lazy var descriptionLabel: UILabel = {
        let v = UILabel()
        v.textColor = .black
        v.numberOfLines = 0
        return v
    }()

    lazy var tableView: UITableView = {
        let tv = UITableView(frame: CGRect.zero, style: .insetGrouped)
        tv.backgroundColor = .systemGray6
        tv.rowHeight = UITableView.automaticDimension
        tv.estimatedRowHeight = 200
        tv.delegate = self
        tv.dataSource = self
        tv.register(ResourceDetailComponentCell.self, forCellReuseIdentifier: ResourceDetailComponentCell.cellID)
        return tv
    }()

    private var dataModel: ResourceDetailsDataModelInterface

    init(dataModel: ResourceDetailsDataModelInterface) {
        self.dataModel = dataModel
        super.init(nibName: nil, bundle: nil)

        titleLabel.text = dataModel.destination.title
        descriptionLabel.text = dataModel.destination.description.withoutHtmlTags()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Resources Details"
        view.backgroundColor = .systemGray6
        setupViews()
    }

    func setupViews() {
        view.addSubview(imageView)
        view.addSubview(titleLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(tableView)

        imageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false

        let sidePadding: CGFloat = 20

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            imageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: sidePadding),
            imageView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -sidePadding),
            imageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.3),

            titleLabel.topAnchor.constraint(equalTo: imageView.safeAreaLayoutGuide.bottomAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: sidePadding),
            titleLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -sidePadding),
            titleLabel.bottomAnchor.constraint(equalTo: descriptionLabel.topAnchor, constant: -20),

            descriptionLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: sidePadding),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -sidePadding),

            tableView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 20),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -0)
        ])
    }
}

extension ResourceDetailsVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let model = dataModel.getItemByIndexPath(indexPath) else {
            return
        }
        if case ActionableType.none = model.actionable {
            return
        }

        switch model.actionable {
            case .phone(let val):
                makeCallWithUrl(val)
            case .email(let val):
                openEmailComposer(val)
            case .website(let val):
                openWebBrowser(val)
            case .map(let coordinates, let name):
                openMaps(coordinates, name: name)
            case .none:
                debugPrint("No action required")
        }

//        dataModel.handleActionableEvent(model.actionable)
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        dataModel.getSectionTitleForSection(section)
    }
}

extension ResourceDetailsVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        dataModel.getNumberOfSection()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataModel.getNumberOfItemsForSection(section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: ResourceDetailComponentCell = tableView.dequeueReusableCell(
            withIdentifier: ResourceDetailComponentCell.cellID,
            for: indexPath
        ) as? ResourceDetailComponentCell else {
            debugPrint("Error with dequeuing cell.")
            return UITableViewCell()
        }
        guard let model = dataModel.getItemByIndexPath(indexPath) else {
            return cell
        }
        cell.delegate = self
        cell.setModel(model)
        return cell
    }
}

extension ResourceDetailsVC: ResourceDetailsDelegate {
    func openWebBrowser(_ urlStr: String) {
        print(urlStr)
        if urlStr.isEmpty {
            return
        }
        let vc = WebVC()
        vc.openURLWithString(urlStr)
        navigationController?.pushViewController(vc, animated: true)
        // handle incorrect redirects
    }
}
//TODO: Extract out the additional services
private extension ResourceDetailsVC {
    func makeCallWithUrl(_ phoneNumber: String) {
        if phoneNumber.isEmpty {
            return
        }
        if let phoneCallURL = URL(string: "tel://\(phoneNumber)") {
            let application:UIApplication = UIApplication.shared
            if application.canOpenURL(phoneCallURL) {
                application.open(
                    phoneCallURL,
                    options: [:],
                    completionHandler: nil
                )
                return
            }
        }
        debugPrint("Error unable to open a call...")
    }

    func openEmailComposer(_ email: String) {
        if email.isEmpty {
            return
        }
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["you@yoursite.com"])
            mail.setMessageBody("<p>You're so awesome!</p>", isHTML: true)

            present(mail, animated: true)
        } else {
            let alertVC = UIAlertController(title: "Unable to launch composer", message: "Please setup your email client", preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
            alertVC.addAction(
                UIAlertAction(title: "Okay", style: .default, handler: { _ in
                    if let url = URL(string: "mailto:\(email)") {
                         UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    }
                })
            )
            present(alertVC, animated: true)
        }
    }

    func openMaps(_ coordinates: MapCoordinate, name: String) {
        guard let lat = Double(coordinates.latitude), let lon = Double(coordinates.longitude) else {
            return
        }

        let latitude: CLLocationDegrees = lat
        let longitude: CLLocationDegrees = lon

        let regionDistance:CLLocationDistance = 10000
        let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
        let regionSpan = MKCoordinateRegion(center: coordinates, latitudinalMeters: regionDistance, longitudinalMeters: regionDistance)
        let options = [
            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
        ]
        let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = name
        mapItem.openInMaps(launchOptions: options)
    }
}

extension ResourceDetailsVC: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
         controller.dismiss(animated: true, completion: nil)
    }
}
