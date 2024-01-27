//
//  ViewController.swift
//  geeks_pro
//
//  Created by Aizat Ozbekova on 27/1/24.
//

import UIKit

class CharactersTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var characters: [RickAndMortyCharacter] = []

    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self

        tableView.register(CharacterTableViewCell.self, forCellReuseIdentifier: "CharacterCell")

        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])

        // Вызов метода для загрузки данных персонажей
        fetchCharacters()
    }

    func fetchCharacters() {
        guard let url = URL(string: "https://rickandmortyapi.com/api/character/") else {
            return
        }

        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let result = try decoder.decode(RickAndMortyCharacterList.self, from: data)

                    // Обновление массива персонажей и обновление интерфейса на основе полученных данных
                    self.characters = result.results
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                } catch {
                    print("Ошибка декодирования данных: \(error)")
                }
            }
        }.resume()
    }

    // MARK: - Table view data source
    
    

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return characters.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CharacterCell", for: indexPath) as! CharacterTableViewCell

            let character = characters[indexPath.row]

            // Загрузка изображения из URL
            if let imageURL = URL(string: character.image) {
                URLSession.shared.dataTask(with: imageURL) { (data, response, error) in
                    if let data = data {
                        DispatchQueue.main.async {
                            cell.characterImageView.image = UIImage(data: data)
                        }
                    }
                }.resume()
            }

            cell.nameLabel.text = character.name

            return cell
        }
}

struct RickAndMortyCharacter: Decodable {
    var name: String
    var image: String
}

struct RickAndMortyCharacterList: Decodable {
    var results: [RickAndMortyCharacter]
}

class CharacterTableViewCell: UITableViewCell {
    let characterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 25
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        addSubview(characterImageView)
        addSubview(nameLabel)

        NSLayoutConstraint.activate([
            characterImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            characterImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            characterImageView.widthAnchor.constraint(equalToConstant: 50),
            characterImageView.heightAnchor.constraint(equalToConstant: 50),

            nameLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: characterImageView.trailingAnchor, constant: 10),
            nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

