//
//  ViewController.swift
//  webServices
//
//  Created by Andres Abraham Bonilla Gòmez on 24/07/18.
//  Copyright © 2018 beHere. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var indicador: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    var refreshControl: UIRefreshControl!

    let url = "https://labs.docademic.com:3020/api/catalog/country"
    let classWeb = funcWeb()
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        refreshControl = UIRefreshControl()
        refreshControl.backgroundColor = UIColor.red
        refreshControl.tintColor = UIColor.yellow
        
        
        refreshControl.addTarget(self, action: #selector(ViewController.handleRefresh(_:)), for: UIControlEvents.valueChanged)
        
        tableView.addSubview(refreshControl)
        indicador.startAnimating()
        datafromServer()
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        if (classWeb.nameCountryArray.count == 0)
        {
            tableView.separatorStyle = .none
            indicador.startAnimating()
            indicador.backgroundColor = UIColor.white
        }
        
        if let index = self.tableView.indexPathForSelectedRow{
            self.tableView.deselectRow(at: index, animated: true)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func datafromServer()
    {
        classWeb.verifyData(url: self.url) { (flag) in
            if flag == true
            {
                self.classWeb.dataCountries(url: self.url, completion: { (flag2) in
                    if flag2 == true
                    {
                        self.tableView.reloadData()
                        self.indicador.stopAnimating()
                        self.indicador.isHidden = true
                    }
                })
            }
            else
            {
                let alert = UIAlertController(title: "Error", message: "No se ha podido conectar con el server", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Recargar", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: self.restartApp)
            }
        }
    }
    func restartApp()
    {
        datafromServer()
    }
    
    
    //funciones de tablas
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellCountry", for: indexPath)
        cell.textLabel?.text = self.classWeb.nameCountryArray[indexPath.item]
        cell.detailTextLabel?.text = self.classWeb.codeCountryArray[indexPath.item]
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.classWeb.nameCountryArray.count
    }
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl)
    {
        datafromServer()
        refreshControl.endRefreshing()
    }
    
    //Pasar al otro view
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let url2 = url+"/id/\(self.classWeb.codeCountryArray[indexPath.row])"
        self.classWeb.verifyData(url: url2) { (flag) in
            if flag == true
            {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "detailCountry") as! SecondViewController
                vc.urlCountry = url2
                vc.nameCountry = self.classWeb.nameCountryArray[indexPath.row]
                self.navigationController?.pushViewController(vc, animated: true)
            }
            else
            {
                let alert = UIAlertController(title: "Error", message: "Pais no disponible", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
        
        
        
    }
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
//    {
//
//        if let cell = sender as? UITableViewCell
//        {
//            let i = tableView.indexPath(for: cell)!.row
//
//            self.classWeb.verifyData(url: url+"/id/\(self.classWeb.codeCountryArray[i])") { (flag) in
//                if flag == true
//                {
//                    if segue.identifier == "dataCountry"
//                    {
//                        let vc = segue.destination as! SecondViewController
//                        vc.nameCountry = self.classWeb.nameCountryArray[i]
//                        print(vc.nameCountry)
//                    }
//                }
//                else
//                {
//                    let alert = UIAlertController(title: "Error", message: "Pais no disponible", preferredStyle: UIAlertControllerStyle.alert)
//                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
//                    self.present(alert, animated: true, completion: nil)
//                }
//            }
//
//        }
//    }
}
