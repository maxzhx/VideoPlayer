
//  VideosTableViewController.m
//  video
//
//  Created by Planet1107 on 10/28/11.
//

#import "VideosTableViewController.h"
#import "VideoInfo.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "UIImage.h"

@implementation VideosTableViewController

@synthesize videoInfoArray;
@synthesize tableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{//初始化时

    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {//定义数组
        videoInfoArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle abc.mp4
- (void)newInfo{
    
}
-(void) loadVideo{
    if ([self.title isEqualToString:@"本地视频"]) {
        //        plistPath = [[NSBundle mainBundle] pathForResource:@"videoList" ofType:@"plist"];
        
//        NSLog(@"kkkkkkkkkk");
        NSArray *array=[[NSBundle mainBundle] pathsForResourcesOfType:@"mp4" inDirectory:@""];
        int n=array.count;
        int i;
        for (i = 0; i<n; i++) {
            NSString *fullName=[(NSString *)[array objectAtIndex:i] substringFromIndex:128];
            NSString *title=[fullName substringToIndex:fullName.length-4];
//            NSLog(title);
            VideoInfo *videoInfo = [[VideoInfo alloc] init];
            [videoInfo setVideoTitle:title];
            [videoInfo setVideoExtension:@"mp4"];
            if ([videoInfo isValid]) {
                [videoInfoArray addObject:videoInfo];
            }
            [videoInfo release];
        }
        
        
    }
    else if([self.title isEqualToString:@"优酷"]){
        plistPath = [[NSBundle mainBundle] pathForResource:@"youkuList" ofType:@"plist"];
        NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfFile:plistPath];//读取plist文件信息
        dictionary = [dictionary objectForKey:@"Root"];
        numberOfVideos = [dictionary count];
        
        for (int i = 0; i<numberOfVideos; i++) {
            NSDictionary *rawVideoInfo = [dictionary objectForKey:[NSString stringWithFormat:@"Video%d",i]];
            VideoInfo *videoInfo = [[VideoInfo alloc] init];
            [videoInfo setVideoTitle:[rawVideoInfo objectForKey:@"videoTitle"]];
            [videoInfo setVideoSubtitle:[rawVideoInfo objectForKey:@"videoSubtitle"]];
            [videoInfo setVideoExtension:[rawVideoInfo objectForKey:@"videoExtension"]];
            [videoInfo setVideoLink:[rawVideoInfo objectForKey:@"videoLink"]];
            //        [videoInfo setVideoImageName:[rawVideoInfo objectForKey:@"videoImageName"]];
            //        [videoInfo setVideoImageExtension:[rawVideoInfo objectForKey:@"videoImageExtension"]];
            
            if ([videoInfo isValid]) {
                [videoInfoArray addObject:videoInfo];
            }
            [videoInfo release];
        }
        
    }
    else{
        return;
    }
}
- (void)viewDidLoad
{//界面加载，读取plist里的信息
    [super viewDidLoad];
    //判断是哪个页面
    [self newInfo];
//    NSLog(@"2222");
    [self loadVideo];
//    NSLog(@"3333");
   }

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
//    NSLog(@"renew");
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{//设置行数
    // Return the number of rows in the section.
//    return 4;
    return [videoInfoArray count];
}


//Configuring cell design upon request from table
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{//将video里的视频信息显示到界面
//    NSLog(@"lllllll");
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    UIButton *button = [UIButton alloc];
    if (cell == nil) {
//        NSLog(@"aa");
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
//    NSLog([NSString stringWithFormat:@"%d",indexPath.row]);
    cell.textLabel.text = [[videoInfoArray objectAtIndex:[indexPath row]] videoTitle];
//    NSLog(cell.textLabel.text);
	cell.textLabel.adjustsFontSizeToFitWidth = YES;
	cell.textLabel.font = [UIFont systemFontOfSize:13];
	cell.textLabel.numberOfLines = 1;
    
    cell.detailTextLabel.text = [[videoInfoArray objectAtIndex:[indexPath row]] videoExtension];
	cell.detailTextLabel.adjustsFontSizeToFitWidth = YES;
	cell.detailTextLabel.font = [UIFont systemFontOfSize:11];
	cell.detailTextLabel.numberOfLines = 1;
    
//    if([[videoInfoArray objectAtIndex:[indexPath row]] videoImagePath]){
//        NSLog(@"%@", [[videoInfoArray objectAtIndex:[indexPath row]] videoImagePath]);
        //生成缩略图
        NSURL *url;
        if ([self.title isEqualToString:@"本地视频"]) {
            url= [NSURL fileURLWithPath:[[videoInfoArray objectAtIndex:indexPath.row] videoPath]];
            MPMoviePlayerController *moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:url];
            moviePlayer.shouldAutoplay = NO;
            UIImage *img = [moviePlayer thumbnailImageAtTime:10.0 timeOption:MPMovieTimeOptionNearestKeyFrame];
            
            [cell.imageView setImage:[img TransformtoSize:CGSizeMake(45, 45)]];
        }
//        else if([self.title isEqualToString:@"优酷"]){
//            url= [NSURL URLWithString:[[videoInfoArray objectAtIndex:indexPath.row] videoLink]];
//        }
//        
    
//        [cell.imageView setImage:[UIImage imageWithContentsOfFile:[[videoInfoArray objectAtIndex:[indexPath row]] videoImagePath]]];
//    }

    return cell;
}

- (CGFloat)tableView:(UITableView *)tabelView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 60.0f;
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{//删除
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
//        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];

        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        NSString *theTitle=[[videoInfoArray objectAtIndex:[indexPath row]] videoTitle];
        
        if([fileManager removeItemAtPath:[[NSBundle mainBundle] pathForResource:[[videoInfoArray objectAtIndex:[indexPath row]] videoTitle] ofType:@"mp4"] error:Nil])
        {
            NSLog(@"deleted");
        }

        [videoInfoArray removeObjectAtIndex:[indexPath row]];
//        videoInfoArray = [[NSMutableArray alloc] init];
//        NSLog([NSString stringWithFormat:@"%d",videoInfoArray.count]);

//        NSArray *array=[[NSBundle mainBundle] pathsForResourcesOfType:@"mp4" inDirectory:@""];
//        int n=videoInfoArray.count;
//        int i;
        
//        NSLog([NSString stringWithFormat:@"%d",[indexPath row]] );
//        for (i = 0; i<n; i++) {
//            NSLog([(VideoInfo *)[videoInfoArray objectAtIndex:i]].videoTitle);
//            if ([(VideoInfo *)[videoInfoArray objectAtIndex:i]].videoTitle) {
//                <#statements#>
//            }
//        }
        
        
        [self.tableView reloadData];
        
//        [[NSBundle mainBundle] ]
        
        
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{//用来播放或打开链接

    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSURL *url;
    if ([self.title isEqualToString:@"本地视频"]) {
        url= [NSURL fileURLWithPath:[[videoInfoArray objectAtIndex:indexPath.row] videoPath]];
    }
    else if([self.title isEqualToString:@"优酷"]){
        url= [NSURL URLWithString:[[videoInfoArray objectAtIndex:indexPath.row] videoLink]];
//        [[UIApplication sharedApplication] openURL:url];
//        return;
    }
    else{
        return;
    }
    
    MPMoviePlayerViewController *mpMoviePlayerViewController = [[MPMoviePlayerViewController alloc] initWithContentURL:url];
    
    [mpMoviePlayerViewController.moviePlayer setControlStyle:MPMovieControlStyleFullscreen];
    [mpMoviePlayerViewController setTitle:[[videoInfoArray objectAtIndex:indexPath.row] videoTitle]];
    [mpMoviePlayerViewController.moviePlayer setFullscreen:NO];
//    [mpMoviePlayerViewController.navigationController setNavigationBarHidden:YES];
//    mpMoviePlayerViewController.moviePlayer.scalingMode= MPMovieScalingModeFill;

    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self.navigationController pushViewController:mpMoviePlayerViewController animated:YES];
    
    //在通知中心注册done按钮的事件
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayerDone:)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:nil];
    
//    NSNotificationCenter* notificationCenter = [NSNotificationCenter defaultCenter];
//
//    [ notificationCenter addObserver:self selector:@selector(moviePlayerPreloadFinish:) name:MPMoviePlayerContentPreloadDidFinishNotification object:mpMoviePlayerViewController.moviePlayer ];
    
    
    [mpMoviePlayerViewController release];
} 

- (void) moviePlayerDone:(NSNotification*)notification
{
//    NSLog(@"ffdgfg");
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)dealloc{
    [videoInfoArray release];
    [super dealloc];
}

@end
