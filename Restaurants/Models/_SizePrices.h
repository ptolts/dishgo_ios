// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to SizePrices.h instead.

#import <CoreData/CoreData.h>


extern const struct SizePricesAttributes {
	__unsafe_unretained NSString *id;
	__unsafe_unretained NSString *price;
	__unsafe_unretained NSString *related_to_size;
} SizePricesAttributes;

extern const struct SizePricesRelationships {
	__unsafe_unretained NSString *option;
	__unsafe_unretained NSString *size_option;
} SizePricesRelationships;

extern const struct SizePricesFetchedProperties {
} SizePricesFetchedProperties;

@class Option;
@class Option;





@interface SizePricesID : NSManagedObjectID {}
@end

@interface _SizePrices : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (SizePricesID*)objectID;





@property (nonatomic, strong) NSString* id;



//- (BOOL)validateId:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* price;



@property float priceValue;
- (float)priceValue;
- (void)setPriceValue:(float)value_;

//- (BOOL)validatePrice:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* related_to_size;



//- (BOOL)validateRelated_to_size:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) Option *option;

//- (BOOL)validateOption:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) Option *size_option;

//- (BOOL)validateSize_option:(id*)value_ error:(NSError**)error_;





@end

@interface _SizePrices (CoreDataGeneratedAccessors)

@end

@interface _SizePrices (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveId;
- (void)setPrimitiveId:(NSString*)value;




- (NSNumber*)primitivePrice;
- (void)setPrimitivePrice:(NSNumber*)value;

- (float)primitivePriceValue;
- (void)setPrimitivePriceValue:(float)value_;




- (NSString*)primitiveRelated_to_size;
- (void)setPrimitiveRelated_to_size:(NSString*)value;





- (Option*)primitiveOption;
- (void)setPrimitiveOption:(Option*)value;



- (Option*)primitiveSize_option;
- (void)setPrimitiveSize_option:(Option*)value;


@end
