// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Restaurant.h instead.

#import <CoreData/CoreData.h>


extern const struct RestaurantAttributes {
	__unsafe_unretained NSString *address;
	__unsafe_unretained NSString *id;
	__unsafe_unretained NSString *lat;
	__unsafe_unretained NSString *lon;
	__unsafe_unretained NSString *name;
	__unsafe_unretained NSString *phone;
} RestaurantAttributes;

extern const struct RestaurantRelationships {
	__unsafe_unretained NSString *images;
	__unsafe_unretained NSString *menu;
} RestaurantRelationships;

extern const struct RestaurantFetchedProperties {
} RestaurantFetchedProperties;

@class Images;
@class Sections;








@interface RestaurantID : NSManagedObjectID {}
@end

@interface _Restaurant : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (RestaurantID*)objectID;





@property (nonatomic, strong) NSString* address;



//- (BOOL)validateAddress:(id*)value_ error:(NSError**)error_;





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





@property (nonatomic, strong) NSOrderedSet *images;

- (NSMutableOrderedSet*)imagesSet;




@property (nonatomic, strong) NSOrderedSet *menu;

- (NSMutableOrderedSet*)menuSet;





@end

@interface _Restaurant (CoreDataGeneratedAccessors)

- (void)addImages:(NSOrderedSet*)value_;
- (void)removeImages:(NSOrderedSet*)value_;
- (void)addImagesObject:(Images*)value_;
- (void)removeImagesObject:(Images*)value_;

- (void)addMenu:(NSOrderedSet*)value_;
- (void)removeMenu:(NSOrderedSet*)value_;
- (void)addMenuObject:(Sections*)value_;
- (void)removeMenuObject:(Sections*)value_;

@end

@interface _Restaurant (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveAddress;
- (void)setPrimitiveAddress:(NSString*)value;




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





- (NSMutableOrderedSet*)primitiveImages;
- (void)setPrimitiveImages:(NSMutableOrderedSet*)value;



- (NSMutableOrderedSet*)primitiveMenu;
- (void)setPrimitiveMenu:(NSMutableOrderedSet*)value;


@end
