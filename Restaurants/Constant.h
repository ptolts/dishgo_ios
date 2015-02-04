//
//  Constant.h
//  DishGo
//
//  Created by Philip Tolton on 2014-06-04.
//  Copyright (c) 2014 DishGo Inc. All rights reserved.
//

//#define DEBUGGING true
//#define dev_debugging true
#define regular true

#ifdef DEBUGGING
    #define dishGoUrl @"http://192.168.1.132:3000"
//    #define dishGoUrl @"http://127.0.0.1:3000"
#endif

#ifdef dev_debugging
    #define dishGoUrl @"http://dishgo.ca"
#endif

#ifdef regular
//    #define dishGoUrl @"https://dishgo.io"
    #define dishGoUrl @"http://dishgo.ca"
#endif


