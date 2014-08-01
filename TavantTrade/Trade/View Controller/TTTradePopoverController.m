//
//  TTTradePopoverController.m
//  TavantTrade
//
//  Created by TAVANT on 1/22/14.
//  Copyright (c) 2014 Tavant. All rights reserved.
//

#import "TTTradePopoverController.h"
#import "TTSymbolDetails.h"
#import "TTDiffusionData.h"
#import "SBITradingUtility.h"
#import "TTDismissingView.h"
#import "TTQuotesViewController.h"
#import "TTChartViewController.h"
#import "TTWatchlistEntryViewController.h"

#define kOFFSET_FOR_KEYBOARD 88.0
#define kQuantityFrame CGRectMake(10.0, 289.0,408.0, 30.0)
#define kDisclosedQuantityFrame CGRectMake(10.0, 337.0,408.0, 30.0)
#define kPriceFrame CGRectMake(10.0, 385.0,408.0, 30.0)
#define kTriggeredPriceFrame CGRectMake(10.0, 433.0,408.0, 30.0)

@interface TTTradePopoverController ()
@property (nonatomic, weak) IBOutlet UIView *enlargedHeaderView;
@property(nonatomic,strong)TTSymbolData *currentSymbol;
@property(nonatomic,strong)UIPopoverController *selectPopoverController;
@property(nonatomic,strong)NSMutableArray *optionsArray;
@property(nonatomic, strong) UIViewController* tradeOptionsListController;
@property(nonatomic, strong) NSString* subKey;
@property(nonatomic,weak)IBOutlet UIButton *chartButton;
@property(nonatomic,weak)IBOutlet UIButton *quotesButton;
@property(nonatomic,weak)IBOutlet UIButton *addToWatchlistButton;
@property(nonatomic,strong)UITextField *currentOnFocusTextField;
@property(nonatomic,assign)float originalScrollerOffsetY;
@end

@implementation TTTradePopoverController

@synthesize tradeOptionsListController = _tradeOptionsListController;
@synthesize popOverView = _popOverView;
@synthesize optionsArray = _optionsArray;
@synthesize durationType = _durationType;
@synthesize transactionType = _transactionType;
@synthesize selectedTradingOptionType = _selectedTradingOptionType;
@synthesize productType = _productType;
@synthesize orderType = _orderType;
@synthesize tradeDataSource = _tradeDataSource;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _optionsArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if(self.shouldShowBackButton){
        [self.cancelButton setTitle:self.previousScreenTitle forState:UIControlStateNormal];
        [self.cancelButton setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
        [self.cancelButton setTitleEdgeInsets:UIEdgeInsetsMake(0,-12,0,0)];
        self.cancelButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;

    }
    self.navigationController.navigationBarHidden = YES;
    _mainScroller.contentSize = CGSizeMake(_mainScroller.frame.size.width, _mainScroller.frame.size.height+150);
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onKeyboardShow:) name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onKeyboardHide:) name:UIKeyboardWillHideNotification object:nil];

    _enlargedHeaderView.backgroundColor = [SBITradingUtility getColorForComponentKey:@"TradeTitleBar"];

    
    _tradeTitleLabel.text=NSLocalizedStringFromTable(@"Trade_Title", @"Localizable", @"Trade");
    _askLabel.text=NSLocalizedStringFromTable(@"Ask", @"Localizable", @"Ask");
    _bidLabel.text=NSLocalizedStringFromTable(@"Bid", @"Localizable", @"Bid");
    _highLabel.text=NSLocalizedStringFromTable(@"High", @"Localizable", @"High");
    _lowLabel.text=NSLocalizedStringFromTable(@"Low", @"Localizable", @"Low");
    _accNumberLabel.text=NSLocalizedStringFromTable(@"Account_Number", @"Localizable", @"Account Number");
    _orderTicketLabel.text=NSLocalizedStringFromTable(@"Order_Ticket", @"Localizable", @"Order Ticket");
    _quantityLabel.text=NSLocalizedStringFromTable(@"Qty", @"Localizable", @"Quantity");
    _disclosedQtyLabel.text=NSLocalizedStringFromTable(@"Dis_Qty", @"Localizable", @"Quantity");
    _triggeredPriceLabel.text=NSLocalizedStringFromTable(@"Trigger_Price", @"Localizable", @"Quantity");
    _priceLabel.text=NSLocalizedStringFromTable(@"Price", @"Localizable", @"Quantity");
    [_chartButton setTitle: NSLocalizedStringFromTable(@"Chart_Button_Title", @"Localizable", @"Chart") forState:UIControlStateNormal];
    _chartButton.titleLabel.font=REGULAR_FONT_SIZE(14);
    _quotesButton.titleLabel.font=REGULAR_FONT_SIZE(14);
    _addToWatchlistButton.titleLabel.font=REGULAR_FONT_SIZE(14);
    [_quotesButton setTitle: NSLocalizedStringFromTable(@"Quote_Button_Title", @"Localizable", @"Quotes") forState:UIControlStateNormal];
    [_addToWatchlistButton setTitle: NSLocalizedStringFromTable(@"Add_To_WatchList", @"Localizable", @"Add To Watchlist") forState:UIControlStateNormal];
    [_transactionTypeButton setTitle:NSLocalizedStringFromTable(@"Buy_Type", @"Localizable", @"Buy") forState:UIControlStateNormal];
    [_orderTypeButton setTitle:NSLocalizedStringFromTable(@"Intraday_Prod_Type", @"Localizable", @"IntraDay") forState:UIControlStateNormal];
    [_durationButton setTitle:NSLocalizedStringFromTable(@"Dur_Day", @"Localizable", @"Day") forState:UIControlStateNormal];
    [_productTypeButton setTitle:NSLocalizedStringFromTable(@"Limit_Order_Title", @"Localizable", @"Limit") forState:UIControlStateNormal];
    
    _companyNameLabel.font = _symbolNameLabel.font = _orderTicketLabel.font = _accNumberLabel.font = _accountNumberLabel.font = SEMI_BOLD_FONT_SIZE(14.0);
    _bidValueLabel.font = _askValueLabel.font = _highValueLabel.font = _lowValueLabel.font = _bidLabel.font = _askLabel.font = _highLabel.font = _lowLabel.font = SEMI_BOLD_FONT_SIZE(13.0);
    
    _transactionTypeButton.titleLabel.font = _orderTypeButton.titleLabel.font = _durationButton.titleLabel.font = _productTypeButton.titleLabel.font = SEMI_BOLD_FONT_SIZE(17.0);
    
    _symbolNameLabel.font = _companyNameLabel.font = SEMI_BOLD_FONT_SIZE(14.0);
    
    _tradeTitleLabel.font = SEMI_BOLD_FONT_SIZE(22.0);
    
    self.cancelButton.titleLabel.font = REGULAR_FONT_SIZE(16.5);
    
    _quantityLabel.font = _disclosedQtyLabel.font = _triggeredPriceLabel.font = _priceLabel.font = _txtDisclosedQuantity.font = _txtPrice.font = _txtQuantity.font = _txtTriggeredPrice.font = SEMI_BOLD_FONT_SIZE(15.0);
    
    if(self.isModifyMode){
        self.subKey = _tradeDataSource.subscriptionKey;
        self.currentSymbol = _tradeDataSource.symbolData;
        if(_tradeDataSource.transactionType)
            self.transactionType = ([_tradeDataSource.transactionType caseInsensitiveCompare:@"Buy"]==NSOrderedSame)?eBuy:eSell;
        if(_tradeDataSource.productType)
            self.productType = ([_tradeDataSource.productType caseInsensitiveCompare:@"Intraday"] == NSOrderedSame)?eIntraday:eDelivery;
        if(_tradeDataSource.priceType)
            self.orderType = [SBITradingUtility returnOrderType:_tradeDataSource.priceType];
        if(_tradeDataSource.orderDuration)
            self.durationType = ([_tradeDataSource.orderDuration caseInsensitiveCompare:@"Day"]==NSOrderedSame)?eDay:eIOC;
        
        //hide the buttons ...
        
        self.chartButton.hidden = YES;
        self.quotesButton.hidden = YES;
        self.addToWatchlistButton.hidden = YES;
        
        _txtTriggeredPrice.text = [NSString stringWithFormat:@"%f",_tradeDataSource.triggeredPrice];
        _txtPrice.text = [NSString stringWithFormat:@"%.2f",_tradeDataSource.priceToFill];
        _txtQuantity.text = [NSString stringWithFormat:@"%d",_tradeDataSource.quantitytoFill];
        _txtDisclosedQuantity.text = [NSString stringWithFormat:@"%d",_tradeDataSource.disclosedQuantity];
        
    }
    else{
        _tradeDataSource= nil;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateGlobalSymbolData) name:@"UpdateGlobalSymbol" object:nil];
        TTSymbolDetails *symbolDetails = [TTSymbolDetails sharedSymbolDetailsManager];
        self.subKey=symbolDetails.symbolData.subscriptionKey;
//        _mainScroller.contentSize = CGSizeMake(428, 600);
        self.currentSymbol = symbolDetails.symbolData;
        self.companyNameLabel.text = symbolDetails.symbolData.companyName;
        self.transactionType = eBuy;
        self.productType = eIntraday;
        self.orderType = eLimitType;
        self.durationType = eDay;
        
        self.chartButton.hidden = NO;
        self.quotesButton.hidden = NO;
        self.addToWatchlistButton.hidden = NO;
        
        _txtTriggeredPrice.text = @"";
        _txtPrice.text = @"";
        _txtQuantity.text = @"";
        _txtDisclosedQuantity.text = @"";
        
    }
   
    if(self.currentSymbol){
        TTDiffusionHandler *diffusionHandler = [TTDiffusionHandler sharedDiffusionManager];
        [diffusionHandler subscribe:self.subKey withContext:self];
        self.symbolNameLabel.text = self.currentSymbol.tradeSymbolName;
    }
    
    self.listingTableView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.listingTableView.layer.borderWidth = 0.5;
    self.listingTableView.layer.cornerRadius = 2.0;
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
//    self.view.superview.bounds = CGRectMake(0, 0, 428, 506);
    self.navigationController.view.bounds = CGRectMake(0, 0, 428, 506);
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.view.superview.backgroundColor = [UIColor clearColor];
}

-(void)updateUI:(TTDiffusionData *) diffusionData{
    self.volumeLabel.text=[NSString stringWithFormat:@"%.02f",diffusionData.volume] ;
    self.ltpLabel.text=[NSString stringWithFormat:@"%.02f",diffusionData.lastSalePrice];
    self.changeLabel.text=[NSString stringWithFormat:@"%.02f",diffusionData.netPriceChange];
    self.bidValueLabel.text=[NSString stringWithFormat:@"%.02f",diffusionData.bidValue];
    self.askValueLabel.text=[NSString stringWithFormat:@"%.02f",diffusionData.askValue];
    self.highValueLabel.text=[NSString stringWithFormat:@"%.02f",diffusionData.highPrice];
    self.lowValueLabel.text=[NSString stringWithFormat:@"%.02f",diffusionData.lowPrice];
}



-(void)setOrderType:(EOrderType)orderType
{
    _orderType  = orderType;
    [_orderTypeButton setTitle:[SBITradingUtility getTitleForOrderType:_orderType] forState:UIControlStateNormal];
    [self updateTradeOptionsUI];
}

-(void)setTransactionType:(ETransactionType)transactionType
{
    _transactionType = transactionType;
    [_transactionTypeButton setTitle:[SBITradingUtility getTitleForTransactionType:_transactionType] forState:UIControlStateNormal];
}

-(void)setDurationType:(EDuration)durationType
{
    _durationType =  durationType;
    [_durationButton setTitle:[SBITradingUtility getTitleForDuration:_durationType] forState:UIControlStateNormal];
}

-(void)setProductType:(EProductType)productType
{
    _productType = productType;
    [_productTypeButton setTitle:[SBITradingUtility getTitleForProductType:_productType] forState:UIControlStateNormal];
}

- (void) updateTradeOptionsUI
{
    _txtQuantity.superview.frame = kQuantityFrame;
    _txtDisclosedQuantity.superview.frame = kDisclosedQuantityFrame;
    _txtPrice.superview.frame = kPriceFrame;
    _txtTriggeredPrice.superview.frame = kTriggeredPriceFrame;
    _txtQuantity.superview.hidden = NO;
    _txtDisclosedQuantity.superview.hidden = NO;
    _txtPrice.superview.hidden = NO;
    _txtTriggeredPrice.superview.hidden = NO;
    
    switch (_orderType) {
        case eLimitType:
        {
            _txtTriggeredPrice.superview.hidden = YES;
        }
            break;
            
        case eMarketType:
        {
            _txtPrice.superview.hidden = YES;
            _txtTriggeredPrice.superview.hidden = YES;
        }
            break;
        case eSLLType:
        {
            
        }
            break;
        case eSLMType:
        {
            _txtPrice.superview.hidden = YES;
            NSLog(@"_txt %@ %@",_txtPrice,_txtPrice.superview);
            NSLog(@"%@",NSStringFromCGRect(kPriceFrame));
            _txtTriggeredPrice.superview.frame = kPriceFrame;
            NSLog(@"trigger %@ %@",_txtTriggeredPrice,_txtTriggeredPrice.superview);
        }
            break;
            
        default:
            break;
    }
    
    
    
    
}

#pragma UIKeyboard Notification methods ...

-(void)onKeyboardShow:(NSNotification *)notification{
    NSLog(@"Keyboard shown");
    
    //TODO:Bandhavi
    
    //Lets get the keyboard height ...
    NSDictionary *keyboardInfo = [notification userInfo];
    CGSize keyboardFrame = [[keyboardInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    float keyboardHeight = keyboardFrame.width;
//    float currentViewHeight = self.view.frame.size.height;
    CGRect viewableArea = CGRectMake(0, 0, self.view.frame.size.width, keyboardHeight-280);
    CGRect textFieldFrame = self.currentOnFocusTextField.superview.frame;
    if (!CGRectContainsRect(viewableArea, textFieldFrame)) {
        float scrollPointY = (keyboardHeight-280);

        self.originalScrollerOffsetY = _mainScroller.contentOffset.y;
        
        [_mainScroller setContentOffset:CGPointMake(0.0, scrollPointY) animated:YES];
    }

    
}

-(void)onKeyboardHide:(NSNotification *)notification{
    NSLog(@"Keyboard hidden");
    [_mainScroller setContentOffset:CGPointMake(0, self.originalScrollerOffsetY) animated:YES];
}


#pragma NSNotification handler

-(void)updateGlobalSymbolData{
    TTSymbolDetails *symbolDetails = [TTSymbolDetails sharedSymbolDetailsManager];
    self.currentSymbol = symbolDetails.symbolData;
    if(self.currentSymbol){
        TTDiffusionHandler *diffusionHandler = [TTDiffusionHandler sharedDiffusionManager];
        [diffusionHandler subscribe:symbolDetails.symbolData.subscriptionKey withContext:self];
        self.companyNameLabel.text = symbolDetails.symbolData.companyName;
        self.symbolNameLabel.text = self.currentSymbol.tradeSymbolName;
    }
}

#pragma NSNotification handler

-(void)onDelta:(DFTopicMessage *)message{
    
    //find the row to be updated...
    NSArray *parsedArray = [SBITradingUtility parseArray:message.records];
    TTDiffusionData *diffusionData = [[TTDiffusionData alloc] init];
    diffusionData = [diffusionData updateDiffusionDataWith:parsedArray];
    [self updateUI:diffusionData];
    
}

- (IBAction)closeTradeView:(id)sender {
    
    if(!self.shouldShowBackButton)
        [self dismissViewControllerAnimated:YES completion:nil];
    else{
//        self.navigationController.view.center = CGPointMake(435, 359);
//        self.navigationController.view.bounds = CGRectMake(0, 0, 428, 506);
        self.navigationController.view.bounds = self.previousScreenFrame;
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (IBAction)onTransactionTypeClick:(id)sender {
    [self closeKeyBoard];
    _selectedTradingOptionType = [sender tag];
    [_optionsArray removeAllObjects];
    [self.optionsArray addObject:[SBITradingUtility getTitleForTransactionType:eBuy]];
    [self.optionsArray addObject:[SBITradingUtility getTitleForTransactionType:eSell]];
    [self showTradeOptionsListinFrame:[(UIButton *)sender frame]];
    
}

- (IBAction)onproductTypeclick:(id)sender {
    [self closeKeyBoard];
    _selectedTradingOptionType = [sender tag];
    [_optionsArray removeAllObjects];
    [self.optionsArray addObject:[SBITradingUtility getTitleForProductType:eIntraday]];
    [self.optionsArray addObject:[SBITradingUtility getTitleForProductType:eDelivery]];
    [self showTradeOptionsListinFrame:[(UIButton *)sender frame]];
    
}

- (IBAction)onDurationCLick:(id)sender {
    [self closeKeyBoard];
    _selectedTradingOptionType = [sender tag];
    [_optionsArray removeAllObjects];
    [self.optionsArray addObject:[SBITradingUtility getTitleForDuration:eDay]];
    [self.optionsArray addObject:[SBITradingUtility getTitleForDuration:eIOC]];
    [self showTradeOptionsListinFrame:[(UIButton *)sender frame]];
    
}


- (IBAction)onOrderTypeClick:(id)sender {
    [self closeKeyBoard];
    _selectedTradingOptionType = [sender tag];
    [_optionsArray removeAllObjects];
    [self.optionsArray addObject:[SBITradingUtility getTitleForOrderType:eLimitType]];
    [self.optionsArray addObject:[SBITradingUtility getTitleForOrderType:eMarketType]];
    [self.optionsArray addObject:[SBITradingUtility getTitleForOrderType:eSLLType]];
    [self.optionsArray addObject:[SBITradingUtility getTitleForOrderType:eSLMType]];
    [self showTradeOptionsListinFrame:[(UIButton *)sender frame]];
    
}

- (IBAction)openPreviewPage:(id)sender {
    [self closeKeyBoard];
    if([self validateTExtFields]){
        self.tradepreview=[[TTTradePreviewController alloc] initWithNibName:@"TTTradePreviewController" bundle:nil];
        self.tradepreview.isModifyMode = self.isModifyMode;
        self.tradepreview.currentSelectedOrder = _tradeDataSource;
        [self setValuesforPreview: self.tradepreview];
        [self.navigationController pushViewController:self.tradepreview animated:YES];
//        self.tradepreview.modalPresentationStyle = UIModalPresentationFormSheet;
//        [self presentViewController:self.tradepreview animated:NO completion:NULL];
    }
    else{
        NSString *msg=@"Please Enter mandatory fields to preview the page";
        [self showAlert:msg];
    }
    
    
}
// common alert for the page
-(void) showAlert: (NSString *)message{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid Details"
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

-(void)setValuesforPreview:(TTTradePreviewController *)preview{
    NSLog(@"text is %@",self.txtQuantity.text);
    preview.qty = self.txtQuantity.text;
    preview.orderType =[SBITradingUtility getTitleForOrderType:self.orderType];
    preview.validity=[SBITradingUtility getTitleForDuration:self.durationType];
    preview.prodType=[SBITradingUtility getTitleForProductType:self.productType];
    preview.disQty= self.txtDisclosedQuantity.text;
    preview.company=self.currentSymbol.companyName;
    preview.symbolData=self.currentSymbol;
    
    preview.subscriptionKey=self.subKey;
    
    preview.tradeType=[SBITradingUtility getTitleForTransactionType:self.transactionType];
    preview.price=self.txtPrice.text;
    preview.triggerPrice=self.txtTriggeredPrice.text;
    
}
//To Do: dont allow user to open preview without entering values
-(BOOL)validateTExtFields{
    BOOL isValid=TRUE;
    switch(self.orderType){
            
        case 0:if([self.txtQuantity.text isEqualToString:@""]||[self.txtDisclosedQuantity.text isEqualToString:@""]||[self.txtPrice.text isEqualToString:@""]){
            isValid=FALSE;
        }
            break;
        case 1:if([self.txtQuantity.text isEqualToString:@""]||[self.txtDisclosedQuantity.text isEqualToString:@""]){
            isValid=FALSE;
        }
            break;
        case 2:if([self.txtQuantity.text isEqualToString:@""]||[self.txtDisclosedQuantity.text isEqualToString:@""]||[self.txtPrice.text isEqualToString:@""]||[self.txtTriggeredPrice.text isEqualToString:@""]){
            isValid=FALSE;
        }
            break;
        case 3:if([self.txtQuantity.text isEqualToString:@""]||[self.txtDisclosedQuantity.text isEqualToString:@""]||[self.txtTriggeredPrice.text isEqualToString:@""]){
            isValid=FALSE;
        }
            break;
            
    }
    return isValid;
}

-(void) closeKeyBoard{
    [self.txtQuantity resignFirstResponder];
}

-(void)showTradeOptionsListinFrame:(CGRect)inFrame
{
    [self.listingTableView reloadData];
    if(!_tradeOptionsListController)
    {
        _tradeOptionsListController = [[UIViewController alloc] init];
    }
    _tradeOptionsListController.view = _popOverView;
    self.selectPopoverController = [[UIPopoverController alloc] initWithContentViewController:_tradeOptionsListController];
    [self.selectPopoverController setPopoverContentSize:CGSizeMake(self.popOverView.frame.size.width, self.popOverView.frame.size.height)];
    [self.selectPopoverController presentPopoverFromRect:inFrame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    
}

#pragma TableView Delegates

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.optionsArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = [self.optionsArray objectAtIndex:indexPath.row];
    cell.textLabel.font = [UIFont boldSystemFontOfSize:13.0];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (_selectedTradingOptionType)
    {
        case eTransaction:
        {
            self.transactionType = indexPath.row;
        }
            break;
        case eProduct:
        {
            self.productType = indexPath.row;
        }
            break;
        case eOrder:
        {
            self.orderType = indexPath.row;
            [self clearTextFields];
        }
            break;
        case eDuration:
        {
            self.durationType = indexPath.row;
        }
            break;
            
        default:
            break;
    }
    
    [_selectPopoverController dismissPopoverAnimated:YES];
}

-(void)clearTextFields{
    self.txtTriggeredPrice.text=@"";
    self.txtQuantity.text=@"";
    self.txtPrice.text=@"";
    self.txtDisclosedQuantity.text=@"";
}

#pragma mark - UITextfield Delegate Method
-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)disablesAutomaticKeyboardDismissal {
    return NO;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if([string length]==0){
        return YES;
    }
    
    /*  limit to only numeric characters  */
    
    NSCharacterSet* numberCharSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    for (int i = 0; i < [string length]; ++i)
    {
        unichar c = [string characterAtIndex:i];
        if (![numberCharSet characterIsMember:c])
        {
            return NO;
        }
    }
    
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField {
    //Keyboard becomes visible
    self.currentOnFocusTextField = textField;
//    self.view.bounds = CGRectMake( self.view.frame.origin.x,
//                                 self.view.frame.origin.y+80,
//                                 self.view.frame.size.width,
//                                 self.view.frame.size.height);   //resize
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    //keyboard will hide
//    self.view.bounds = CGRectMake( self.view.frame.origin.x,
//                                 self.view.frame.origin.y-80,
//                                 self.view.frame.size.width,
//                                 self.view.frame.size.height ); //resize
}

-(IBAction)goToQuotes:(id)sender{
    
    for(id viewController in self.navigationController.viewControllers){
        if([viewController isKindOfClass:[TTQuotesViewController class]]){
//            self.navigationController.view.center = CGPointMake(435, 359);
            self.navigationController.view.bounds = self.previousScreenFrame;
            
//            self.navigationController.view.frame = self.previousScreenFrame;
//            self.navigationController.view.center = CGPointMake(512, 350);
            
            [self.navigationController popToViewController:viewController animated:YES];
            return;
        }
    }
    //the Quotes screen is not presented yet ...
    TTQuotesViewController *quotesViewController = [[TTQuotesViewController alloc] initWithNibName:@"TTQuotesViewController" bundle:nil];
    quotesViewController.previousScreenTitle = @"Trade";
    quotesViewController.previousScreenFrame = self.view.frame;
    quotesViewController.shouldShowBackButton = YES;
    [self.navigationController pushViewController:quotesViewController animated:YES];
    
}

-(IBAction)goToChart:(id)sender{
    for(id viewController in self.navigationController.viewControllers){
        if([viewController isKindOfClass:[TTChartViewController class]]){
//            self.navigationController.view.center = CGPointMake(435, 359);
//            self.navigationController.view.frame = self.previousScreenFrame;
//            self.navigationController.view.center = CGPointMake(512, 350);
            self.navigationController.view.bounds = self.previousScreenFrame;
            [self.navigationController popToViewController:viewController animated:YES];
            return;
        }
    }
    //the Quotes screen is not presented yet ...
    TTChartViewController *chartViewController = [[TTChartViewController alloc] initWithNibName:@"TTChartViewController" bundle:nil];
    chartViewController.previousScreenTitle = @"Trade";
    chartViewController.previousScreenFrame = self.view.frame;
    chartViewController.shouldShowBackButton = YES;
    self.navigationController.view.frame = chartViewController.view.frame;
    [self.navigationController pushViewController:chartViewController animated:YES];
}

-(IBAction)addToWatchlist:(id)sender{
    //show a list of watchlist to the user ...
    //show all watchlists...
    TTSymbolDetails *symbolDetails = [TTSymbolDetails sharedSymbolDetailsManager];
    TTWatchlistEntryViewController *watchListViewController = [[TTWatchlistEntryViewController alloc] initWithNibName:@"TTWatchlistEntryViewController" bundle:nil];
    SBITradingUtility *utilityObj = [SBITradingUtility sharedUtility];
    watchListViewController.loadWatchlistDelegate = utilityObj.watchlistController;

    watchListViewController.parentController = self;
    watchListViewController.isCalledFromOtherScreen = YES;
    watchListViewController.shouldShowBackButton=YES;
    watchListViewController.previousScreenTitle=@"Trade";
    watchListViewController.currentSymbol = symbolDetails.symbolData;
    NSLog(@"nav %@",self.navigationController);
    [self.navigationController pushViewController:watchListViewController animated:YES];
}

@end
