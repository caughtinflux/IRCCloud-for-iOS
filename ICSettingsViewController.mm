#import "ICGlobal.h"
#import "ICSettingsViewController.h"
#import "ICRequest.h"
#import "ICApplication.h"
#import "ICLogInViewController.h"

@implementation ICSettingsViewController
@synthesize popoverController;
-(void)loadView{
	[super loadView];
	self.tableView.delegate=self;
	self.tableView.dataSource=self;
	self.title=__(@"SETTINGS");
}
-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)orientation{
	return YES;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)table{
	return 3;
}
-(NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section{
	switch(section){
		case 0:return 1;break;
		case 1:return 0;break;
		case 2:return 2;break;
		default:return nil;break;
	}
}
-(NSString *)tableView:(UITableView *)table titleForHeaderInSection:(NSInteger)section{
	switch(section){
		case 0:return __(@"ACCOUNT");break;
		case 1:return [NSString stringWithFormat:__(@"VERSION"),version];break;
		default:return nil;break;
	}
}
-(NSString *)tableView:(UITableView *)table titleForFooterInSection:(NSInteger)section{
	return section==1?__(@"AUTHOR"):nil;
}
-(UITableViewCell *)tableView:(UITableView *)table cellForRowAtIndexPath:(NSIndexPath *)index{
	UITableViewCell *cell=[table dequeueReusableCellWithIdentifier:index.section==0?@"settingsSwitchCell":@"settingsFollowCell"]?:[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:index.section==0?@"settingsSwitchCell":@"settingsFollowCell"];
	if(index.section==0){
		cell.textLabel.text=__(@"LOG_OUT");
		cell.textLabel.textAlignment=UITextAlignmentCenter;
	}else{
		cell.textLabel.text=__(index.row==0?@"FOLLOW_ME":@"FOLLOW_IRCCLOUD");
		cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
	}
	return cell;
}
-(void)viewWillDisappear{
	//TODO: make settings that need to be saved here
}
-(void)tableView:(UITableView *)table didSelectRowAtIndexPath:(NSIndexPath *)index{
	[table deselectRowAtIndexPath:index animated:YES];
	if(index.section==0&&index.row==0)[[[UIAlertView alloc]initWithTitle:__(@"LOG_OUT") message:__(@"LOG_OUT_MESSAGE") delegate:self cancelButtonTitle:__(@"CANCEL") otherButtonTitles:__(@"LOG_OUT"),nil]show];
	else if(index.section==2){
		NSString *account=index.row==0?@"thekirbylover":@"IRCCloud";
		if([[UIApplication sharedApplication]canOpenURL:[NSURL URLWithString:@"tweetbot:"]])[[UIApplication sharedApplication]openURL:[NSURL URLWithString:[@"tweetbot:///user_profile/" stringByAppendingString:account]]];
		else if([[UIApplication sharedApplication]canOpenURL:[NSURL URLWithString:@"tweetings:"]])[[UIApplication sharedApplication]openURL:[NSURL URLWithString:[@"tweetings:///user?screen_name=" stringByAppendingString:account]]];
		else if([[UIApplication sharedApplication]canOpenURL:[NSURL URLWithString:@"twitter:"]])[[UIApplication sharedApplication]openURL:[NSURL URLWithString:[@"twitter://user?screen_name=" stringByAppendingString:account]]];
		else [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[@"http://twitter.com/intent/follow?screen_name=" stringByAppendingString:account]]];
	}
}
-(void)alertView:(UIAlertView *)alert clickedButtonAtIndex:(NSInteger)index{
	if([[alert buttonTitleAtIndex:index]isEqualToString:__(@"LOG_OUT")]){
		if(isPad)[self.popoverController dismissPopoverAnimated:NO];
		else [self.navigationController popViewControllerAnimated:NO];
		[ICRequest requestWithPage:@"logout" parameters:[@"session=" stringByAppendingString:[ICApp cookie]] delegate:nil selector:nil];
		[ICApp setCookie:nil];
		NSMutableDictionary *prefs=[NSMutableDictionary dictionaryWithContentsOfFile:prefpath];
		[prefs removeObjectForKey:@"Cookie"];
		[prefs writeToFile:prefpath atomically:YES];
		ICLogInViewController *logIn=[[ICLogInViewController alloc]initWithStyle:UITableViewStyleGrouped];
		UINavigationController *logInCtrl=[[UINavigationController alloc]initWithRootViewController:logIn];
		logInCtrl.modalPresentationStyle=UIModalPresentationFormSheet;
		[self.navigationController presentModalViewController:logInCtrl animated:YES];
	}
}
@end
