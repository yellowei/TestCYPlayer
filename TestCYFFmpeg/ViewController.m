//
//  ViewController.m
//  TestCYFFmpeg
//
//  Created by yellowei on 2021/12/13.
//

#import "ViewController.h"
#import <CYPlayer/CYPlayer.h>
#import <Masonry.h>

@interface ViewController ()
{
    CYFFmpegPlayer * vc1;// 全局化, 便于控制
}

@property (nonatomic, strong) UIView * contentView; //给一个contentView承载播放器的视图, 也可直接add到当前控制器的self.view
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIView * contentView = [UIView new];
    contentView.backgroundColor = [UIColor blackColor];
    self.contentView = contentView;
    [self.view addSubview:contentView];
    //设置自动布局
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.offset(0);
        make.leading.trailing.offset(0);
        make.height.equalTo(contentView.mas_width).multipliedBy(9.0 / 16.0);
    }];
    
    // 初始化播放器
    vc1 = [CYFFmpegPlayer movieViewWithContentPath:@"https://vodplay.com/liveRecord/46eca58c0ccf5b857fa76cb3c9fea487/dentalink-vod/515197938314592256/2020-08-17-12-18-39_2020-08-17-12-48-39.m3u8" parameters:nil];
    [vc1 settingPlayer:^(CYVideoPlayerSettings *settings) {
        settings.definitionTypes = CYFFmpegPlayerDefinitionLLD | CYFFmpegPlayerDefinitionLHD | CYFFmpegPlayerDefinitionLSD | CYFFmpegPlayerDefinitionLUD;
        settings.enableSelections = YES;
        settings.setCurrentSelectionsIndex = ^NSInteger{
            return 3;//假设上次播放到了第四节
        };
        settings.nextAutoPlaySelectionsPath = ^NSString *{
            return @"https://vodplay.com/liveRecord/46eca58c0ccf5b857fa76cb3c9fea487/dentalink-vod/515197938314592256/2020-08-17-12-18-39_2020-08-17-12-48-39.m3u8";
        };
        //        settings.useHWDecompressor = YES;
        //        settings.enableProgressControl = NO;
    }];

    vc1.autoplay = YES;
    vc1.generatPreviewImages = YES;
    [self.contentView addSubview:vc1.view];
    //播放器视图添加到父视图之后,一定要设置播放器视图的frame,不然会导致opengl无法渲染以致播放失败
    [vc1.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.offset(0);
        make.top.bottom.offset(0);
        make.width.equalTo(vc1.view.mas_height).multipliedBy(16.0 / 9.0);
    }];
}

- (void)dealloc
{
    [vc1 stop];//记得要停止播放
}


# pragma mark - 系统横竖屏切换调用

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    if (size.width > size.height)
    {
        [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(@(0));
            make.left.equalTo(@(0));
            make.right.equalTo(@(0));
        }];
    }
    else
    {
        [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.center.offset(0);
            make.leading.trailing.offset(0);
            make.height.equalTo(self.contentView.mas_width).multipliedBy(9.0 / 16.0);
        }];
    }
}


@end
