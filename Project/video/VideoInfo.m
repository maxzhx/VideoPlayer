//
//  VideoInfo.m
//  video
//
//  Created by Planet1107 on 10/28/11.
//

#import "VideoInfo.h"
#define subtitleMissing @"Subtitle missing"

@implementation VideoInfo

@synthesize videoTitle;
@synthesize videoSubtitle;
@synthesize videoExtension;
@synthesize videoLink;
@synthesize videoPath;

-(BOOL)isValid{
    //检查文件是否合法

    if ([videoTitle isEqualToString:@""]||([videoExtension isEqualToString:@""]&&[videoLink isEqualToString:@""])) {
        return NO;
    }
    if ([videoSubtitle isEqualToString:@""]) {
        videoSubtitle = subtitleMissing;
    }
    if(videoExtension){
        NSString *resourcePath = [[NSBundle mainBundle] pathForResource:videoTitle ofType:videoExtension];
//        NSLog(@"ddd");
//        NSLog(resourcePath);
        if (resourcePath) {
            videoPath = [[NSString alloc] initWithString:resourcePath];
        }
    }
    
//    if (videoImageName&&videoImageExtension) {
//        NSString *resourcePath = [[NSBundle mainBundle] pathForResource:videoImageName ofType:videoImageExtension];
//        if (resourcePath) {
//            videoImagePath = [[NSString alloc] initWithString:resourcePath];
//        }
//    }
    
    if (videoPath||videoLink) {
        return YES;
    }
    else{
//        NSLog(videoTitle);
        return NO;
    }
}

-(void)dealloc{
    [videoTitle release];
    [videoSubtitle release];
    [videoExtension release];
    [videoLink release];
    [videoPath release];
    [super dealloc];
}

@end
