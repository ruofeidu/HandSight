//
//  CommonTextController.h
//  HandSight
//
//  Created by Ruofei Du on 8/12/14.
//  Copyright (c) 2014 Ruofei Du. All rights reserved.
//

#import "CommonController.h"
#import "HSMultiView.h"
#import "HSViz.h"

@interface CommonTextController : CommonController {
    UIButton* m_btnBack;
    UISegmentedControl* m_seg; 
    HSMultiView *m_text;
    HSViz *m_viz;
}
- (void)addControls;
- (void)switchView;

@end
