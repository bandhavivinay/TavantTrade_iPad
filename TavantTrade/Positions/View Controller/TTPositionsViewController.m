//
//  TTPositionsViewController.m
//  TavantTrade
//
//  Created by Bandhavi on 2/21/14.
//  Copyright (c) 2014 Tavant. All rights reserved.
//

#import "TTPositionsViewController.h"
#import "TTPositionTableViewCell.h"
#import "TTUrl.h"
#import "SBITradingNetworkManager.h"
#import "SBITradingUtility.h"

@interface TTPositionsViewController ()
@property (weak, nonatomic) IBOutlet UILabel *totalLabel;
@property (weak, nonatomic) IBOutlet UITextField *totalTextField;
@property (weak, nonatomic) IBOutlet UITextField *widgetTotalTextField;
@property (weak, nonatomic) IBOutlet UILabel *widgetTotalLabel;
@property(nonatomic,weak)IBOutlet UITableView *symbolListTableView;
@property(nonatomic,weak)IBOutlet UITableView *widgetSymbolListTableView;
@property (weak, nonatomic) IBOutlet UILabel *positionHeadingTitle;
@property (weak, nonatomic) IBOutlet UILabel *widgetPositionTitle;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property(nonatomic,strong)NSMutableArray *symbolArray;
@property (nonatomic, weak) IBOutlet UIView *enlargedHeaderView;
@property (nonatomic, weak) IBOutlet UIView *headerView;
@end

BOOL showDummyData = YES;

@implementation TTPositionsViewController

@synthesize isEnlargedView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil



{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    self.view.superview.bounds = CGRectMake(0, 0, 428, 506);
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self reloadPositionView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _widgetTotalTextField.layer.cornerRadius = 10.0;
    _widgetTotalTextField.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    _widgetTotalTextField.layer.borderWidth = 0.5;
    
    _totalTextField.layer.cornerRadius = 10.0;
    _totalTextField.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    _totalTextField.layer.borderWidth = 0.5;
    
    //set the heading and labels of the screen ...
    [self.cancelButton setTitle:NSLocalizedStringFromTable(@"Cancel_Button_Title", @"Localizable", @"Cancel") forState:UIControlStateNormal];
    _positionHeadingTitle.text = _widgetPositionTitle.text = NSLocalizedStringFromTable(@"Position_Heading", @"Localizable", @"Positions");
    _totalLabel.text = _widgetTotalLabel.text = NSLocalizedStringFromTable(@"Position_Total", @"Localizable", @"Total Profit/Loss");
    _enlargedHeaderView.backgroundColor = [SBITradingUtility getColorForComponentKey:@"PositionsTitleBar"];
    _headerView.backgroundColor = [SBITradingUtility getColorForComponentKey:@"PositionsTitleBar"];

    //set up the font ...
    _positionHeadingTitle.font = SEMI_BOLD_FONT_SIZE(22.0);
    _widgetPositionTitle.font = SEMI_BOLD_FONT_SIZE(19.0);
     _cancelButton.titleLabel.font = REGULAR_FONT_SIZE(16.5);
    _widgetTotalLabel.font = _totalLabel.font = LIGHT_FONT_SIZE(25.0);
    
    // Do any additional setup after loading the view from its nib.
}

-(void)reloadPositionView{
    SBITradingNetworkManager *networkManager = [SBITradingNetworkManager sharedNetworkManager];
    NSString *relativePath = [TTUrl positionURL];
    
    NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfFile:[SBITradingUtility plistFilePath]];
    
    NSDictionary *postBodyDictionary = [NSDictionary dictionaryWithObjectsAndKeys:[dictionary objectForKey:@"requestId"],@"requestId",[dictionary objectForKey:@"clientID"],@"clientID",@"true",@"syncResponse",@"",@"exchange",@"",@"symbol",@"",@"productType",@"",@"instrumentType", nil];
    
    NSLog(@"Dictionary is %@",postBodyDictionary);
    
    [networkManager makePOSTRequestWithRelativePath:relativePath withPostBody:postBodyDictionary responceCallback:^(NSData *data,NSURLResponse *response,NSError *error) {
        
        NSError *jsonParsingError = nil;
        NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonParsingError];
        NSString *jsonString = [NSString stringWithUTF8String:[data bytes]];
        NSLog(@"%@ and status code is %@",jsonString,response);
        NSLog(@"Position Response is %@",responseDictionary);
        
        if([data length] > 0){
            
            showDummyData = NO;
            
        }
        else
            showDummyData = YES;
        
    }];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma UITableView Delegate methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(showDummyData)
        return 5;
    else
        return [self.symbolArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TTPositionTableViewCell *cell;
    
    if(tableView == _widgetSymbolListTableView){
        static NSString *cellIdentifier = @"Cell";
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if (cell == nil) {
            
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"TTPositionTableViewCell" owner:self options:nil];
            
            for(id oneObject in nib) {
                
                if([oneObject isKindOfClass:[TTPositionTableViewCell class]]) {
                    cell = (TTPositionTableViewCell *)oneObject;
                    cell.profitLabel.font = cell.symbolNameLabel.font = REGULAR_FONT_SIZE(12.5);
                }
                
            }
            
        }
    }
    else if(tableView == _symbolListTableView){
        static NSString *cellIdentifier = @"EnlargedCell";
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if (cell == nil) {
            
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"TTPositionEnlargedTableViewCell" owner:self options:nil];
            
            for(id oneObject in nib) {
                
                if([oneObject isKindOfClass:[TTPositionTableViewCell class]]) {
                    cell = (TTPositionTableViewCell *)oneObject;
                    cell.profitLabel.font = cell.profitPercentageLabel.font = cell.ltpLabel.font = cell.averageCostLabel.font = cell.quantityLabel.font = cell.typeLabel.font = REGULAR_FONT_SIZE(12.0);
                    cell.symbolNameLabel.font = REGULAR_FONT_SIZE(14.5);
                }
                
            }
            
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //Go to Trade screen ...
//    TTOrder *dataSource = [[TTOrder alloc] init];
//    dataSource.symbolName = _currentSymbol.symbolName;
//    dataSource.subscriptionKey = _currentSymbol.subscriptionKey;
//    dataSource.companyName = _currentSymbol.companyName;
//    TTTradePopoverController *tradeViewController = [[TTTradePopoverController alloc] initWithNibName:@"TTTradePopoverController" bundle:nil];
//    tradeViewController.tradeDataSource = dataSource;
//    tradeViewController.isModifyMode = YES;
//    tradeViewController.previousScreenTitle = @"OC";
//    tradeViewController.previousScreenFrame = self.view.frame;
//    tradeViewController.shouldShowBackButton = YES;
//    [self.navigationController pushViewController:tradeViewController animated:YES];

    
}

#pragma IBAction...

-(IBAction)showEnlargedView:(id)sender{
    isEnlargedView = YES;
    [self.positionViewDelegate positionViewControllerShouldPresentinEnlargedView:self];
}

-(IBAction)dismissTheView:(id)sender{
    isEnlargedView = NO;
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
