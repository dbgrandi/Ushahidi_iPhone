    //
//  AddIncidentViewController.m
//  Ushahidi_iPhone
//
//  Created by Dale Zak on 10-08-09.
//  Copyright 2010 Ushahidi. All rights reserved.
//

#import "AddIncidentViewController.h"
#import "MapViewController.h"
#import "TableCellFactory.h"
#import "Device.h"

#define kCancel @"Cancel"
#define kTakePhoto @"Take Photo"
#define kFromLibrary @"From Library"

typedef enum {
	TableSectionTitle,
	TableSectionCategory,
	TableSectionLocation,
	TableSectionDate,
	TableSectionTime,
	TableSectionDescription,
	TableSectionPhotos,
	TableSectionNews
} TableSection;

@interface AddIncidentViewController (Internal)

@end

@implementation AddIncidentViewController

@synthesize mapViewController, cancelButton, doneButton, imagePickerController;

#pragma mark -
#pragma mark Handlers

- (IBAction) cancel:(id)sender {
	DLog(@"cancel");
	[self dismissModalViewControllerAnimated:YES];
}

- (IBAction) done:(id)sender {
	DLog(@"done");
	[self dismissModalViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark UIViewController

- (void) viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
}

- (void) viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
}

- (void) viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}

- (void) viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
	self.imagePickerController = [[ImagePickerController alloc] initWithController:self];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (void)dealloc {
	[mapViewController release];
	[cancelButton release];
	[doneButton release];
	[imagePickerController release];
    [super dealloc];
}

#pragma mark -
#pragma mark UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)theTableView {
	return 8;
}

- (NSInteger)tableView:(UITableView *)theTableView numberOfRowsInSection:(NSInteger)section {
	if (section == TableSectionCategory) {
		return 5;
	}
	return 1;
}

- (UITableViewCell *)tableView:(UITableView *)theTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section == TableSectionCategory) {
		CheckBoxTableCell *cell = [TableCellFactory getCheckBoxTableCellWithDelegate:self table:theTableView];
		[cell setTitle:[NSString stringWithFormat:@"Category %d", indexPath.row]];
		[cell setChecked:NO];
		return cell;
	}
	else if (indexPath.section == TableSectionDescription) {
		TextViewTableCell *cell = [TableCellFactory getTextViewTableCellWithDelegate:self table:theTableView];
		cell.indexPath = indexPath;
		[cell setPlaceholder:@"Enter description"];
		return cell;
	}
	else if (indexPath.section == TableSectionPhotos) {
		UITableViewCell *cell = [TableCellFactory getDefaultTableCellForTable:theTableView];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		cell.selectionStyle = UITableViewCellSelectionStyleGray;
		cell.textLabel.text = @"Add New Incident Photo";
		return cell;
	}
	else {
		TextFieldTableCell *cell = [TableCellFactory getTextFieldTableCellWithDelegate:self table:theTableView];
		cell.indexPath = indexPath;
		if (indexPath.section == TableSectionTitle) {
			[cell setPlaceholder:@"Enter title"];
		}
		else if (indexPath.section == TableSectionDate) {
			[cell setPlaceholder:@"Enter date"];
		}
		else if (indexPath.section == TableSectionTime) {
			[cell setPlaceholder:@"Enter time"];
		}
		else if (indexPath.section == TableSectionLocation) {
			[cell setPlaceholder:@"Enter location"];
		}
		else if (indexPath.section == TableSectionNews) {
			[cell setPlaceholder:@"Add news"];
		}
		return cell;	
	}
}

- (NSString *)tableView:(UITableView *)theTableView titleForHeaderInSection:(NSInteger)section {
	if (section == TableSectionTitle) {
		return @"Title";
	}
	if (section == TableSectionCategory) {
		return @"Category";
	}
	if (section == TableSectionLocation) {
		return @"Location";
	}
	if (section == TableSectionDate) {
		return @"Date";
	}
	if (section == TableSectionTime) {
		return @"Time";
	}
	if (section == TableSectionDescription) {
		return @"Description";
	}
	if (section == TableSectionPhotos) {
		return @"Photos";
	}
	if (section == TableSectionNews) {
		return @"News";
	}
	return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section == TableSectionDescription) {
		return 120;
	}
	return 45;
}

- (void)tableView:(UITableView *)theTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	DLog(@"didSelectRowAtIndexPath:[%d, %d]", indexPath.section, indexPath.row);
	[theTableView deselectRowAtIndexPath:indexPath animated:YES];
	if (indexPath.section == TableSectionPhotos) {
		[self.imagePickerController showImagePicker];
	}
}

#pragma mark -
#pragma mark CheckBoxTableCellDelegate

- (void) checkBoxTableCellChanged:(CheckBoxTableCell *)cell index:(NSIndexPath *)indexPath checked:(BOOL)checked {
	DLog(@"checkBoxTableCellChanged:CheckBoxTableCell index:[%d, %d] checked:%d", indexPath.section, indexPath.row, checked)
}

#pragma mark -
#pragma mark TextFieldTableCellDelegate

- (void) textFieldFocussed:(TextFieldTableCell *)cell indexPath:(NSIndexPath *)indexPath {
	DLog(@"indexPath:[%d, %d]", indexPath.section, indexPath.row);
}

- (void) textFieldChanged:(TextFieldTableCell *)cell indexPath:(NSIndexPath *)indexPath text:(NSString *)text {
	DLog(@"indexPath:[%d, %d] text: %@", indexPath.section, indexPath.row, text);
}

- (void) textFieldReturned:(TextFieldTableCell *)cell indexPath:(NSIndexPath *)indexPath text:(NSString *)text {
		DLog(@"indexPath:[%d, %d] text: %@", indexPath.section, indexPath.row, text);
}

#pragma mark -
#pragma mark TextViewTableCellDelegate

- (void) textViewFocussed:(TextViewTableCell *)cell indexPath:(NSIndexPath *)indexPath {
	DLog(@"indexPath:[%d, %d]", indexPath.section, indexPath.row);
}

- (void) textViewChanged:(TextViewTableCell *)cell indexPath:(NSIndexPath *)indexPath text:(NSString *)text {
	DLog(@"indexPath:[%d, %d] text: %@", indexPath.section, indexPath.row, text);
}

- (void) textViewReturned:(TextViewTableCell *)cell indexPath:(NSIndexPath *)indexPath text:(NSString *)text {
	DLog(@"indexPath:[%d, %d] text: %@", indexPath.section, indexPath.row, text);
}

@end