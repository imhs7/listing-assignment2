//
//  ViewController.swift
//  ListingAssignment2
//
//  Created by Hemant Sharma on 28/07/21.
//

import UIKit

class ViewController: UIViewController {
    
    private var myCollectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isScrollEnabled = true
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    var categoryDetail = [Category]()
    var selectedIndex = [IndexPath]()
    
    var resultDict = [String: Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpCollectionView()
        styleCollectionView()
        
        fetchFilterDetails { result in
            //            self.categoryDetail = result?.categories ?? []
            //                        self.myCollectionView.reloadData()
        }
    }
    
    func fetchFilterDetails(completion: @escaping (DataClass?) -> Void) {
        
        let urlString = "https://jsonkeeper.com/b/P419"
        let url = URL(string: urlString)
        let task = URLSession.shared.dataTask(with: url!) { data, _, error in
            if error != nil {
                print(error?.localizedDescription)
                return
            }
            do {
                let jsonData = try? JSONDecoder().decode(FiltersModel.self, from: data!)
                if let filterDetail = jsonData?.data?.categories
                {
                    DispatchQueue.main.async {
                        self.categoryDetail = filterDetail
                        print(self.categoryDetail)
                        self.myCollectionView.reloadData()
                    }
                }
                completion(nil)
                
            }
//           catch {
//                completion(nil)
//            }
        }
        task.resume()
    }
}

extension ViewController {
    
    func setUpCollectionView() {
        myCollectionView.delegate = self
        myCollectionView.dataSource = self
        
        myCollectionView.register(FilterCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: FilterCollectionViewCell.self))
        myCollectionView.register(Header.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "Header")
    }
    
    func styleCollectionView() {
        
        view.addSubview(myCollectionView)
        NSLayoutConstraint.activate([
                                        myCollectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 32),
                                        myCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                                        myCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
                                        myCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)])
        myCollectionView.backgroundColor = .white
    }
}

extension ViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if resultDict[categoryDetail[indexPath.section].name ?? ""] == indexPath.row {
            resultDict[categoryDetail[indexPath.section].name ?? ""] = nil
        } else {
            resultDict[categoryDetail[indexPath.section].name ?? ""] = indexPath.row
        }
        let indexSet = IndexSet(integer: indexPath.section)
        collectionView.reloadSections(indexSet)
    }
}

extension ViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        categoryDetail.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        categoryDetail[section].filters?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: FilterCollectionViewCell.self), for: indexPath) as! FilterCollectionViewCell
        let categoryDetailName = categoryDetail[indexPath.section].name
        let categoryName = categoryDetail[indexPath.section].filters?[indexPath.item].name
        var shouldSelect = false
        if resultDict[categoryDetailName ?? ""] != nil {
            shouldSelect = resultDict[categoryDetailName ?? ""] == indexPath.row
        }
        cell.configure(filterCategoryName: categoryName, isSelected: shouldSelect)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let headerSection = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "Header", for: indexPath) as! Header
            headerSection.headerLabel.text = categoryDetail[indexPath.section].name
            return headerSection
        } else {
            return UICollectionReusableView()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 40)
    }
}


extension ViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = UIScreen.main.bounds.width
        let height: CGFloat = 40
        return CGSize(width: width, height: height)
    }
}
