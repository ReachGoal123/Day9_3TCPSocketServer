//
//  ViewController.m
//  Day9_3TCPSocketServer
//
//  Created by tarena on 15-3-24.
//  Copyright (c) 2015年 tarena. All rights reserved.
//

#import "ViewController.h"
#import "AsyncSocket.h"
@interface ViewController ()<AsyncSocketDelegate>
@property (nonatomic, strong)AsyncSocket *serverSocket;
@property (nonatomic, strong)AsyncSocket *myNewSocket;
@property (nonatomic, strong)AsyncSocket *clientScoket;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.serverSocket = [[AsyncSocket alloc]initWithDelegate:self];
    //监听端口
    [self.serverSocket acceptOnPort:8000 error:nil];
    
    self.clientScoket = [[AsyncSocket alloc]initWithDelegate:self];
    [self.clientScoket connectToHost:@"192.168.188.207" onPort:8000 error:nil];
    
}
//监听到管道链接过来 但是并没连上呢
-(void)onSocket:(AsyncSocket *)sock didAcceptNewSocket:(AsyncSocket *)newSocket{
    self.myNewSocket = newSocket;
}
//管道打通
-(void)onSocket:(AsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port{
    NSLog(@"链接成功 对方ip：%@",host);
    //调用获取数据的方法
    [self.myNewSocket readDataWithTimeout:-1 tag:0];
}

-(void)onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag{
    NSString *info = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"接收到：%@",info);
    
    //接着要数据
     [sock readDataWithTimeout:-1 tag:0];
    
}
- (IBAction)clicked:(id)sender {
    
    NSData *data = [@"你好！" dataUsingEncoding:NSUTF8StringEncoding];
    [self.clientScoket writeData:data withTimeout:-1 tag:0];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
