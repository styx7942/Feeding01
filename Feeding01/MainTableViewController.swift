//
//  MainTableViewController.swift
//  Feeding01
//
//  Created by D7703_17 on 2017. 11. 2..
//  Copyright © 2017년 LEE Hyeonho. All rights reserved.
//
//http://apis.data.go.kr/6260000/BusanFreeFoodProvidersInfoService/getFreeProvidersListInfo?serviceKey=tEp33kHhaR2SwQPmwWE1r6qwrhUTu1il2PVNGZEGwyvkm8i3MSl6dtzet1Mxofc7tCG1wZTkGjk0W47GM6bxSA%3D%3D&pageNo=1&startPage=1&numOfRows=5&pageSize=5



import UIKit

class MainTableViewController: UITableViewController,XMLParserDelegate {
      let listEndPoint = "http://apis.data.go.kr/6260000/BusanFreeFoodProvidersInfoService/getFreeProvidersListInfo"
      let ServiceKey = "tEp33kHhaR2SwQPmwWE1r6qwrhUTu1il2PVNGZEGwyvkm8i3MSl6dtzet1Mxofc7tCG1wZTkGjk0W47GM6bxSA%3D%3D"
      let detailEndPoint = "http://apis.data.go.kr/6260000/BusanFreeFoodProvidersInfoService/getFreeProvidersDetailsInfo"
      var item : [String:String] = [:]    //딕셔너리
      var items : [[String:String]] = []  //딕셔너리를 넣을 배열
      var key = ""
     
      
      
      
    override func viewDidLoad() {
        super.viewDidLoad()
      
      let fileManager = FileManager.default
      let url = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("data.plist")
      
      if fileManager.fileExists(atPath: url!.path){
            items = NSArray(contentsOf: url!) as! Array
      }else{
            getList()
            let tempList = items    //tempItem에 items정보를 가져옴
            items = []
            
            for tempItem in tempList{
                  getDetail(idx: tempItem["idx"]!)
            }
            print(items)
            
            let temp = items as NSArray
            temp.write(to: url!, atomically: true)
      }
      
      
      
      
      
      
      tableView.reloadData()

    }
      
      func getList(){
            let str = listEndPoint + "?serviceKey=\(ServiceKey)&numOfRows=100"
            
            if let url = URL(string: str){      //언래핑(Unwrapping)
                  if let parser =  XMLParser(contentsOf: url){
                        parser.delegate = self
                        //parser.parse()   parse()는 bool값이므로
                        let isSuccess = parser.parse()
                        if isSuccess{
                              print("성공")
                        }else{
                              print("실패")
                        }
                  }
            }
      }
      
      func getDetail(idx:String){//idx라는 매개변수를 생성
            let str = detailEndPoint + "?serviceKey=\(ServiceKey)&idx=\(idx)"
            
            if let url = URL(string: str){      //언래핑(Unwrapping)
                  if let parser =  XMLParser(contentsOf: url){
                        parser.delegate = self
                        //parser.parse()   parse()는 bool값이므로
                        let isSuccess = parser.parse()
                        if isSuccess{
                              print("성공")
                        }else{
                              print("실패")
                        }
                  }
            }
      }
      
      func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
            key = elementName //키값 저장
            if key == "item"{ //item을 찾으면 item딕셔너리에 저장
                  item = [:]
            }
      }
      
      
      func parser(_ parser: XMLParser, foundCharacters string: String) {
            //item[key] = string
            
            if item[key] == nil {   //기타사유로 한개당 두번씩 실행되므로 첫번째에 key
                                    //두번째에 nil값이 있으므로 key에 nil이 아닐때만 넣기
                  //공백이 있을수 있으므로 공백을 제거
                  item[key] = string.trimmingCharacters(in: .whitespaces)     //whitespaces==공백
                  
//                  print("key : \(key), value : \(string)")
            }
            
      }
      
      func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
            if elementName == "item" {     //끝날때(elementName) item일때
                  items.append(item)      //items 배열에 item을 추가
            }
            
      }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return items.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath)
      let dic = items[indexPath.row]
      cell.textLabel?.text = dic["name"]
      

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
