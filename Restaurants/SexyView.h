//
//  SexyView.h
//  DishGo
//
//  Created by Philip Tolton on 2014-08-01.
//  Copyright (c) 2014 DishGo Inc. All rights reserved.
//

#import "TNSexyImageUploadProgress.h"

@interface SexyView : TNSexyImageUploadProgress
    @property UILabel *close;
    @property UIActivityIndicatorView *spinna;
    @property (nonatomic) float progress;
@end
