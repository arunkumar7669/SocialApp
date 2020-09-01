//
//  VideoDetailsViewController.swift
//  Social.Cable
//
//  Created by Arun Kumar Rathore on 05/08/20.
//  Copyright © 2020 arunkumar. All rights reserved.
//

import UIKit
import AVKit
import Cosmos
import SwiftyJSON
import MBProgressHUD
import CNPPopupController

class VideoDetailsViewController: BaseViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var labelVideoTitle: UILabel!
//    @IBOutlet weak var viewVideoCode: UIView!
    @IBOutlet weak var viewRating: CosmosView!
    @IBOutlet weak var viewDescription: UIView!
    @IBOutlet weak var viewSeason: UIView!
    @IBOutlet weak var viewEpisode: UIView!
    @IBOutlet weak var collectionViewSeason: UICollectionView!
    @IBOutlet weak var collectionViewCast: UICollectionView!
    @IBOutlet weak var collectionViewRecently: UICollectionView!
    @IBOutlet weak var labelVideoTime: UILabel!
    @IBOutlet weak var labelRating: UILabel!
    @IBOutlet weak var labelReleaseYear: UILabel!
    @IBOutlet weak var labelTotalView: UILabel!
    @IBOutlet weak var imageViewVideo: UIImageView!
    @IBOutlet weak var viewCastBg: UIView!
    @IBOutlet weak var heightCastBgView: NSLayoutConstraint!
    @IBOutlet weak var labelCastTitle: UILabel!
    
    @IBOutlet var viewInviteFriend: UIView!
    @IBOutlet weak var buttonRemovePopup: UIButton!
    @IBOutlet weak var viewInviteFriendTitle: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var labelInviteFriend: UILabel!
    @IBOutlet var viewDescriptionPopup: UIView!
    @IBOutlet weak var labelDescription: UILabel!
    @IBOutlet weak var labelDescriptionTitle: UILabel!
    @IBOutlet var viewDescriptionTitle: UIView!
    @IBOutlet weak var buttonRemoveDescriptionPopup: UIButton!
    
//    for hide
    @IBOutlet weak var labelWatchSeason: UILabel!
    @IBOutlet weak var labelWatchEpisode: UILabel!
    @IBOutlet weak var imageViewSeasonArrow: UIImageView!
    @IBOutlet weak var imageViewEpisodeArrow: UIImageView!
    @IBOutlet weak var buttonSeason: UIButton!
    @IBOutlet weak var buttonEpisode: UIButton!
    
    let SEASON_CELL_ID = "SeasonCell"
    let CAST_CELL_ID = "CastCell"
    let RECENTLY_CELL_ID = "RecentlyCell"
    
    var popupViewController : CNPPopupController?
    var popupDescriptionViewController : CNPPopupController?
    var videoDetails = Dictionary<String, Any>()
    var moreVideoDetails = Dictionary<String, Any>()
    var arrayCastList = Array<Dictionary<String, String>>()
    var arrayRecentlyViewVideos = Array<Dictionary<String, Any>>()
    var viewDescriptionHeight = CGFloat()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setupViewDidLoadMethod()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    func setupViewDidLoadMethod() -> Void {
        
        self.setupBackBarButton()
        self.view.backgroundColor = UIColor.colorWithHexString(ColorCode.blackColor.rawValue)
        self.collectionViewSeason.backgroundColor = UIColor.colorWithHexString(ColorCode.appBackground.rawValue)
        self.collectionViewCast.backgroundColor = .clear
        self.collectionViewRecently.backgroundColor = .clear
        self.labelVideoTitle.textColor = UIColor.colorWithHexString(ColorCode.yellowColor.rawValue)
//        UtilityMethods.addBorder(self.viewVideoCode, .white, 5.0)
        UtilityMethods.addBorder(self.viewDescription, .white, 5.0)
        self.viewSeason.layer.cornerRadius = 5.0
        self.viewEpisode.layer.cornerRadius = 5.0
        self.viewSeason.backgroundColor = UIColor.colorWithHexString(ColorCode.buttonBackground.rawValue)
        self.viewEpisode.backgroundColor = UIColor.colorWithHexString(ColorCode.buttonBackground.rawValue)
        self.viewRating.rating = 0
        
//        self.collectionViewSeason.delegate = self
//        self.collectionViewSeason.dataSource = self
//        self.collectionViewSeason.contentInset = UIEdgeInsets.init(top: 0, left: 15, bottom: 0, right: 15)
//        self.collectionViewSeason.register(UINib.init(nibName: "SeasonCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: self.SEASON_CELL_ID)
        self.collectionViewSeason.isHidden = true
        self.labelWatchSeason.isHidden = true
        self.labelWatchEpisode.isHidden = true
        self.imageViewSeasonArrow.isHidden = true
        self.imageViewEpisodeArrow.isHidden = true
        self.buttonSeason.isHidden = true
        self.buttonEpisode.isHidden = true
        
        self.collectionViewCast.delegate = self
        self.collectionViewCast.dataSource = self
        self.collectionViewCast.contentInset = UIEdgeInsets.init(top: 0, left: 15, bottom: 0, right: 15)
        self.collectionViewCast.register(UINib.init(nibName: "CastCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: self.CAST_CELL_ID)
        
        self.collectionViewRecently.delegate = self
        self.collectionViewRecently.dataSource = self
        self.collectionViewRecently.contentInset = UIEdgeInsets.init(top: 0, left: 15, bottom: 0, right: 15)
        self.collectionViewRecently.register(UINib.init(nibName: "RecentViewCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: self.RECENTLY_CELL_ID)
        
        UtilityMethods.addBorder(self.viewInviteFriendTitle, UIColor.colorWithHexString(ColorCode.buttonBackground.rawValue), self.viewInviteFriendTitle.bounds.height / 2)
        UtilityMethods.addBorder(self.viewDescriptionTitle, UIColor.colorWithHexString(ColorCode.buttonBackground.rawValue), self.viewDescriptionTitle.bounds.height / 2)
        self.labelInviteFriend.textColor = UIColor.colorWithHexString(ColorCode.cyanColor.rawValue)
        self.labelDescriptionTitle.textColor = UIColor.colorWithHexString(ColorCode.cyanColor.rawValue)
        self.labelDescription.textColor = UIColor.white
        self.buttonRemovePopup.setImage(UIImage(named: "down_arrow")?.withRenderingMode(.alwaysTemplate), for: .normal)
        self.buttonRemovePopup.tintColor = UIColor.colorWithHexString(ColorCode.cyanColor.rawValue)
        self.buttonRemoveDescriptionPopup.setImage(UIImage(named: "down_arrow")?.withRenderingMode(.alwaysTemplate), for: .normal)
        self.buttonRemoveDescriptionPopup.tintColor = UIColor.colorWithHexString(ColorCode.cyanColor.rawValue)
        self.tableView.backgroundColor = .clear
        self.viewInviteFriendTitle.backgroundColor = UIColor.colorWithHexString(ColorCode.darkBlue.rawValue)
        self.viewInviteFriend.backgroundColor = UIColor.colorWithHexString(ColorCode.darkBlue.rawValue)
        self.viewDescriptionPopup.backgroundColor = UIColor.colorWithHexString(ColorCode.darkBlue.rawValue)
        self.setupTableViewDelegateAndDatasource()
        if self.videoDetails["id"] as? String != nil {
            self.webApiGetVideoDetails((self.videoDetails["id"] as! String))
        }
        self.setupVideoDetails(self.videoDetails)
    }
    
    func setupVideoDetails(_ videoDetails : Dictionary<String, Any>) -> Void {
        var imageUrl = String()
        if videoDetails["movie_thumbnail"] as? String == nil {
            imageUrl = ""
        }else {
            imageUrl = videoDetails["movie_thumbnail"] as! String
        }
        imageUrl = imageUrl.replacingOccurrences(of: " ", with: "%20")
        self.imageViewVideo.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage(named: "social_login"))
        if videoDetails["movie_actor"] as? Array<Dictionary<String, String>> != nil {
            self.arrayCastList = videoDetails["movie_actor"] as! Array<Dictionary<String, String>>
            if self.arrayCastList.count == 0 {
                self.collectionViewCast.isHidden = true
                self.heightCastBgView.constant = 0.5
                self.labelCastTitle.isHidden = true
                self.viewCastBg.isHidden = true
            }else {
                self.collectionViewCast.reloadData()
            }
        }else {
            self.collectionViewCast.isHidden = true
            self.heightCastBgView.constant = 0.5
            self.labelCastTitle.isHidden = true
            self.viewCastBg.isHidden = true
        }
        if videoDetails["video_title"] as? String != nil {
            self.labelVideoTitle.text = (videoDetails["video_title"] as! String)
        }else {
            self.labelVideoTitle.text = ""
        }
        var movieCategory = String()
        var movieTime = String()
        if videoDetails["movie_category"] as? String != nil {
            movieCategory = (videoDetails["movie_category"] as! String)
        }else {
            movieCategory = ""
        }
        if videoDetails["duration"] as? String != nil {
            movieTime = (videoDetails["duration"] as! String)
        }else {
            movieTime = ""
        }
        self.labelVideoTime.text = "\(movieCategory) \(movieTime)"
        var totalViews = String()
        if videoDetails["total_views"] as? String != nil {
            totalViews = (videoDetails["total_views"] as! String)
        }else {
            totalViews = "0"
        }
        self.labelTotalView.text = "\(totalViews)\nTotal Views"
        var rating = Double()
        if videoDetails["imdb_rating"] as? String != nil {
            rating = (Double(videoDetails["imdb_rating"] as! String) != nil ) ? ((Double(videoDetails["imdb_rating"] as! String)!) / 2.0) : 0
        }else {
            rating = 0
        }
        self.labelRating.text = "\(rating)"
        self.viewRating.rating = rating
        var htmlString = String()
        if videoDetails["video_description"] as? String != nil {
            htmlString = (videoDetails["video_description"] as! String)
        }else {
            htmlString = ""
        }
        let label = UILabel(frame: CGRect.zero)
        label.text = htmlString.html2String.trim()
        label.sizeToFit()
        self.viewDescriptionHeight = label.frame.height + 80.0
        self.labelDescription.text = htmlString.html2String.trim()
    }
    
    func setupTableViewDelegateAndDatasource() -> Void {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = .none
        self.tableView.estimatedRowHeight = 40
    }
    
//    UICollectionView Delegate and datasource Method
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.collectionViewSeason {
            return 15
        }else if collectionView == self.collectionViewCast {
            return self.arrayCastList.count
        }else if collectionView == self.collectionViewRecently {
            return self.arrayRecentlyViewVideos.count
        }else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.collectionViewSeason {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.SEASON_CELL_ID, for: indexPath) as! SeasonCollectionViewCell
            
            return cell
        }else if collectionView == self.collectionViewCast {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.CAST_CELL_ID, for: indexPath) as! CastCollectionViewCell
            
            let dictionaryCast = self.arrayCastList[indexPath.row]
            cell.labelCastName.text = dictionaryCast["genres_name"]
            var imageUrl = String()
            if dictionaryCast["genres_image"] == nil {
                imageUrl = ""
            }else {
                imageUrl = dictionaryCast["genres_image"]!
            }
            imageUrl = imageUrl.replacingOccurrences(of: " ", with: "%20")
            cell.imageViewCast.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage(named: "social_login"))
            UtilityMethods.addBorder(cell.imageViewCast, .white, cell.imageViewCast.bounds.height / 2)
            
            return cell
        }else if collectionView == self.collectionViewRecently {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.RECENTLY_CELL_ID, for: indexPath) as! RecentViewCollectionViewCell
            
            let dictionaryRecentlyView = self.arrayRecentlyViewVideos[indexPath.row]
            var imageUrl = String()
            if dictionaryRecentlyView["movie_thumbnail"] as? String == nil {
                imageUrl = ""
            }else {
                imageUrl = dictionaryRecentlyView["movie_thumbnail"] as! String
            }
            imageUrl = imageUrl.replacingOccurrences(of: " ", with: "%20")
            cell.imageViewVideo.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage(named: "social_login"))
            if dictionaryRecentlyView["total_views"] as? String == nil {
                cell.labelStar.text = ""
            }else {
                cell.labelStar.text = (dictionaryRecentlyView["total_views"] as! String)
            }
            if dictionaryRecentlyView["video_title"] as? String == nil {
                cell.labelTitle.text = ""
            }else {
                cell.labelTitle.text = (dictionaryRecentlyView["video_title"] as! String)
            }
            if dictionaryRecentlyView["created_at"] as? String == nil {
                cell.labelDate.text = self.convertDateToAppDate("")
            }else {
                cell.labelDate.text = self.convertDateToAppDate(dictionaryRecentlyView["created_at"] as! String)
            }
            if cell.labelStar.text!.isEmpty {
                cell.labelStar.isHidden = true
                cell.imageViewStar.isHidden = true
            }else {
                cell.labelStar.isHidden = false
                cell.imageViewStar.isHidden = false
            }
            
            return cell
        }else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.SEASON_CELL_ID, for: indexPath) as! SeasonCollectionViewCell
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == self.collectionViewSeason {
            return CGSize.init(width: (self.screenWidth - 45) / 2, height: 156.0)
        }else if collectionView == self.collectionViewCast {
            let label = UILabel(frame: CGRect.zero)
            let dictionaryCast = self.arrayCastList[indexPath.row]
            label.text = dictionaryCast["genres_name"]
            label.sizeToFit()
            var width = CGFloat()
            if label.frame.width > 60 {
                width = label.frame.width
            }else {
                width = 60
            }
            return CGSize.init(width: width, height: 98.0)
        }else if collectionView == self.collectionViewRecently {
//            return CGSize.init(width: 105.0, height: 150.0)
            return CGSize.init(width: 145.0, height: 100.0)
        }else {
            return CGSize.init(width: (self.screenWidth - 60) / 3, height: 80.0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.collectionViewRecently {
            let videoDVC = VideoDetailsViewController.init(nibName: "VideoDetailsViewController", bundle: nil)
            videoDVC.videoDetails = self.arrayRecentlyViewVideos[indexPath.row]
            self.navigationController?.pushViewController(videoDVC, animated: true)
        }
    }
    
//    MARK:- UITableView Delegate And Datasource Method
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("InviteFriendTableViewCell", owner: self, options: nil)?.first as! InviteFriendTableViewCell
        cell.selectionStyle = .none
        UtilityMethods.addBorder(cell.imageViewInvite, .white, cell.imageViewInvite.bounds.height / 2)
        cell.labelName.text = "Josheph"
        cell.labelNumber.text = "+91 9087654321"
        return cell
    }
    
//    func add new video to continue watch list on home page
    func addNewVideoToContinueWatchList() -> Void {
        
        var arrayContinuePlaying = UserDefaultOperations.getArrayObject(ConstantStrings.CONTINUE_PLAYING_VIDEO_LIST) as! Array<Dictionary<String, Any>>
        var isMatched = Bool()
        for video in arrayContinuePlaying {
            let currentVidoeID = (self.videoDetails["id"] as? String != nil) ? (self.videoDetails["id"] as! String) : "0"
            let videoID = (video["id"] as? String != nil) ? (video["id"] as! String) : "0"
            if currentVidoeID == videoID {
                isMatched = true
                break
            }
        }
        if !isMatched {
            arrayContinuePlaying.append(self.videoDetails)
            UserDefaultOperations.setArrayObject(ConstantStrings.CONTINUE_PLAYING_VIDEO_LIST, arrayContinuePlaying)
        }
    }
    
//    MARK:- Button Action
//    Button Back Action
    @IBAction func buttonBackAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func buttonPlayVideoAction(_ sender: UIButton) {
        if self.videoDetails["video_file"] as? String == nil {
            self.showToastWithMessage(self.view, ConstantStrings.COULD_NOT_LOAD_VIDEO)
        }else {
            self.playVideo(self.videoDetails["video_file"] as! String)
        }
    }
    
    @IBAction func buttonRemoveInviteFriendPopupAction(_ sender: UIButton) {
        self.popupViewController?.dismiss(animated: true)
    }
    
    @IBAction func buttonRemoveDescriptionPopupAction(_ sender: UIButton) {
        self.popupDescriptionViewController?.dismiss(animated: true)
    }
    
    @IBAction func buttonVideoCallInviteAction(_ sender: UIButton) {
        self.showInviteFriendPopup()
    }
    
    @IBAction func buttonShowDescriptionAction(_ sender: UIButton) {
        self.showDescriptionDetailsPopup()
    }
    
    func playVideo(_ url : String) -> Void {
        
        //Substitute your video stream URL here to test
        self.addNewVideoToContinueWatchList()
        guard let url = URL(string: url) else {
            return
        }
        // Create an AVPlayer, passing it the HTTP Live Streaming URL.
        let player = AVPlayer(url: url)

        // Create a new AVPlayerViewController and pass it a reference to the player.
        let controller = AVPlayerViewController()
        controller.player = player

        // Modally present the player and call the player's play() method when complete.
        present(controller, animated: true) {
            player.play()
        }
    }
    
    func showInviteFriendPopup() -> Void {
        self.viewInviteFriend.frame = CGRect.init(x: 0, y: 0, width: self.screenWidth, height: 300)
        let popupController = CNPPopupController(contents:[self.viewInviteFriend])
        popupController.theme = CNPPopupTheme.default()
        popupController.theme.popupStyle = CNPPopupStyle.actionSheet
        // LFL added settings for custom color and blur
        popupController.theme.backgroundColor =  UIColor.colorWithHexString(ColorCode.darkBlue.rawValue)
        popupController.theme.maskType = .dimmed
        self.popupViewController = popupController
        popupController.present(animated: true)
    }
    
    func showDescriptionDetailsPopup() -> Void {
        self.viewDescriptionPopup.frame = CGRect.init(x: 0, y: 0, width: self.screenWidth, height: self.viewDescriptionHeight)
        let popupController = CNPPopupController(contents:[self.viewDescriptionPopup])
        popupController.theme = CNPPopupTheme.default()
        popupController.theme.popupStyle = CNPPopupStyle.actionSheet
        // LFL added settings for custom color and blur
        popupController.theme.backgroundColor =  UIColor.colorWithHexString(ColorCode.darkBlue.rawValue)
        popupController.theme.maskType = .dimmed
        self.popupDescriptionViewController = popupController
        popupController.present(animated: true)
    }
    
//    MARK:- Web Api Code Start
//    Web api for get the video details
    func webApiGetVideoDetails(_ videoID : String) -> Void {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let url = WebApi.BASE_URL + "api/video-detailById"
        print(url)
        let updatedUrl = url.replacingOccurrences(of: " ", with: "%20")
        let parameter = ["video_id" : videoID, "customer_id" : UserDefaultOperations.getStringObject(ConstantStrings.USER_ID)]
        
        WebApi.webApiForPostRequestWithToken(updatedUrl, parameter) { (json : JSON) in
            MBProgressHUD.hide(for: self.view, animated: true)
            if json.isEmpty {
                self.showAlertWithMessage(ConstantStrings.ALERT, ConstantStrings.COULD_NOT_CONNECT_TO_SERVER)
            }else{
                if json["error"] == true {
                    self.showAlertWithMessage(ConstantStrings.ALERT, ConstantStrings.DATA_IS_NOT_AVAILABLE)
                }else {
                    self.setupVideoDetailsData(json.dictionaryObject!)
                }
            }
        }
    }
    
//    Func setup Video Details
    func setupVideoDetailsData(_ jsonDictionary : Dictionary<String, Any>) -> Void {
        if jsonDictionary["status_code"] as? Int != nil {
            if jsonDictionary["status_code"] as! Int == 401 {
                self.sessionExpiredMoveOnLoginPage()
                return
            }
        }
        if jsonDictionary["status"] as? String != nil {
            if jsonDictionary["status"] as! String == ConstantStrings.SUCCESS_STATUS {
                if jsonDictionary["data"] as? Dictionary<String, Any> != nil {
                    let videoData = jsonDictionary["data"] as! Dictionary<String, Any>
                    if videoData["video_details"] as? Dictionary<String, Any> != nil {
                        self.moreVideoDetails = videoData["video_details"] as! Dictionary<String, Any>
                        var movieYear = String()
                        if self.moreVideoDetails["release_date"] as? String != nil {
                            movieYear = (self.moreVideoDetails["release_date"] as! String)
                        }else {
                            movieYear = "0"
                        }
                        self.labelReleaseYear.text = "\(movieYear)\nRelease"
                        if videoData["genres"] as? Array<Dictionary<String, String>> != nil {
                            self.arrayCastList = videoData["genres"] as! Array<Dictionary<String, String>>
                            self.collectionViewCast.reloadData()
                        }
                        
                        if videoData["similar_videos"] as? Array<Dictionary<String, Any>> != nil {
                            self.arrayRecentlyViewVideos = videoData["similar_videos"] as! Array<Dictionary<String, Any>>
                            self.collectionViewRecently.reloadData()
                        }
                    }
                }
            }
        }
    }
}

extension Data {
    var html2AttributedString: NSAttributedString? {
        do {
            return try NSAttributedString(data: self, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            print("error:", error)
            return  nil
        }
    }
    var html2String: String { html2AttributedString?.string ?? "" }
}

extension StringProtocol {
    var html2AttributedString: NSAttributedString? {
        Data(utf8).html2AttributedString
    }
    var html2String: String {
        html2AttributedString?.string ?? ""
    }
}
