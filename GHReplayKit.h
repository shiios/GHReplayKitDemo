//
//  GHReplayKit.h
//  GHReplayKit
//
//  Created by Sandwind on 2018/5/16.
//  Copyright © 2018年 Sandwind. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <ReplayKit/ReplayKit.h>

@protocol FJReplayDelegate <NSObject>
@optional
/**
 *  start record block
 */
-(void)replayRecordStart;
/**
 *  end record or error block
 */
-(void)replayRecordFinishWithVC:(RPPreviewViewController *)previewViewController errorInfo:(NSString *)errorInfo;
/**
 *  save to photos
 */
-(void)saveSuccess;

@end
@interface GHReplayKit : NSObject
@property (nonatomic,weak) id <FJReplayDelegate> delegate;

+(instancetype)sharedReplay;
/**
 *  isrecording or not
 */
@property (nonatomic,assign) BOOL isRecording;
#pragma mark - start record
- (void)startRecord;

#pragma mark - end record
/**
 * end record
 *  isShow preview
 */
-(void)stopRecordAndShowVideoPreviewController:(BOOL)isShow;

@end
