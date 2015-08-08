//
//  VideosTableViewController.h
//  video
//
//  Created by Planet1107 on 10/31/11.
//

#import <UIKit/UIKit.h>

@interface VideosTableViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
    NSMutableArray *videoInfoArray;
    UITableView *tableView;
    int numberOfVideos;
    NSString *plistPath;
}

@property (assign) NSMutableArray *videoInfoArray;
@property (retain) IBOutlet UITableView *tableView;

@end
