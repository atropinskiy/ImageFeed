import UIKit

//class GradientColor {
//    var gl: CAGradientLayer!
//    
//    init() {
//        let colorCenter = UIColor(red: 26.0 / 255.0, green: 27.0 / 255.0, blue: 34.0 / 255.0, alpha: 1.0).cgColor // Изменили alpha на 1.0
//        let colorEdge = UIColor(red: 26.0 / 255.0, green: 27.0 / 255.0, blue: 34.0 / 255.0, alpha: 0.0).cgColor
//        
//        self.gl = CAGradientLayer()
//        self.gl.colors = [colorEdge, colorCenter, colorEdge]
//        self.gl.locations = [0.0, 0.5, 1.0]
//        self.gl.startPoint = CGPoint(x: 0.5, y: 0.0)
//        self.gl.endPoint = CGPoint(x: 0.5, y: 1.0)
//    }
//    
//    func createGradientLayer(for bounds: CGRect) -> CAGradientLayer {
//        let gradientLayer = CAGradientLayer()
//        gradientLayer.frame = bounds
//        gradientLayer.colors = self.gl.colors
//        gradientLayer.locations = self.gl.locations
//        gradientLayer.startPoint = self.gl.startPoint
//        gradientLayer.endPoint = self.gl.endPoint
//        return gradientLayer
//    }
//}

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
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

    }
    
//    private func setGradient() {
//        removeGradientLayer()
//        
//        let gradientColor = GradientColor()
//        
//        // Используем полный размер ячейки
//        let gradientLayer = gradientColor.createGradientLayer(for: self.bounds)
//
//        // Логируем размеры для проверки
//        print("Gradient layer frame: \(gradientLayer.frame)")
//        
//        // Добавляем градиентный слой на ячейку
//        self.layer.insertSublayer(gradientLayer, at: 0) // Убедимся, что он на самом дне
//        self.gradientLayer = gradientLayer // Сохраняем ссылку на градиентный слой
//
//        // Дополнительные логи для проверки
//        print("Date label frame: \(dateLabel.frame)")
//        print("Content view frame: \(self.bounds)")
//    }
//    
//    private func removeGradientLayer() {
//        // Удаляем предыдущий градиентный слой, если он есть
//        gradientLayer?.removeFromSuperlayer()
//    }
    
    func setIsLiked(isLiked: Bool) {
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
