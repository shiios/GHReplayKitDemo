//
//  GHReplayKit.m
//  GHReplayKit
//
//  Created by Sandwind on 2018/5/16.
//  Copyright © 2018年 Sandwind. All rights reserved.
//

#import "GHReplayKit.h"

@interface GHReplayKit ()<RPPreviewViewControllerDelegate>

@end
@implementation GHReplayKit
+(instancetype)sharedReplay{
    static GHReplayKit *replay=nil;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        replay=[[GHReplayKit alloc] init];
    });
    return replay;
}
#pragma mark - start record
-(void)startRecord{
    if ([RPScreenRecorder sharedRecorder].recording==YES) {
        return;
    }
    if ([self systemVersionOK]) {
        if ([[RPScreenRecorder sharedRecorder] isAvailable]) {
            [[RPScreenRecorder sharedRecorder] startRecordingWithMicrophoneEnabled:YES handler:^(NSError *error){
                if (error) {
                    if ([self->_delegate respondsToSelector:@selector(replayRecordFinishWithVC:errorInfo:)]) {
                        [self->_delegate replayRecordFinishWithVC:nil errorInfo:[NSString stringWithFormat:@"FJReplayKit:end record error %@",error]];
                    }
                }else{
                    self->_isRecording=YES;
                    if ([self->_delegate respondsToSelector:@selector(replayRecordStart)]) {
                        [self->_delegate replayRecordStart];
                    }
                }
            }];
        }
        else {
            if ([_delegate respondsToSelector:@selector(replayRecordFinishWithVC:errorInfo:)]) {
                [_delegate replayRecordFinishWithVC:nil errorInfo:@"FJReplayKit:envo ReplayKit record"];
            }
        }
    }
    else{
        if ([_delegate respondsToSelector:@selector(replayRecordFinishWithVC:errorInfo:)]) {
            [_delegate replayRecordFinishWithVC:nil errorInfo:@"FJReplayKit:system version need >= iOS9.0"];
        }
    }
}
#pragma mark - end record
-(void)stopRecordAndShowVideoPreviewController:(BOOL)isShow{
    [[RPScreenRecorder sharedRecorder] stopRecordingWithHandler:^(RPPreviewViewController *previewViewController, NSError *  error){
        if (error) {
            if ([self->_delegate respondsToSelector:@selector(replayRecordFinishWithVC:errorInfo:)]) {
                [self->_delegate replayRecordFinishWithVC:nil errorInfo:[NSString stringWithFormat:@"FJReplayKit:end record error %@",error]];
            }
        }
        else {
            self->_isRecording=NO;
            if ([self->_delegate respondsToSelector:@selector(replayRecordFinishWithVC:errorInfo:)]) {
                [self->_delegate replayRecordFinishWithVC:previewViewController errorInfo:@""];
            }
            if (isShow) {
                [self showVideoPreviewController:previewViewController animation:YES];
            }
        }
    }];
}
#pragma mark - show preview
-(void)showVideoPreviewController:(RPPreviewViewController *)previewController animation:(BOOL)animation {
    previewController.previewControllerDelegate=self;
    __weak UIViewController *rootVC=[self getRootVC];
    dispatch_async(dispatch_get_main_queue(), ^{
        CGRect rect = [UIScreen mainScreen].bounds;
        if (animation) {
            rect.origin.x+=rect.size.width;
            previewController.view.frame=rect;
            rect.origin.x-=rect.size.width;
            [UIView animateWithDuration:0.3 animations:^(){
                previewController.view.frame=rect;
            }];
        }
        else{
            previewController.view.frame=rect;
        }
        
        [rootVC.view addSubview:previewController.view];
        [rootVC addChildViewController:previewController];
    });
}
#pragma mark - close preview
-(void)hideVideoPreviewController:(RPPreviewViewController *)previewController animation:(BOOL)animation {
    previewController.previewControllerDelegate=nil;
    dispatch_async(dispatch_get_main_queue(), ^{
        CGRect rect = previewController.view.frame;
        if (animation) {
            rect.origin.x+=rect.size.width;
            [UIView animateWithDuration:0.3 animations:^(){
                previewController.view.frame=rect;
            }completion:^(BOOL finished){
                [previewController.view removeFromSuperview];
                [previewController removeFromParentViewController];
            }];
        }
        else{
            [previewController.view removeFromSuperview];
            [previewController removeFromParentViewController];
        }
    });
}
- (void)previewController:(RPPreviewViewController *)previewController didFinishWithActivityTypes:(NSSet <NSString *> *)activityTypes {
    if ([activityTypes containsObject:@"com.apple.UIKit.activity.SaveToCameraRoll"]) {
        if ([_delegate respondsToSelector:@selector(saveSuccess)]) {
            [_delegate saveSuccess];
        }
    }
    if ([activityTypes containsObject:@"com.apple.UIKit.activity.CopyToPasteboard"]) {
    }
}
#pragma mark - close block
- (void)previewControllerDidFinish:(RPPreviewViewController *)previewController {
    [self hideVideoPreviewController:previewController animation:YES];
}

#pragma mark - judge system version
-(BOOL)systemVersionOK{
    if ([[UIDevice currentDevice].systemVersion floatValue]<9.0) {
        return NO;
    } else {
        return YES;
    }
}
-(UIViewController *)getRootVC{
    return [UIApplication sharedApplication].delegate.window.rootViewController;
}
@end
