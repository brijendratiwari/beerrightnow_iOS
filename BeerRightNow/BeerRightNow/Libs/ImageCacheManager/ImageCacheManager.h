//
//  ImageCacheManager.h
//  SupaSale
//
//  Created by JYN on 10/24/13.
//  Copyright (c) 2013 jackiejin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageCacheManager : NSObject
+(void) initCacheDirectory;
+(void) setImageView: (UIImageView*) imageView withUrlString: (NSString *) urlString;
+(NSString*) imageLocalPathWithUrlString: (NSString *) urlString;
@end
