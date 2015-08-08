//
//  VideoInfo.h
//  video
//
//  Created by Planet1107 on 10/31/11.
//

#import <Foundation/Foundation.h>

@interface VideoInfo : NSObject{
    NSString *videoTitle;
    NSString *videoSubtitle;
    NSString *videoExtension;
    NSString *videoLink;
    NSString *videoPath;
}

@property(nonatomic, copy) NSString *videoTitle;
@property(nonatomic, copy) NSString *videoSubtitle;
@property(nonatomic, copy) NSString *videoExtension;
@property(nonatomic, copy) NSString *videoLink;
@property(nonatomic, copy) NSString *videoPath;
-(BOOL)isValid; //check if all needed resources are available, and tries to fix possible errors.

@end
