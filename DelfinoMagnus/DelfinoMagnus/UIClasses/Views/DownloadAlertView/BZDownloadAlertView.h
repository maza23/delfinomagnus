//
//  BZDownloadAlertView.h
//  Buzz
//
//  Created by Avadesh Kumar on 10/04/13.
//  Copyright (c) 2013 Telibrahma. All rights reserved.
//

#define kAlertDisplayTime 3.0

typedef enum {
   
    BZDownloadAlertViewAlertStyleCompleted,
    BZDownloadAlertViewAlertStyleInformation

}BZDownloadAlertViewAlertStyle;

@interface BZDownloadAlertView : UIView

- (void)displayAlertViewWithMessage:(NSString *)alertMessage andAlertStyle:(BZDownloadAlertViewAlertStyle)alertStyle;

@end
