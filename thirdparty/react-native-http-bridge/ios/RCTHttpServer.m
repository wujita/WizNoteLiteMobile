#import "RCTHttpServer.h"
#import "React/RCTBridge.h"
#import "React/RCTEventEmitter.h"
#import "React/RCTLog.h"
#import "React/RCTEventDispatcher.h"

#import "GCDWebServer.h"
#import "GCDWebServerDataResponse.h"
#import "GCDWebServerDataRequest.h"
#import "GCDWebServerPrivate.h"
#include <stdlib.h>

@interface RCTHttpServer : RCTEventEmitter <RCTBridgeModule> {
    GCDWebServer* _webServer;
    NSMutableDictionary* _completionBlocks;
}
@end

@implementation RCTHttpServer

RCT_EXPORT_MODULE();

+ (id)allocWithZone:(NSZone *)zone {
    static RCTHttpServer *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [super allocWithZone:zone];
    });
    return sharedInstance;
}

- (NSArray<NSString *> *)supportedEvents
{
    return @[@"httpServerResponseReceived"];
}

- (void)initResponseReceivedFor:(GCDWebServer *)server forType:(NSString*)type {
    [server addDefaultHandlerForMethod:type
                          requestClass:[GCDWebServerDataRequest class]
                     asyncProcessBlock:^(GCDWebServerRequest* request, GCDWebServerCompletionBlock completionBlock) {
        
        long long milliseconds = (long long)([[NSDate date] timeIntervalSince1970] * 1000.0);
        int r = arc4random_uniform(1000000);
        NSString *requestId = [NSString stringWithFormat:@"%lld:%d", milliseconds, r];

        
         @synchronized (self) {
             if (!self->_completionBlocks) {
                 self->_completionBlocks = [[NSMutableDictionary alloc] init];
             }
             [self->_completionBlocks setObject:completionBlock forKey:requestId];
         }

        @try {
            if ([GCDWebServerTruncateHeaderValue(request.contentType) isEqualToString:@"application/json"]) {
                GCDWebServerDataRequest* dataRequest = (GCDWebServerDataRequest*)request;
                [self sendEventWithName:@"httpServerResponseReceived" body:@{@"requestId": requestId, @"postData": dataRequest.jsonObject, @"type": type, @"url": request.URL.relativeString}];
            } else {
                [self sendEventWithName:@"httpServerResponseReceived" body:@{@"requestId": requestId, @"type": type, @"url": request.URL.relativeString}];
            }
        } @catch (NSException *exception) {
            [self sendEventWithName:@"httpServerResponseReceived" body:@{@"requestId": requestId, @"type": type, @"url": request.URL.relativeString}];
        }
    }];
}

RCT_EXPORT_METHOD(start:(NSInteger) port
                  serviceName:(NSString *) serviceName)
{
    RCTLogInfo(@"Running HTTP bridge server: %ld", port);
    if (_webServer) {
        RCTLogInfo(@"_web server has already running");
        return;
    }
    
    dispatch_sync(dispatch_get_main_queue(), ^{
        _webServer = [[GCDWebServer alloc] init];
        
//        [self initResponseReceivedFor:_webServer forType:@"POST"];
//        [self initResponseReceivedFor:_webServer forType:@"PUT"];
        [self initResponseReceivedFor:_webServer forType:@"GET"];
//        [self initResponseReceivedFor:_webServer forType:@"DELETE"];
        
        NSMutableDictionary* options = [NSMutableDictionary dictionary];
        [options setObject:[NSNumber numberWithInteger:port] forKey:GCDWebServerOption_Port];
        [options setValue:serviceName forKey:GCDWebServerOption_BonjourName];
        [options setValue:[NSNumber numberWithBool:YES] forKey:GCDWebServerOption_BindToLocalhost];
        NSError* error = nil;
        [_webServer startWithOptions:options error:&error];
        if (error) {
            RCTLogError(@"failed to start web server: %@", error);
        }
    });
}

RCT_EXPORT_METHOD(stop)
{
    RCTLogInfo(@"Stopping HTTP bridge server");
    
    if (_webServer != nil) {
        [_webServer stop];
        [_webServer removeAllHandlers];
        _webServer = nil;
    }
}

RCT_EXPORT_METHOD(respond: (NSString *) requestId
                  code: (NSInteger) code
                  type: (NSString *) type
                  body: (NSString *) body)
{
    NSData* data = [body dataUsingEncoding:NSUTF8StringEncoding];
    GCDWebServerDataResponse* requestResponse = [[GCDWebServerDataResponse alloc] initWithData:data contentType:type];
    requestResponse.statusCode = code;

    GCDWebServerCompletionBlock completionBlock = nil;
    @synchronized (self) {
        completionBlock = [_completionBlocks objectForKey:requestId];
        [_completionBlocks removeObjectForKey:requestId];
    }

    completionBlock(requestResponse);
}

RCT_EXPORT_METHOD(respondWithFile: (NSString *) requestId
                  code: (NSInteger) code
                  type: (NSString *) type
                  file: (NSString *) file)
{
    NSData* data = [NSData dataWithContentsOfFile:file];
    GCDWebServerDataResponse* requestResponse = [[GCDWebServerDataResponse alloc] initWithData:data contentType:type];
    requestResponse.statusCode = code;
    requestResponse.cacheControlMaxAge = 31536000;

    GCDWebServerCompletionBlock completionBlock = nil;
    @synchronized (self) {
        completionBlock = [_completionBlocks objectForKey:requestId];
        [_completionBlocks removeObjectForKey:requestId];
    }

    if (!completionBlock) return;
    //
    completionBlock(requestResponse);
}

@end
