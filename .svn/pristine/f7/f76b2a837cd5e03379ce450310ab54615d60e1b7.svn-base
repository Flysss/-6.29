//
//  ComposeController.m
//  SalesHelper_A
//
//  Created by 胡伟 on 16/3/3.
//  Copyright © 2016年 X. All rights reserved.
//

#import "HWComposeController.h"
#import "HWEmotionTextView.h"
#import "HWComposeToolBar.h"
#import "HWComposePhotoView.h"
#import "HWEmotionKeyboard.h"
#import "HWEmotion.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "TZImagePickerController.h"
#import "HWPhotoCell.h"
#import "AFHTTPRequestOperationManager.h"
#import "UIBarButtonItem+HW.h"
#import "UIColor+Extend.h"
#import "HWMyFocusListViewController.h"
#import "BHPersonMyFansModel.h"
#import "RegexKitLite.h"
#import <sys/utsname.h>
#import "IQKeyboardManager.h"
#import "ZJForwardView.h"
#import "BHFirstListModel.h"
#import "BHDetailTopModel.h"
#import "BHHuaTiModel.h"

@interface HWComposeController ()<UITextViewDelegate,HWComposeToolBarDelegate,UINavigationControllerDelegate,TZImagePickerControllerDelegate,UICollectionViewDelegate,UICollectionViewDataSource,HWPhotoCellDelegate,UIAlertViewDelegate>

@property (nonatomic,weak) HWEmotionTextView *textView;
@property (nonatomic,weak) HWComposeToolBar *toolBar;
@property (nonatomic,weak) HWComposePhotoView *photoView;
@property (nonatomic,strong) HWEmotionKeyboard *keyboard;

@property (nonatomic, strong) NSString *loginuid;

@property (nonatomic,assign,getter=isChangeKeyboard) BOOL changeKeyboard;


@property (nonatomic,strong) NSMutableArray *mentionArray;

@property (nonatomic,strong) NSMutableArray *modelArray;

@property (nonatomic,strong) NSMutableArray *nameArray;


@property (nonatomic,strong) NSMutableArray *notiArray;
@property (nonatomic,copy) NSString *contents;
@property (nonatomic, strong) NSMutableArray *smallPhotoArr;//小图

@end
@implementation HWComposeController
{
    UICollectionView *_collectionView;
    NSMutableArray *_selectedPhotos;
    NSMutableArray *_selectedAssets;

    
    CGFloat _itemWH;
    CGFloat _margin;
    
}
- (NSMutableArray *)notiArray
{
    if (!_notiArray) {
        _notiArray = [NSMutableArray array];
    }
    return _notiArray;
    
}
- (NSMutableArray *)smallPhotoArr
{
    if (!_smallPhotoArr) {
        _smallPhotoArr = [NSMutableArray array];
    }
    return _smallPhotoArr;
}
- (NSMutableArray *)nameArray
{
    if (!_nameArray) {
        _nameArray = [NSMutableArray array];
    }
    return _nameArray;
    
}
- (NSMutableArray *)modelArray
{
    if (!_modelArray) {
        _modelArray = [NSMutableArray array];
    }
    
    return _modelArray;
    
}

- (NSMutableArray *)mentionArray
{
    if (!_mentionArray) {
        
        _mentionArray = [NSMutableArray array];
    }
    
    return _mentionArray;
}
- (HWEmotionKeyboard *)keyboard
{
    if (!_keyboard) {
        self.keyboard = [HWEmotionKeyboard new];
        self.keyboard.bounds = CGRectMake(0, 0, 320, 256);
        
    }
    
    return _keyboard;
    
}



- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    [self setupNavBar];
    
    [self setupTextView];
    
    [self setForwardView];
    [self setupPhotoView];
    [self setupToolBar];

//    if (self.textView.hasText == YES || _selectedPhotos.count != 0)
//    {
//        self.navigationItem.rightBarButtonItem.enabled = YES;
//    }
//    else
//    {
//        self.navigationItem.rightBarButtonItem.enabled = NO;
//    }
//    
    //添加表情按钮的通知
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(emotionSelected:) name:HWEMotionViewDidSelectedNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clearButtonClick:) name:HWEmotionDidClearButton object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addImageFromCamera:) name:HWImagePickerImage object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mentionSomeOne:) name:HWMentionSomeOneNotie object:nil];
    

    
}


#pragma mark - 点击@，选择之后回来的通知
- (void)mentionSomeOne:(NSNotification *)note
{
    [self.notiArray addObject:note];

     NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithAttributedString:self.textView.attributedText];

    
    BHPersonMyFansModel *model = note.userInfo[HWMenionModel];
    NSString *someOne = [NSString stringWithFormat:@"@%@ ",model.name];
    
    if (![self.mentionArray containsObject:model.uid]) {
        
        NSMutableAttributedString *subStr = [[NSMutableAttributedString alloc] initWithString:someOne];
        [attributedText appendAttributedString:subStr];
        
        [self.mentionArray addObject:model.uid];
    }
    
    [self.nameArray addObject:someOne];
    
    
    NSString *totalStr = [attributedText attributedSubstringFromRange:NSMakeRange(0, attributedText.length)].string;
    NSString *mentionRegex = @"@[a-zA-Z0-9\\u4e00-\\u9fa5\\-_]+";
    [totalStr enumerateStringsMatchedByRegex:mentionRegex usingBlock:^(NSInteger captureCount, NSString *const __unsafe_unretained *capturedStrings, const NSRange *capturedRanges, volatile BOOL *const stop) {
        
        [attributedText addAttribute:NSForegroundColorAttributeName value:HWColor
         (88, 161, 253) range:*capturedRanges];
       [attributedText addAttribute:@"@" value:*capturedStrings range:*capturedRanges];
        
        [attributedText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18] range:*capturedRanges];
        
        
    }];
    
    
    
    self.textView.attributedText = attributedText;
    
//    [self textViewDidChange:self.textView];
    
    
    
    
}


- (void)addImageFromCamera:(NSNotification *)noti
{
    
    
    _collectionView.hidden = NO;
    UIImage *image = noti.userInfo[HWCameraImage];
    
    [_selectedPhotos addObject:image];
    [_collectionView reloadData];
    _collectionView.contentSize = CGSizeMake(0, ((_selectedPhotos.count + 2) / 3 ) * (_margin + _itemWH));
    
}

- (void)clearButtonClick:(NSNotification *)note
{
    
    [self.textView deleteBackward];
    
}
#pragma mark-点击表情后的通知
- (void)emotionSelected:(NSNotification *)note;
{
    HWEmotion *emotion = note.userInfo[HWEmotionViewEmotion];
    [self.textView appendEmotion:emotion];
    [self textViewDidChange:self.textView];
}
#pragma mark -转发的视图
- (void)setForwardView
{
    ZJForwardView *forward = [[ZJForwardView alloc]init];
    _margin = 5;
    forward.frame = CGRectMake(_margin, 150, self.view.width - _margin*2, 60);
    forward.isPosting = YES;
    
    
    if ([_InterfaceDistinguish isEqualToString:@"1"])
    {
        if (_model.forward) {
            forward.dic = _model.forward;
            
            [self.mentionArray addObjectsFromArray:_forward_uid];
        }
        else
        {
            if (_model.subject_id) {
                NSDictionary *dic = @{@"imgpath":_model.imgpath,@"name":_model.name,@"contents":_model.contents,@"topic":_model.subject_id[@"topic"]};
                forward.dic = dic;
            }
            else
            {
                NSDictionary *dic = @{@"imgpath":_model.imgpath,@"name":_model.name,@"contents":_model.contents};
               
                forward.dic = dic;
            }
        }
    }
    else if ([_InterfaceDistinguish isEqualToString:@"2"])
    {
        NSLog(@"%@",_detailModel.forward);
        if (_detailModel.forward) {
            forward.dic = _detailModel.forward;
        }
        else
        {
            if (_detailModel.subject_id) {
                NSDictionary *dic = @{@"imgpath":_detailModel.imgpath,@"name":_detailModel.name,@"contents":_detailModel.contents,@"topic":_detailModel.subject_id[@"topic"]};
                forward.dic = dic;
            }
            else
            {
                NSDictionary *dic = @{@"imgpath":_detailModel.imgpath,@"name":_detailModel.name,@"contents":_detailModel.contents};
                forward.dic = dic;
                if ([_detailModel.type isEqualToString:@"2"]) {
                    forward.lblForwardName.text = @"销邦公告";
                }else if ([_detailModel.type isEqualToString:@"5"])
                {
                    forward.lblForwardName.text = @"销邦邦学院";
                }
            }
            
        }
        
    }
    else if ([_InterfaceDistinguish isEqualToString:@"3"])
    {
        if (_huatiModel.forward)
        {
            forward.dic = _huatiModel.forward;
        }
        else
        {
            if (_huatiModel.subject_id) {
                NSDictionary *dic = @{@"imgpath":_huatiModel.imgpath,@"name":_huatiModel.name,@"contents":_huatiModel.contents,@"topic":_huatiModel.subject_id[@"topic"]};
                forward.dic = dic;
            }
            else
            {
                NSDictionary *dic = @{@"imgpath":_huatiModel.imgpath,@"name":_huatiModel.name,@"contents":_huatiModel.contents};
                forward.dic = dic;
            }
        }
        
    }
    
    
    
    [self.view addSubview:forward];
    if (_isForward == YES)
    {
        forward.hidden = NO;
    }
    else
    {
        forward.hidden = YES;
    }
}

- (void)setupPhotoView
{

    _selectedPhotos = [NSMutableArray array];
    _selectedAssets = [NSMutableArray array];
    
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    _margin = 5;
    _itemWH = (self.view.width - 4 * _margin) / 3;
    layout.itemSize = CGSizeMake(_itemWH, _itemWH);
    layout.minimumInteritemSpacing = _margin;
    layout.minimumLineSpacing = _margin;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 150, self.view.width -  _margin, 400) collectionViewLayout:layout];
    _collectionView.contentInset = UIEdgeInsetsMake(3, 3, 3, 3);

    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.hidden = YES;
    _collectionView.width = self.textView.width;
    _collectionView.height = self.textView.height;
    [self.view addSubview:_collectionView];
    [_collectionView registerClass:[HWPhotoCell class] forCellWithReuseIdentifier:@"HWPhotoCell"];
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *selectedPhotos = [defaults objectForKey:@"selectedPhotos"];
    if (selectedPhotos.count > 0) {
        NSMutableArray *arr = [NSMutableArray array];
        for (int i = 0 ; i < selectedPhotos.count; i++)
        {
            UIImage *image = [UIImage imageWithData:selectedPhotos[i]];
            [arr addObject:image];
        }
        _selectedPhotos = arr;
        self.smallPhotoArr = [arr mutableCopy];
        _collectionView.hidden = NO;
    }


}
- (void)setupToolBar
{
    HWComposeToolBar *toolBar = [HWComposeToolBar new];
    toolBar.width = self.view.width;
    toolBar.height = 44;
    toolBar.delegate = self;
    self.toolBar = toolBar;
    if (_isForward == YES) {
        
        toolBar.isForward = YES;
    }
    toolBar.y = self.view.height - toolBar.height - 64;
    
    [self.view insertSubview:toolBar aboveSubview:_collectionView ];
    
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[self imageWithBgColor:[UIColor colorWithRed:23/255.0f green:183/255.0f blue:242/255.0f alpha:1]] forBarMetrics:UIBarMetricsDefault];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *longinuid =  [defaults objectForKey:@"id"];
    self.loginuid = [NSString stringWithFormat:@"%@",longinuid];
}
- (void)composeTool:(HWComposeToolBar *)composeTool didClickButton:(HWComposeToolbarButtonType)type
{
    
    switch (type) {
        case HWComposeToolbarButtonTypePicture:
            [self openPicture];
            break;
        case HWComposeToolbarButtonTypeEmotion:
            [self openEmotion];
            break;
        case HWComposeToolbarButtonTypeMention:
             [self openMentionList];
            break;
            break;
            
    }
    
    
}


- (void)openMentionList
{
    HWMyFocusListViewController *focus = [[HWMyFocusListViewController alloc] init];
    
    focus.loginuid = self.loginuid;
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:focus];
    
    [self presentViewController:nav animated:YES completion:nil];
    
    
    
}
- (void)openEmotion
{
    
    
    self.changeKeyboard = YES;
    if (self.textView.inputView) {
        self.textView.inputView = nil;
        self.toolBar.showEmotionButton = NO;
        
    }else{
        self.toolBar.showEmotionButton = YES;
        self.textView.inputView = self.keyboard;
        
    }
    
    [self.textView resignFirstResponder];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self.textView becomeFirstResponder];
        
    });
    
    
    
    
    
    
}

- (void)openPicture
{
    
   
    
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:9 delegate:self];
    
    // You can get the photos by block, the same as by delegate.
    // 你可以通过block或者代理，来得到用户选择的照片.
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets) {
        
        
    }];
    
    // Set the appearance
    // 在这里设置imagePickerVc的外观
    // imagePickerVc.navigationBar.barTintColor = [UIColor greenColor];
    // imagePickerVc.oKButtonTitleColorDisabled = [UIColor lightGrayColor];
    // imagePickerVc.oKButtonTitleColorNormal = [UIColor greenColor];
    
    // Set allow picking video & originalPhoto or not
    // 设置是否可以选择视频/原图
    // imagePickerVc.allowPickingVideo = NO;
    // imagePickerVc.allowPickingOriginalPhoto = NO;
    
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

#pragma mark TZImagePickerControllerDelegate

/// User click cancel button
/// 用户点击了取消
- (void)imagePickerControllerDidCancel:(TZImagePickerController *)picker {
    // NSLog(@"cancel");
}

/// User finish picking photo，if assets are not empty, user picking original photo.
/// 用户选择好了图片，如果assets非空，则用户选择了原图。
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray *)photos sourceAssets:(NSArray *)assets{
     _collectionView.hidden = NO;
    [_selectedPhotos addObjectsFromArray:photos];
    
    for (UIImage *image in photos)
    {
        if (image.size.width > 300 || image.size.height > 300)
        {
            UIImage *smallImg = [self ImageWithImageSimple:image ScaledToSize:CGSizeMake(image.size.width/3, image.size.height/3)];
            [self.smallPhotoArr addObject:smallImg];
        }
        else
        {
            [self.smallPhotoArr addObject:image];
        }
    }
    
    [_collectionView reloadData];
    _collectionView.contentSize = CGSizeMake(0, ((_selectedPhotos.count + 2) / 3 ) * (_margin + _itemWH));
}

/// User finish picking video,
/// 用户选择好了视频
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingVideo:(UIImage *)coverImage sourceAssets:(id)asset {
    [_selectedPhotos addObjectsFromArray:@[coverImage]];
    [_collectionView reloadData];
    _collectionView.contentSize = CGSizeMake(0, ((_selectedPhotos.count + 2) / 3 ) * (_margin + _itemWH));
}


- (void)setupTextView
{
    HWEmotionTextView *textView = [HWEmotionTextView new];
    textView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 150);
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *text = [defaults objectForKey:@"postText"];
    
    NSArray *notArray = [defaults objectForKey:@"notiArray"];
    
    for (NSDictionary *dic in notArray) {
        [self.mentionArray addObjectsFromArray:dic[@"mentionArr"]];
        [self.nameArray addObjectsFromArray:dic[@"nameArr"]];
    }
    
    if (_circle_id != nil)
    {
        textView.placeholder = @"说说今天的心情";
    }
    
    if (_isForward == YES)
    {
        if ([_forwardTitle isEqualToString:@"转发"]) {
            textView.placeholder = _forwardTitle;
        }
        else
        {
            textView.text = _forwardTitle;
        }
    }
    else
    {
        textView.placeholder = @"说说今天的心情";
    }
    
    if (_subject_id != nil)
    {
        textView.placeholder = [NSString stringWithFormat:@"#%@#",_subjectTitle];
    }
    
    
    if (text != nil) {

        NSMutableAttributedString *attributedText =  [[NSMutableAttributedString alloc] initWithString:text];
        
        NSString *totalStr = [attributedText attributedSubstringFromRange:NSMakeRange(0, attributedText.length)].string;
        NSString *mentionRegex = @"@[a-zA-Z0-9\\u4e00-\\u9fa5\\-_]+";
        [totalStr enumerateStringsMatchedByRegex:mentionRegex usingBlock:^(NSInteger captureCount, NSString *const __unsafe_unretained *capturedStrings, const NSRange *capturedRanges, volatile BOOL *const stop) {
            
            [attributedText addAttribute:NSForegroundColorAttributeName value:HWColor
             (88, 161, 253) range:*capturedRanges];
            [attributedText addAttribute:@"@" value:*capturedStrings range:*capturedRanges];
            
            [attributedText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18] range:*capturedRanges];
            
        }];
        
        //文字转换成表情----------------------------
        //加载plist文件中的数据
        NSBundle *bundle = [NSBundle mainBundle];
        //寻找资源的路径
        NSString *path = [bundle pathForResource:@"HWemoji1" ofType:@"plist"];
        //获取plist中的数据
        NSArray *face = [[NSArray alloc] initWithContentsOfFile:path];
        
        NSString * pattern = @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]";
        NSError *error = nil;
        NSRegularExpression * re = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];
        
        if (!re) {
            NSLog(@"%@", [error localizedDescription]);
        }
        //    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithString:attributedText.string];
        //通过正则表达式来匹配字符串
        NSArray *resultArray = [re matchesInString:attributedText.string options:0 range:NSMakeRange(0, attributedText.length)];
        
        //用来存放字典，字典中存储的是图片和图片对应的位置
        NSMutableArray *imageArray = [NSMutableArray arrayWithCapacity:resultArray.count];
        
        //根据匹配范围来用图片进行相应的替换
        for(NSTextCheckingResult *match in resultArray) {
            //获取数组元素中得到range
            NSRange range = [match range];
            
            //获取原字符串中对应的值
            NSString *subStr = [attributedText.string substringWithRange:range];
            
            for (int i = 0; i < face.count; i ++)
            {
                if ([face[i][@"chs"] isEqualToString:subStr])
                {
                    
                    //face[i][@"gif"]就是我们要加载的图片
                    //新建文字附件来存放我们的图片
                    NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
                    
                    //给附件添加图片
                    textAttachment.image = [UIImage imageNamed:face[i][@"png"]];
                    textAttachment.bounds = CGRectMake(0, -3, [UIFont systemFontOfSize:17].lineHeight, [UIFont systemFontOfSize:17].lineHeight);
                    //把附件转换成可变字符串，用于替换掉源字符串中的表情文字
                    NSAttributedString *imageStr = [NSAttributedString attributedStringWithAttachment:textAttachment];
                    
                    //把图片和图片对应的位置存入字典中
                    NSMutableDictionary *imageDic = [NSMutableDictionary dictionaryWithCapacity:2];
                    [imageDic setObject:imageStr forKey:@"image"];
                    [imageDic setObject:[NSValue valueWithRange:range] forKey:@"range"];
                    
                    //把字典存入数组中
                    [imageArray addObject:imageDic];
                    
                }
            }
        }
        //从后往前替换
        for (NSInteger j = imageArray.count -1; j >= 0; j--)
        {
            NSRange range;
            [imageArray[j][@"range"] getValue:&range];
            //进行替换
            [attributedText replaceCharactersInRange:range withAttributedString:imageArray[j][@"image"]];
            
        }
        
        
        textView.attributedText = attributedText;
    }
    textView.font = [UIFont systemFontOfSize:17];
    self.textView = textView;
    textView.delegate = self;
    
    [self.view addSubview:textView];
    
    
    [self textViewDidChange:self.textView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    // 键盘即将隐藏, 就会发出UIKeyboardWillHideNotification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
  
    
    
    [self textViewDidChange:self.textView];
    
}

- (void)keyboardWillShow:(NSNotification *)note
{
    
    
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    CGFloat offY = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    
    
    
    [UIView animateWithDuration:duration animations:^{
        self.changeKeyboard = NO;
        
        self.toolBar.transform = CGAffineTransformMakeTranslation(0, -offY);
        
    }];
    
}

- (void)keyboardWillHide:(NSNotification *)note
{
    if (self.isChangeKeyboard) {
        self.changeKeyboard = NO;
        return;
        
    }
    
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    [UIView animateWithDuration:duration animations:^{
        
        self.toolBar.transform = CGAffineTransformIdentity;
        
    }];
    
    
    
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.textView resignFirstResponder];
    
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
    manager.shouldResignOnTouchOutside = YES;
    manager.shouldToolbarUsesTextFieldTintColor = YES;
    manager.enableAutoToolbar = NO;
    
}
- (void)viewDidAppear:(BOOL)animated
{
    
    [super viewDidAppear:animated];
    [self.textView becomeFirstResponder];
    if (_isForward == YES) {
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }else
    {
        self.navigationItem.rightBarButtonItem.enabled = _selectedPhotos.count > 0 || self.textView.hasText;
    }
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
    for (int i = 0; i < self.nameArray.count; i++) {
        
        if([textView.attributedText.string rangeOfString:self.nameArray[i]].location !=NSNotFound)//_roaldSearchText
        {
            NSLog(@"yes");
        }
        else
        {
            [self.nameArray removeObjectAtIndex:i];
            [self.mentionArray removeObjectAtIndex:i];
        }
    }
    
    
    
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    
    
    
//   
//    NSMutableAttributedString *attributed = [[NSMutableAttributedString alloc] initWithAttributedString:self.textView.attributedText];
//    
//    [attributed addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18] range:NSMakeRange(0, attributed.length)];
//    
//    self.textView.attributedText = attributed;
 
    if (_isForward == YES) {
        
    }
    else
    {
        self.navigationItem.rightBarButtonItem.enabled = textView.hasText || _selectedPhotos.count > 0 || textView.attributedText.length != 0;
        
    }
    
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    
    [self.view endEditing:YES];
    
    
}


- (void)setupNavBar
{
    

    //创建标题
    UILabel * titleLabel = [UILabel new];
    if (_isForward == YES)
    {
        titleLabel.text = @"转发";
    }
    else
    {
        titleLabel.text = @"发帖";
    }
    titleLabel.font = Default_Font_18;
    [titleLabel setTextColor:[UIColor whiteColor]];
    [titleLabel sizeToFit];
    self.navigationItem.titleView = titleLabel;

    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"返回" heighImage:@"返回" target:self action:@selector(cancelClick)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发送" style:UIBarButtonItemStyleDone target:self action:@selector(send:)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
    

}
#pragma mark -返回按钮事件
- (void)cancelClick
{
    
    if (self.textView.hasText == YES || _selectedPhotos.count != 0) {
        [self zanErrorAlertView:@"温馨提示" message:@"您尚有未发布的信息，是否保存为草稿？"];
    }else
    {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults removeObjectForKey:@"postText"];
        [defaults removeObjectForKey:@"notiArray"];
        [defaults removeObjectForKey:@"selectedPhotos"];
       
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
}
- (void)send:(UIBarButtonItem *)item
{
    if (_selectedPhotos.count) {
        
        [self sendStatusWithImage];
        
    }else{
        
        [self sendStatusWithOutImage];
    }
    
    [self.view Loading:@"发送中"];
    item.enabled = NO;
}
#pragma mark - 点赞失败的提示
- (void)zanErrorAlertView:(NSString *)title message:(NSString *)message
{
    if ([[[UIDevice currentDevice]systemVersion] integerValue] >= 8.0)
    {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:[self.textView realText] forKey:@"postText"];
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            [dic setValue:self.nameArray forKey:@"nameArr"];
            [dic setValue:self.mentionArray forKey:@"mentionArr"];
            [self.modelArray addObject:dic];
            [defaults setObject:self.modelArray forKey:@"notiArray"];
            NSMutableArray *selectedPhotos = [NSMutableArray array];
           
            if (self.smallPhotoArr.count > 0) {
                for (int i = 0 ; i < self.smallPhotoArr.count; i++) {
                    
                    UIImage *imgae = self.smallPhotoArr[i];
                    NSData *data = UIImagePNGRepresentation(imgae);
                    [selectedPhotos addObject:data];
                }
                [defaults setObject:selectedPhotos forKey:@"selectedPhotos"];
            }
            
            [defaults synchronize];
            
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults removeObjectForKey:@"postText"];
            [defaults removeObjectForKey:@"notiArray"];
            [defaults removeObjectForKey:@"selectedPhotos"];
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
        [alert addAction:action1];
        [alert addAction:action2];
        [self presentViewController:alert animated:YES completion:^{
            
        }];
    }else
    {
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:title message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
        alert.delegate = self;
        [alert show];
    }
}
//压缩图片
-(UIImage*)ImageWithImageSimple:(UIImage*)image ScaledToSize:(CGSize)newSize{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    UIGraphicsEndImageContext();
    
    // Return the new image.
    return newImage;
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:[self.textView realText] forKey:@"postText"];
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setValue:self.nameArray forKey:@"nameArr"];
        [dic setValue:self.mentionArray forKey:@"mentionArr"];
        [self.modelArray addObject:dic];
         [defaults setObject:self.notiArray forKey:@"notiArray"];
        
        NSMutableArray *selectedPhotos = [NSMutableArray array];
        if (self.smallPhotoArr.count > 0) {
            for (int i = 0 ; i < self.smallPhotoArr.count; i++) {
                
                UIImage *imgae = self.smallPhotoArr[i];
                NSData *data = UIImagePNGRepresentation(imgae);
                [selectedPhotos addObject:data];
            }
            [defaults setObject:selectedPhotos forKey:@"selectedPhotos"];
        }

         [defaults synchronize];
        [self dismissViewControllerAnimated:YES completion:nil];
    }else if (buttonIndex == 1)
    {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults removeObjectForKey:@"postText"];
        [defaults removeObjectForKey:@"notiArray"];
        [defaults removeObjectForKey:@"selectedPhotos"];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
}




- (void)sendStatusWithImage
{
    
    NSString *deve = [HWComposeController deviceVersion];

    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSMutableDictionary *parame = [NSMutableDictionary dictionary];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *city = [defaults objectForKey:@"location_City"];
    parame[@"city"] = city;
    parame[@"loginuid"] = self.loginuid;
    if (_subject_id != nil) {
        parame[@"subject_id"] = _subject_id;
    }
    
    if (_circle_id != nil) {
        parame[@"circle_id"] = _circle_id;
    }
   
    parame[@"source"] = deve;
    
    self.contents = [self.textView.attributedText attributedSubstringFromRange:NSMakeRange(0, self.textView.attributedText.length)].string;
    
    
    [self.textView.attributedText enumerateAttributesInRange:NSMakeRange(0, self.textView.attributedText.length) options:0 usingBlock:^(NSDictionary<NSString *,id> * _Nonnull attrs, NSRange range, BOOL * _Nonnull stop) {
        
        
        NSString *str = attrs[@"@"];
        
        for (BHPersonMyFansModel *model in self.modelArray) {
            
            NSString *name = [NSString stringWithFormat:@"@%@",model.name];
            if ([str isEqualToString:name]) {
                
                NSString *uid = [NSString stringWithFormat:@"@%@",model.uid];
                
                self.contents = [self.contents stringByReplacingOccurrencesOfString:name withString:uid];
                
            
            }
            
            
        }
        
        
        
        
    }];
    

    
    HWLog(@"%@",self.contents);
    parame[@"contents"] = self.contents;
    
    if (self.mentionArray.count) {
        
        
        NSMutableString *usercalls = [NSMutableString string];
        for (NSUInteger i = 0; i < self.mentionArray.count; i++) {
            
            NSMutableString *str =  [NSMutableString stringWithString:self.mentionArray[i]];
            if (i != self.mentionArray.count - 1) {
                
                [str appendString:@","];
            }
            
            
            [usercalls appendString:str];
            
            
        }
        
        HWLog(@"%@",usercalls);
        parame[@"usercalls"] = usercalls;
        
    }
    NSMutableArray *imgwh = [NSMutableArray array];
    for (int i = 0; i < _selectedPhotos.count; i++)
    {
        UIImage *image = _selectedPhotos[i];
        
        [imgwh addObject: @(image.size.width)];
        [imgwh addObject: @(image.size.height)];
    }
    parame[@"imgwh"] = imgwh;
    NSString *url = [NSString stringWithFormat:@"%@/index.php/Apis/Forum/setRelease/",BANGHUI_URL];

    [manager POST:url parameters:parame constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        
        for (NSUInteger i = 0; i < _selectedPhotos.count; i++) {
        
            UIImage *image = _selectedPhotos[i];
            NSData *data = UIImageJPEGRepresentation(image, 0.5);
            
            NSString *fileName = [NSString stringWithFormat:@"FaTie_%lu.jpg",(unsigned long)i + 1];
            NSString *picName = [NSString stringWithFormat:@"picName%lu",(unsigned long)i];
            [formData appendPartWithFileData:data name:picName fileName:fileName mimeType:@"image/jpeg"];
        }

        
    } success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        [self.view Hidden];
        [self dismissViewControllerAnimated:YES completion:nil];
        NSLog(@"%@",responseObject);
        NSNotificationCenter *noti = [NSNotificationCenter defaultCenter];
        NSNotification *no = [NSNotification notificationWithName:@"refreshTablew" object:nil];
        [noti postNotification:no];
        
        //删除草稿
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults removeObjectForKey:@"postText"];
        [defaults removeObjectForKey:@"notiArray"];
        [defaults removeObjectForKey:@"selectedPhotos"];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {

        [self.view Hidden];
        [self.view Message:@"发送失败" HiddenAfterDelay:3];
        
    }];
    
    
    
    
}
- (void)sendStatusWithOutImage
{
    
    
    NSString *deve = [HWComposeController deviceVersion];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSMutableDictionary *parame = [NSMutableDictionary dictionary];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *city = [defaults objectForKey:@"location_City"];
    parame[@"city"] = city;
    parame[@"loginuid"] = self.loginuid;
    
    
    if (_subject_id != nil) {
        parame[@"subject_id"] = _subject_id;
    }
    
    if (_circle_id != nil) {
        parame[@"circle_id"] = _circle_id;
    }
    
    if (_isForward == YES) {
        parame[@"super_id"] = _forward_id;
        
    }
    parame[@"source"] = deve;

    
    
//    self.contents = [self.textView.attributedText attributedSubstringFromRange:NSMakeRange(0, self.textView.attributedText.length)].string;
    self.contents = [self.textView realText];
    
    [self.textView.attributedText enumerateAttributesInRange:NSMakeRange(0, self.textView.attributedText.length) options:0 usingBlock:^(NSDictionary<NSString *,id> * _Nonnull attrs, NSRange range, BOOL * _Nonnull stop) {
        
        
        NSString *str = attrs[@"@"];
    
        for (BHPersonMyFansModel *model in self.modelArray) {
            
            NSString *name = [NSString stringWithFormat:@"@%@",model.name];
            if ([str isEqualToString:name]) {
                
                NSString *uid = [NSString stringWithFormat:@"@%@",model.uid];
            
               self.contents = [self.contents stringByReplacingOccurrencesOfString:name withString:uid];
             
                
                
                
            }
        
        
        }
        
        
        

    }];
    
    if (self.contents.length == 0) {
        self.contents = @"转发";
    }
    
    
    
    parame[@"contents"] = self.contents;
    if (self.mentionArray.count) {
        
        NSLog(@"%@",self.mentionArray);
        NSMutableString *usercalls = [NSMutableString string];
        for (NSUInteger i = 0; i < self.mentionArray.count; i++) {
            
            NSMutableString *str =  [NSMutableString stringWithString:self.mentionArray[i]];
            if (i != self.mentionArray.count - 1) {
                
                [str appendString:@","];
            }
           

            [usercalls appendString:str];
        
        
        }

        HWLog(@"%@",usercalls);
        parame[@"usercalls"] = usercalls;
        
    }

    NSString *url = [NSString stringWithFormat:@"%@/index.php/Apis/Forum/setRelease2/",BANGHUI_URL];
    [manager POST:url parameters:parame success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.view Hidden];
        [self dismissViewControllerAnimated:YES completion:nil];
        NSLog(@"%@",responseObject);
        NSNotificationCenter *noti = [NSNotificationCenter defaultCenter];
        NSNotification *no = [NSNotification notificationWithName:@"refreshTablew" object:nil];
        [noti postNotification:no];
        //删除草稿
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults removeObjectForKey:@"postText"];
        [defaults removeObjectForKey:@"notiArray"];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.view Hidden];
        [self.view Message:@"发送失败" HiddenAfterDelay:3];
    }];
    
    
}


#pragma mark UICollectionView

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _selectedPhotos.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HWPhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HWPhotoCell" forIndexPath:indexPath];
    
    cell.delegate = self;
    if (indexPath.row == _selectedPhotos.count) {
        cell.imageView.image = [UIImage imageNamed:@"添加"];
          cell.deleteButton.hidden = YES;
    } else {
        cell.imageView.image = _selectedPhotos[indexPath.row];
        cell.indexPath = indexPath;
        cell.deleteButton.hidden = NO;
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
 
    if (indexPath.row == _selectedPhotos.count){
    
        [self openPicture];
    }else{
        
        [self openPicture];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [_selectedPhotos removeObjectAtIndex:indexPath.row];
            [self.smallPhotoArr removeObjectAtIndex:indexPath.row];
            [_collectionView reloadData];
            
        });
        }
}




#pragma mark  绘制图片
- (UIImage *)imageWithBgColor:(UIColor *)color {
    
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    
    UIGraphicsBeginImageContext(rect.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    return image;
}

- (void)photoCellDeleteButtonDidClick:(HWPhotoCell *)photoCell
{
    
    [_selectedPhotos removeObjectAtIndex:photoCell.indexPath.row];
    [self.smallPhotoArr removeObjectAtIndex:photoCell.indexPath.row];
    [_collectionView reloadData];

    
}

//- (void)currentDevice
//{
//    NSString * strModel  = [UIDevice currentDevice].model;
//    NSLog(@"%@",strModel);
//}

+ (NSString*)deviceVersion
{
    // 需要#import "sys/utsname.h"
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    //iPhone
    if ([deviceString isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
    if ([deviceString isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([deviceString isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([deviceString isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([deviceString isEqualToString:@"iPhone3,2"])    return @"Verizon iPhone 4";
    if ([deviceString isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([deviceString isEqualToString:@"iPhone5,1"])    return @"iPhone 5";
    if ([deviceString isEqualToString:@"iPhone5,2"])    return @"iPhone 5";
    if ([deviceString isEqualToString:@"iPhone5,3"])    return @"iPhone 5C";
    if ([deviceString isEqualToString:@"iPhone5,4"])    return @"iPhone 5C";
    if ([deviceString isEqualToString:@"iPhone6,1"])    return @"iPhone 5S";
    if ([deviceString isEqualToString:@"iPhone6,2"])    return @"iPhone 5S";
    if ([deviceString isEqualToString:@"iPhone7,1"])    return @"iPhone 6 Plus";
    if ([deviceString isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
    if ([deviceString isEqualToString:@"iPhone8,1"])    return @"iPhone 6s";
    if ([deviceString isEqualToString:@"iPhone8,2"])    return @"iPhone 6s Plus";
    
    //iPod
    
    　　if ([deviceString isEqualToString:@"iPod1,1"]) return @"iPod Touch 1G";
    　　if ([deviceString isEqualToString:@"iPod2,1"]) return @"iPod Touch 2G";
    　　if ([deviceString isEqualToString:@"iPod3,1"]) return @"iPod Touch 3G";
    　　if ([deviceString isEqualToString:@"iPod4,1"]) return @"iPod Touch 4G";
    　　if ([deviceString isEqualToString:@"iPod5,1"]) return @"iPod Touch 5G";
    　　//iPad
    if ([deviceString isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([deviceString isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    if ([deviceString isEqualToString:@"iPad2,2"])      return @"iPad 2 (GSM)";
    if ([deviceString isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    if ([deviceString isEqualToString:@"iPad2,4"])      return @"iPad 2 (32nm)";
    if ([deviceString isEqualToString:@"iPad2,5"])      return @"iPad mini (WiFi)";
    if ([deviceString isEqualToString:@"iPad2,6"])      return @"iPad mini (GSM)";
    if ([deviceString isEqualToString:@"iPad2,7"])      return @"iPad mini (CDMA)";
    
    if ([deviceString isEqualToString:@"iPad3,1"])      return @"iPad 3(WiFi)";
    if ([deviceString isEqualToString:@"iPad3,2"])      return @"iPad 3(CDMA)";
    if ([deviceString isEqualToString:@"iPad3,3"])      return @"iPad 3(4G)";
    if ([deviceString isEqualToString:@"iPad3,4"])      return @"iPad 4 (WiFi)";
    if ([deviceString isEqualToString:@"iPad3,5"])      return @"iPad 4 (4G)";
    if ([deviceString isEqualToString:@"iPad3,6"])      return @"iPad 4 (CDMA)";
    
    if ([deviceString isEqualToString:@"iPad4,1"])      return @"iPad Air";
    if ([deviceString isEqualToString:@"iPad4,2"])      return @"iPad Air";
    if ([deviceString isEqualToString:@"iPad4,3"])      return @"iPad Air";
    if ([deviceString isEqualToString:@"iPad5,3"])      return @"iPad Air 2";
    if ([deviceString isEqualToString:@"iPad5,4"])      return @"iPad Air 2";
    if ([deviceString isEqualToString:@"i386"])         return @"Simulator";
    if ([deviceString isEqualToString:@"x86_64"])       return @"Simulator";
    
    if ([deviceString isEqualToString:@"iPad4,4"]||[deviceString isEqualToString:@"iPad4,5"]||[deviceString isEqualToString:@"iPad4,6"]) return @"iPad mini 2";
　 if ([deviceString isEqualToString:@"iPad4,7"]||[deviceString isEqualToString:@"iPad4,8"]||[deviceString isEqualToString:@"iPad4,9"])  return @"iPad mini 3";
    
    　return deviceString;
}
//#pragma mark - 提示
//- (void)alertView:(NSString *)title message:(NSString *)message
//{
//    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:(UIAlertControllerStyleAlert)];
//
//    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
//        
//    }];
//    [alert addAction:action];
//    
//    [self presentViewController:alert animated:YES completion:^{
//        
//    }];
//    dispatch_after(1, dispatch_get_main_queue(), ^{
//        [self dismissViewControllerAnimated:YES completion:nil];
//    });
//}


@end
