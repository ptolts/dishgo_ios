// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Restaurant.h instead.

#import <CoreData/CoreData.h>


extern const struct RestaurantAttributes {
	__unsafe_unretained NSString *id;
	__unsafe_unretained NSString *lat;
	__unsafe_unretained NSString *lon;
	__unsafe_unretained NSString *name;
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





@property (nonatomic, strong) NSSet *images;

- (NSMutableSet*)imagesSet;




@property (nonatomic, strong) NSSet *menu;

- (NSMutableSet*)menuSet;





@end

@interface _Restaurant (CoreDataGeneratedAccessors)

- (void)addImages:(NSSet*)value_;
- (void)removeImages:(NSSet*)value_;
- (void)addImagesObject:(Images*)value_;
- (void)removeImagesObject:(Images*)value_;

- (void)addMenu:(NSSet*)value_;
- (void)removeMenu:(NSSet*)value_;
- (void)addMenuObject:(Sections*)value_;
- (void)removeMenuObject:(Sections*)value_;

@end

@interface _Restaurant (CoreDataGeneratedPrimitiveAccessors)


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





- (NSMutableSet*)primitiveImages;
- (void)setPrimitiveImages:(NSMutableSet*)value;



- (NSMutableSet*)primitiveMenu;
- (void)setPrimitiveMenu:(NSMutableSet*)value;


@end
