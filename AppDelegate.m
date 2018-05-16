//
//  AppDelegate.m
//  ReplayDemo
//
//  Created by Sandwind on 2018/5/16.
//  Copyright © 2018年 Sandwind. All rights reserved.
//

#import "AppDelegate.h"
#import <ReplayKit/ReplayKit.h>
#import "GHReplayKit.h"
#import "ViewController.h"

@interface AppDelegate ()<FJReplayDelegate>
/**start btn*/
@property (nonatomic,strong)UIButton *startBt;
/**end btn*/
@property (nonatomic,strong)UIButton *endBt;
@end

@implementation AppDelegate

-(UIButton*)startBt{
    if(!_startBt){
        _startBt=[[UIButton alloc] initWithFrame:CGRectMake(0,60,80,50)];
        _startBt.backgroundColor=[UIColor redColor];
        [_startBt setTitle:@"start record" forState:UIControlStateNormal];
        _startBt.titleLabel.font=[UIFont systemFontOfSize:14];
        [_startBt addTarget:self action:@selector(startAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _startBt;
}
-(UIButton*)endBt{
    if(!_endBt){
        _endBt=[[UIButton alloc] initWithFrame:CGRectMake(0,120,80,50)];
        _endBt.backgroundColor=[UIColor redColor];
        [_endBt setTitle:@"end record" forState:UIControlStateNormal];
        _endBt.titleLabel.font=[UIFont systemFontOfSize:14];
        [_endBt addTarget:self action:@selector(endAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _endBt;
}
-(void)startAction{
    [_startBt setTitle:@"initialize" forState:UIControlStateNormal];
    
    [[GHReplayKit sharedReplay] startRecord];
}
-(void)endAction{
    [_startBt setTitle:@"start record" forState:UIControlStateNormal];
    [[GHReplayKit sharedReplay] stopRecordAndShowVideoPreviewController:YES];
    
}

-(void)createWindow{
    self.window =[[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor=[UIColor clearColor];
    self.window.windowLevel = UIWindowLevelAlert+1;
    ViewController *vc = [[ViewController alloc]init];
    vc.view.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = vc;
    
    [self.window makeKeyAndVisible];
    [self.window addSubview:self.startBt];
    [self.window addSubview:self.endBt];
}
#pragma mark - FJReplayDelegate
- (void)replayRecordStart
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self->_startBt setTitle:@"isRecording" forState:UIControlStateNormal];
    });

}
- (void)saveSuccess
{
    UIAlertView *alterView = [[UIAlertView alloc]initWithTitle:@"save success" message:@"prompt friendly" delegate:self cancelButtonTitle:nil otherButtonTitles:@"sure", nil];
    alterView.delegate = self;
    [alterView show];
    
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [GHReplayKit sharedReplay].delegate = self;
    [self createWindow];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
