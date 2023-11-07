//
//  LinkViewController.swift
//  LinkPreview-iOS
//
//  Created by 이전희 on 2023/09/11.
//

import UIKit
import Combine
import LinkPresentation

public class LinkViewController: UIViewController {
    static let metadataProvider: LPMetadataProvider = LPMetadataProvider()
    private var cancellable: Set<AnyCancellable> = Set<AnyCancellable>()
    
    private lazy var imageViewHeightConstraint: NSLayoutConstraint = metadataImageView
        .heightAnchor
        .constraint(equalTo: metadataImageView.widthAnchor,
                    multiplier: metadataImageView.image?.aspectBaseHeight ?? 0)
    
    let url: URL
    var metadata: LinkMetadata?
    var style: LinkViewController.Style
    
    private var metadataImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 20
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var metadataUrlTextView: UITextView = {
        let textView = UITextView()
        textView.textColor = .linkGray
        textView.backgroundColor = .clear
        textView.font = UIFont.systemFont(ofSize: 14)
        textView.isScrollEnabled = false
        
        textView.textContainer.maximumNumberOfLines = 1
        textView.textContainer.lineBreakMode = .byTruncatingTail
        textView.isSelectable = false
        return textView
        
    }()
    
    private var metadataIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 4
        imageView.clipsToBounds = true
        return imageView
    }()

    
    private var metadataTextContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .linkBackground
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        view.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMaxXMinYCorner, .layerMaxXMaxYCorner)
        return view
    }()
    
    private var metadataTitleTextView: UITextView = {
        let textView = UITextView()
        textView.textColor = .black
        textView.font = .systemFont(ofSize: 20, weight: .bold)
        textView.isScrollEnabled = false
        textView.textContainerInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        textView.backgroundColor = .clear
        textView.isSelectable = false
        return textView
    }()
    
    private var metadataDescriptionTextView: UITextView = {
        let textView = UITextView()
        textView.textColor = .linkGray
        textView.font = .systemFont(ofSize: 16)
        textView.isScrollEnabled = false
        textView.textContainerInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        textView.textContainer.maximumNumberOfLines = 3
        textView.textContainer.lineBreakMode = .byTruncatingTail
        textView.backgroundColor = .clear
        textView.isSelectable = false
        return textView
    }()
    
    private var line: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()

    init(url: URL,
         metadata: LinkMetadata?=nil,
         style: Style=Style()){
        self.url = url
        self.metadata = metadata
        self.style = style
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        addSubviews()
        makeConstraints()
    }
    
    private func configure() {
        self.view.backgroundColor = .white
        self.view.layer.cornerRadius = 20
        self.view.clipsToBounds = true
        fetchMetadata()
    }
    
    private func addSubviews() {
        [metadataImageView,
         metadataUrlTextView,
         metadataTextContainer].forEach { view in
            self.view.addSubview(view)
        }
        
        [line,
         metadataTitleTextView,
         metadataDescriptionTextView].forEach { view in
            metadataTextContainer.addSubview(view)
        }
    }
    
    private func makeConstraints() {
        self.view.translatesAutoresizingMaskIntoConstraints = false
        
        [metadataTitleTextView,
         metadataDescriptionTextView,
         line].forEach { view in
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        [metadataImageView,
         metadataUrlTextView,
         metadataTextContainer].forEach{ view in
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        let containerConstraint: [NSLayoutConstraint] = [
            line.widthAnchor.constraint(equalToConstant: style.lineWidth),
            line.topAnchor.constraint(equalTo: metadataTextContainer.topAnchor),
            line.leadingAnchor.constraint(equalTo: metadataTextContainer.leadingAnchor),
            line.bottomAnchor.constraint(equalTo: metadataTextContainer.bottomAnchor),
            
            metadataTitleTextView.topAnchor.constraint(equalTo: metadataTextContainer.topAnchor,
                                                       constant: style.containerPadding),
            metadataTitleTextView.leadingAnchor.constraint(equalTo: line.trailingAnchor,
                                                           constant: style.decoSpacing),
            metadataTitleTextView.trailingAnchor.constraint(equalTo: metadataTextContainer.trailingAnchor,
                                                            constant: -style.containerPadding),
            
            metadataDescriptionTextView.topAnchor.constraint(equalTo: metadataTitleTextView.bottomAnchor),
            metadataDescriptionTextView.leadingAnchor.constraint(equalTo: line.trailingAnchor,
                                                                 constant: style.decoSpacing),
            metadataDescriptionTextView.trailingAnchor.constraint(equalTo: metadataTextContainer.trailingAnchor,
                                                                  constant: -style.decoSpacing),
            
            metadataTextContainer.bottomAnchor.constraint(equalTo: metadataDescriptionTextView.bottomAnchor,
                                                          constant: style.containerPadding)
        ]
        
        NSLayoutConstraint.activate(containerConstraint)
        
        let constraints: [NSLayoutConstraint] = [
            metadataImageView.topAnchor.constraint(equalTo: self.view.topAnchor,
                                                   constant: style.padding),
            metadataImageView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor,
                                                       constant: style.padding),
            metadataImageView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor,
                                                        constant: -style.padding),
            imageViewHeightConstraint,

            metadataUrlTextView.topAnchor.constraint(equalTo: metadataImageView.bottomAnchor),
            metadataUrlTextView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor,
                                                         constant: style.padding),
            metadataUrlTextView.trailingAnchor.constraint(equalTo:self.view.trailingAnchor,
                                                          constant: -style.padding),
            
            metadataTextContainer.topAnchor.constraint(equalTo: metadataUrlTextView.bottomAnchor,
                                                       constant: 4),
            metadataTextContainer.leadingAnchor.constraint(equalTo: self.view.leadingAnchor,
                                                           constant: style.padding),
            metadataTextContainer.trailingAnchor.constraint(equalTo: self.view.trailingAnchor,
                                                            constant: -style.padding),
            self.view.bottomAnchor.constraint(equalTo: metadataTextContainer.bottomAnchor,
                                              constant: style.padding)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    private func fetchMetadata() {
        LinkViewController.metadataProvider.startFetchingMetadataWithImagePublisher(url: url)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    break
                case let .failure(error):
                    self?.updateLayoutWithError(error)
                }
            } receiveValue: { [weak self] metadata in
                self?.updateLayoutWithMetadata(metadata)
            }
            .store(in: &cancellable)
    }
    
    private func updateLayoutWithError(_ error: Error) {
        self.view.layoutIfNeeded()
    }
    
    private func updateLayoutWithMetadata(_ metadata: LinkMetadata) {
        self.metadata = metadata
        
        #if DEBUG 
        print(metadata)
        #endif

        self.metadataImageView.removeConstraint(imageViewHeightConstraint)
        self.imageViewHeightConstraint = self.metadataImageView.heightAnchor
            .constraint(equalTo: metadataImageView.widthAnchor,
                        multiplier: metadata.image?.aspectBaseHeight ?? 0)
        self.imageViewHeightConstraint.isActive = true
        
        UIView.transition(with: metadataImageView,
                          duration: 0.7,
                          options: .transitionCrossDissolve) {
            self.metadataImageView.image = metadata.image
            self.metadataUrlTextView.text = self.url.absoluteString
            self.metadataTitleTextView.text = metadata.title ?? ""
            self.metadataDescriptionTextView.text = metadata.desc ?? ""
            self.view.layoutIfNeeded()
        }
    }
}
