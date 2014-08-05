// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Images.h instead.

#import <CoreData/CoreData.h>


extern const struct ImagesAttributes {
	__unsafe_unretained NSString *id;
	__unsafe_unretained NSString *url;
} ImagesAttributes;

extern const struct ImagesRelationships {
	__unsafe_unretained NSString *dishes;
	__unsafe_unretained NSString *relationship;
} ImagesRelationships;

extern const struct ImagesFetchedProperties {
} ImagesFetchedProperties;

@class Dishes;
@class Restaurant;




@interface ImagesID : NSManagedObjectID {}
@end

@interface _Images : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (ImagesID*)objectID;





@property (nonatomic, strong) NSString* id;



//- (BOOL)validateId:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* url;



//- (BOOL)validateUrl:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) Dishes *dishes;

//- (BOOL)validateDishes:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) Restaurant *relationship;

//- (BOOL)validateRelationship:(id*)value_ error:(NSError**)error_;





@end

@interface _Images (CoreDataGeneratedAccessors)

@end

@interface _Images (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveId;
- (void)setPrimitiveId:(NSString*)value;




- (NSString*)primitiveUrl;
- (void)setPrimitiveUrl:(NSString*)value;





- (Dishes*)primitiveDishes;
- (void)setPrimitiveDishes:(Dishes*)value;



- (Restaurant*)primitiveRelationship;
- (void)setPrimitiveRelationship:(Restaurant*)value;


@end
