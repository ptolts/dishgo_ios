// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Option.h instead.

#import <CoreData/CoreData.h>


extern const struct OptionAttributes {
	__unsafe_unretained NSString *id;
	__unsafe_unretained NSString *name;
	__unsafe_unretained NSString *price;
} OptionAttributes;

extern const struct OptionRelationships {
	__unsafe_unretained NSString *option_owner;
} OptionRelationships;

extern const struct OptionFetchedProperties {
} OptionFetchedProperties;

@class Options;





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





@property (nonatomic, strong) Options *option_owner;

//- (BOOL)validateOption_owner:(id*)value_ error:(NSError**)error_;





@end

@interface _Option (CoreDataGeneratedAccessors)

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





- (Options*)primitiveOption_owner;
- (void)setPrimitiveOption_owner:(Options*)value;


@end
