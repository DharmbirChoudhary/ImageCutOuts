//
//  MenuViewController.m
//  ImageCutOut
//
//  Created by Kseniya Kalyuk Zito on 1/20/14.
//  Copyright (c) 2014 KZito. All rights reserved.
//

#import "MenuViewController.h"
#import "ImagePieceReadWrite.h"
#import "SideMenuViewController.h"
#import "CollageViewController.h"

static NSString * const kMenuTableViewCellIdentifier = @"menuCell";

@interface MenuViewController ()

@property (nonatomic) IBOutlet UILabel *noPiecesLbl;
@property (nonatomic, strong) NSArray *allPiecesArray;

@end

@implementation MenuViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	[self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kMenuTableViewCellIdentifier];
    
    [self updateMenu];
}

-(void)updateMenu
{
    self.allPiecesArray = [[ImagePieceReadWrite sharedClient] thumbnailsNames];
    
    //if pieces available show list of them in table view, if not show label saying that there are no pieces
    
    if ((self.allPiecesArray)&&(self.allPiecesArray.count >0))
    {
        [self.tableView reloadData];
        self.noPiecesLbl.hidden = YES;
    }
    else
    {
        self.noPiecesLbl.hidden = NO;
    }
}


#pragma mark UITableViewDataSourse

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.allPiecesArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kMenuTableViewCellIdentifier forIndexPath:indexPath];
    
    UIImage *pieceImage = [self pieceTumbnailAtIndex:indexPath.row];
    cell.imageView.image = pieceImage;
    cell.imageView.frame = CGRectMake(10.0, 10.0, pieceImage.size.width, pieceImage.size.height);
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    UIImage *pieceImage = [self pieceTumbnailAtIndex:indexPath.row];
    
    return pieceImage.size.height + 20.0;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.sideMenuViewController menuButtonPressed:nil];
    
    //Add selected piece on collage view
    if ([self.sideMenuViewController.mainViewController isKindOfClass:[CollageViewController class]])
    {
        CollageViewController *collageViewController = (CollageViewController *)self.sideMenuViewController.mainViewController;
        [collageViewController addPieceToCollage:[[ImagePieceReadWrite sharedClient] imageAtIndex:indexPath.row]];
    }
}

- (UIImage*)pieceTumbnailAtIndex:(NSInteger)index
{
    return [[ImagePieceReadWrite sharedClient] thumbnailAtIndex:index];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end