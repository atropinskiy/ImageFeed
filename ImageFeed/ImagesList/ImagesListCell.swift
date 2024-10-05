import UIKit

class GradientColor {
    var gl: CAGradientLayer!
    
    init() {
        let colorCenter = UIColor(red: 26.0 / 255.0, green: 27.0 / 255.0, blue: 34.0 / 255.0, alpha: 0.2).cgColor
        let colorEdge = UIColor(red: 26.0 / 255.0, green: 27.0 / 255.0, blue: 34.0 / 255.0, alpha: 0.0).cgColor
        
        self.gl = CAGradientLayer()
        self.gl.colors = [colorEdge, colorCenter, colorEdge]
        self.gl.locations = [0.0, 0.5, 1.0]
        self.gl.startPoint = CGPoint(x: 0.5, y: 0.0)
        self.gl.endPoint = CGPoint(x: 0.5, y: 1.0)
    }
    
    func createGradientLayer(for bounds: CGRect) -> CAGradientLayer {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = self.gl.colors
        gradientLayer.locations = self.gl.locations
        gradientLayer.startPoint = self.gl.startPoint
        gradientLayer.endPoint = self.gl.endPoint
        return gradientLayer
    }
}

final class ImagesListCell: UITableViewCell {
    static let reuseIdentifier = "ImagesListCell"
    weak var delegate: ImageListCellDelegate?
    private var gradientLayer: CAGradientLayer?
    
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var likeButton: UIButton!
    @IBOutlet var cellImage: UIImageView!
       
    override func prepareForReuse() {
        super.prepareForReuse()
        cellImage.kf.cancelDownloadTask()
        removeGradientLayer()
    }
    
    override func awakeFromNib() {
            super.awakeFromNib()
            // Градиент будет добавляться в layoutSubviews
        }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setGradient()
    }
    
    private func setGradient() {
        let gradientColor = GradientColor()
        let gradientLayer = gradientColor.createGradientLayer(for: dateLabel.bounds)
        dateLabel.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    private func removeGradientLayer() {
            // Удаляем предыдущий градиентный слой, если он есть
            gradientLayer?.removeFromSuperlayer()
        }
    
    func setIsLiked(isLiked: Bool){
           let liked = UIImage(named: "likeOn")
           let disLiked = UIImage(named: "likeOff")
           if isLiked {
               likeButton.setImage(liked, for: .normal)
           } else {
               likeButton.setImage(disLiked, for: .normal)
           }
       }
    
    @IBAction func likeButtonClicked(_ sender: Any) {
        delegate?.imageListCellDidTapLike(self)
    }
    

}
