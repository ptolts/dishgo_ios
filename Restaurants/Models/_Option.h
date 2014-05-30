// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Option.h instead.

#import <CoreData/CoreData.h>


extern const struct OptionAttributes {
	__unsafe_unretained NSString *id;
	__unsafe_unretained NSString *name;
	__unsafe_unretained NSString *price;
	__unsafe_unretained NSString *price_according_to_size;
} OptionAttributes;

extern const struct OptionRelationships {
	__unsafe_unretained NSString *option_owner;
	__unsafe_unretained NSString *size_prices;
} OptionRelationships;

extern const struct OptionFetchedProperties {
} OptionFetchedProperties;

@class Options;
@class SizePrices;






@interface OptionID : NSManagedObjectID {}
@end

@interface _Option : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (OptionID*)objectID;





@property (nonatomic, strong) NSString* id;



//- (BOOL)validateId:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* name;



//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* price;



@property float priceValue;
- (float)priceValue;
- (void)setPriceValue:(float)value_;

//- (BOOL)validatePrice:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* price_according_to_size;



@property BOOL price_according_to_sizeValue;
- (BOOL)price_according_to_sizeValue;
- (void)setPrice_according_to_sizeValue:(BOOL)value_;

//- (BOOL)validatePrice_according_to_size:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) Options *option_owner;

//- (BOOL)validateOption_owner:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSSet *size_prices;

- (NSMutableSet*)size_pricesSet;





@end

@interface _Option (CoreDataGeneratedAccessors)

- (void)addSize_prices:(NSSet*)value_;
- (void)removeSize_prices:(NSSet*)value_;
- (void)addSize_pricesObject:(SizePrices*)value_;
- (void)removeSize_pricesObject:(SizePrices*)value_;

@end

@interface _Option (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveId;
- (void)setPrimitiveId:(NSString*)value;




- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;




- (NSNumber*)primitivePrice;
- (void)setPrimitivePrice:(NSNumber*)value;

- (float)primitivePriceValue;
- (void)setPrimitivePriceValue:(float)value_;




- (NSNumber*)primitivePrice_according_to_size;
- (void)setPrimitivePrice_according_to_size:(NSNumber*)value;

- (BOOL)primitivePrice_according_to_sizeValue;
- (void)setPrimitivePrice_according_to_sizeValue:(BOOL)value_;





- (Options*)primitiveOption_owner;
- (void)setPrimitiveOption_owner:(Options*)value;



- (NSMutableSet*)primitiveSize_prices;
- (void)setPrimitiveSize_prices:(NSMutableSet*)value;


@end
