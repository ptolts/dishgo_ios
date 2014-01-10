//
//  NSMutableArray+ShoppingCartArray.h
//  Restaurants
//
//  Created by Philip Tolton on 1/10/2014.
//  Copyright (c) 2014 Philip Tolton. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableArray (ShoppingCartArray)
    -(void) saveShoppingCart;
    -(void) addObjectThenSave:(id)anObject;
    @property (nonatomic, retain) id ident;
@end

//
//@interface UIView (ObjectTagAdditions)
//
//@property (nonatomic, retain) id objectTag;
//
//- (UIView *)viewWithObjectTag:(id)object;
//
//@end
//Using associative references, the implementation of the property is straightforward:
//
//#import <objc/runtime.h>
//
//static char const * const ObjectTagKey = "ObjectTag";
//
//@implementation UIView (ObjectTagAdditions)
//@dynamic objectTag;
//
//- (id)objectTag {
//    return objc_getAssociatedObject(self, ObjectTagKey);
//}
//
//- (void)setObjectTag:(id)newObjectTag {
//    objc_setAssociatedObject(self, ObjectTagKey, newObjectTag, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//}
