#import <Foundation/Foundation.h>
#import <Cordova/CDVPlugin.h>
#import <Cordova/CDVPluginResult.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "CDVClipboard.h"

@implementation CDVClipboard

- (void)copy:(CDVInvokedUrlCommand*)command {
	[self.commandDelegate runInBackground:^{
		NSString *html = [command.arguments objectAtIndex:0];
		NSData *data =  [html dataUsingEncoding:NSUTF8StringEncoding];
		NSDictionary *dict = @{@"WebMainResource": @{@"WebResourceData": data, @"WebResourceFrameName": @"", @"WebResourceMIMEType": @"text/html", @"WebResourceTextEncodingName": @"UTF-8", @"WebResourceURL": @"about:blank"}};
		data = [NSPropertyListSerialization dataWithPropertyList:dict format:NSPropertyListXMLFormat_v1_0 options:0 error:nil];
		NSString *archive = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
		NSAttributedString *decodedString = [[NSAttributedString alloc] initWithData:data
										     options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType}
									  documentAttributes:NULL
										       error:NULL];
		[UIPasteboard generalPasteboard].items = @[@{@"Apple Web Archive pasteboard type": archive, (id)kUTTypeUTF8PlainText: [decodedString string]}];
		CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:archive];
		[self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
	}];
}

- (void)paste:(CDVInvokedUrlCommand*)command {
	[self.commandDelegate runInBackground:^{
		UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
		NSString     *text       = [pasteboard valueForPasteboardType:@"public.text"];
	    
	    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:text];
	    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
	}];
}

@end
