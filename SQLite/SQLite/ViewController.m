//
//  ViewController.m
//  SQLite
//
//  Created by libin on 16/2/29.
//  Copyright © 2016年 hdf. All rights reserved.
//

#import "ViewController.h"
#import "LBPerson.h"
#import "LBPersonTool.h"

@interface ViewController ()
<
   UITableViewDelegate,
   UITableViewDataSource,
   UISearchBarDelegate
>

@end

@implementation ViewController
{

    UITableView *_tableView;
    NSArray *_persons;
    UISearchBar *_searchBar;

}


- (void)addLeftBtn {
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemPlay target:self action:@selector(add:)];
    self.navigationItem.leftBarButtonItem = leftBtn;
}


- (void)add:(UIBarButtonItem *)leftBtn{
   NSArray *names = @[@"西门抽血", @"西门抽筋", @"西门抽风", @"西门吹雪", @"东门抽血", @"东门抽筋", @"东门抽风", @"东门吹雪", @"北门抽血", @"北门抽筋", @"南门抽风", @"南门吹雪"];
    for (int i = 0; i < 10; i++) {
        LBPerson *person = [[LBPerson alloc]init];
        person.name = [NSString stringWithFormat:@"%@%d",names[arc4random_uniform(names.count)],i];
        person.age = arc4random_uniform(20) +20;
        [LBPersonTool save:person];
    }
    _persons = [LBPersonTool query];
    
    [_tableView reloadData];
    
}


- (void)addSearchBar {
    _searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, 300, 44)];
    _searchBar.delegate = self;
    self.navigationItem.titleView = _searchBar;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self addLeftBtn];
    [self addSearchBar];
    
    _tableView = [[UITableView alloc]initWithFrame:self.view.bounds];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_tableView];
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _persons.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([self class])];
    
    if (!cell) {
         cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:NSStringFromClass([self class])];
        }
    LBPerson *person = _persons[indexPath.row];
    cell.textLabel.text = person.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"年纪%d",person.age];
    
    return cell;
}


- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{

    _persons = [LBPersonTool queryWithCondition:searchText];
    [_tableView reloadData];
    [searchBar resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
