// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to RestaurantOld.h instead.

#import <CoreData/CoreData.h>


extern const struct RestaurantOldAttributes {
	__unsafe_unretained NSString *address;
	__unsafe_unretained NSString *city;
	__unsafe_unretained NSString *distance;
	__unsafe_unretained NSString *does_delivery;
	__unsafe_unretained NSString *hours;
	__unsafe_unretained NSString *id;
	__unsafe_unretained NSString *lat;
	__unsafe_unretained NSString *lon;
	__unsafe_unretained NSString *name;
	__unsafe_unretained NSString *phone;
	__unsafe_unretained NSString *postal_code;
	__unsafe_unretained NSString *prizes;
} RestaurantOldAttributes;

extern const struct RestaurantOldRelationships {
	__unsafe_unretained NSString *images;
	__unsafe_unretained NSString *menu;
} RestaurantOldRelationships;

extern const struct RestaurantOldFetchedProperties {
} RestaurantOldFetchedProperties;

@class Images;
@class Sections;





@class NSObject;








@interface RestaurantOldID : NSManagedObjectID {}
@end

@interface _RestaurantOld : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (RestaurantOldID*)objectID;





@property (nonatomic, strong) NSString* address;



//- (BOOL)validateAddress:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* city;



//- (BOOL)validateCity:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* distance;



@property float distanceValue;
- (float)distanceValue;
- (void)setDistanceValue:(float)value_;

//- (BOOL)validateDistance:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* does_delivery;



@property BOOL does_deliveryValue;
- (BOOL)does_deliveryValue;
- (void)setDoes_deliveryValue:(BOOL)value_;

//- (BOOL)validateDoes_delivery:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) id hours;



//- (BOOL)validateHours:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* id;



//- (BOOL)validateId:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* lat;



@property double latValue;
- (double)latValue;
- (void)setLatValue:(double)value_;

//- (BOOL)validateLat:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* lon;



@property double lonValue;
- (double)lonValue;
- (void)setLonValue:(double)value_;

//- (BOOL)validateLon:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* name;



//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* phone;



//- (BOOL)validatePhone:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* postal_code;



//- (BOOL)validatePostal_code:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* prizes;



@property int16_t prizesValue;
- (int16_t)prizesValue;
- (void)setPrizesValue:(int16_t)value_;

//- (BOOL)validatePrizes:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSOrderedSet *images;

- (NSMutableOrderedSet*)imagesSet;




@property (nonatomic, strong) NSOrderedSet *menu;

- (NSMutableOrderedSet*)menuSet;





@end

@interface _RestaurantOld (CoreDataGeneratedAccessors)

- (void)addImages:(NSOrderedSet*)value_;
- (void)removeImages:(NSOrderedSet*)value_;
- (void)addImagesObject:(Images*)value_;
- (void)removeImagesObject:(Images*)value_;

- (void)addMenu:(NSOrderedSet*)value_;
- (void)removeMenu:(NSOrderedSet*)value_;
- (void)addMenuObject:(Sections*)value_;
- (void)removeMenuObject:(Sections*)value_;

@end

@interface _RestaurantOld (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveAddress;
- (void)setPrimitiveAddress:(NSString*)value;




- (NSString*)primitiveCity;
- (void)setPrimitiveCity:(NSString*)value;




- (NSNumber*)primitiveDistance;
- (void)setPrimitiveDistance:(NSNumber*)value;

- (float)primitiveDistanceValue;
- (void)setPrimitiveDistanceValue:(float)value_;




- (NSNumber*)primitiveDoes_delivery;
- (void)setPrimitiveDoes_delivery:(NSNumber*)value;

- (BOOL)primitiveDoes_deliveryValue;
- (void)setPrimitiveDoes_deliveryValue:(BOOL)value_;




- (id)primitiveHours;
- (void)setPrimitiveHours:(id)value;




- (NSString*)primitiveId;
- (void)setPrimitiveId:(NSString*)value;




- (NSNumber*)primitiveLat;
- (void)setPrimitiveLat:(NSNumber*)value;

- (double)primitiveLatValue;
- (void)setPrimitiveLatValue:(double)value_;




- (NSNumber*)primitiveLon;
- (void)setPrimitiveLon:(NSNumber*)value;

- (double)primitiveLonValue;
- (void)setPrimitiveLonValue:(double)value_;




- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;




- (NSString*)primitivePhone;
- (void)setPrimitivePhone:(NSString*)value;




- (NSString*)primitivePostal_code;
- (void)setPrimitivePostal_code:(NSString*)value;




- (NSNumber*)primitivePrizes;
- (void)setPrimitivePrizes:(NSNumber*)value;

- (int16_t)primitivePrizesValue;
- (void)setPrimitivePrizesValue:(int16_t)value_;





- (NSMutableOrderedSet*)primitiveImages;
- (void)setPrimitiveImages:(NSMutableOrderedSet*)value;



- (NSMutableOrderedSet*)primitiveMenu;
- (void)setPrimitiveMenu:(NSMutableOrderedSet*)value;


@end
