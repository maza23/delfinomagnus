//
//  LTCoreDataManager.m
//  DelfinoMagnus
//
//  Created by Avadesh Kumar on 5/8/14.
//  Copyright (c) 2014 Delfino. All rights reserved.
//


#import "LTCoreDataManager.h"
#import "Device.h"
#import "FavoriteDevice.h"
#import "User.h"
#import "DeviceDetails.h"
#import "Images.h"
#import "Zona.h"
#import "Tipo.h"
#import "ReservedDevice.h"
#import "Calendar.h"

@interface LTCoreDataManager () {
}

@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@end

@implementation LTCoreDataManager

static LTCoreDataManager *sharedSingletonObject = nil;

@synthesize managedObjectContext = __managedObjectContext;
@synthesize managedObjectModel = __managedObjectModel;
@synthesize persistentStoreCoordinator = __persistentStoreCoordinator;

#pragma mark - Memory Allocation Life Cycle

+ (LTCoreDataManager *)sharedInstance {
    
    if (sharedSingletonObject) {
        return sharedSingletonObject;
    }
    
    static dispatch_once_t pred;        // Lock
    dispatch_once(&pred, ^{             // This code is called at most once per app
        sharedSingletonObject = [[LTCoreDataManager alloc] init];
    });
    
    return sharedSingletonObject;
}


- (void)dealloc
{
    [self saveContext];
    [super dealloc];
}

- (void)awakeFromInsert
{
    [super awakeFromInsert];
}

#pragma mark - Public Methods to call
- (void)insertDevicesResultIntoDBFromRawResponse:(NSDictionary *)rawResponse
{
    NSArray *rawDevices = [rawResponse objectForKey:@"devices"];
    
    if (rawDevices) {
        [self insertDevicesIntoDBFromRawArray:rawDevices];
    }
    
    NSArray *rawZonas = [rawResponse objectForKey:@"zonas"];
    
    if (rawZonas) {
        [self insertZonasListIntoDBFromRawArray:rawZonas];
    }
    
    NSArray *rawTipos = [rawResponse objectForKey:@"tipos"];
    
    if (rawTipos) {
        [self insertTiposListIntoDBFromRawArray:rawTipos];
    }
    
}


- (void)insertDeviceDetalisIntoDBFromRawResponse:(NSDictionary *)rawResponse
{
 
    NSDictionary *deviceDetails = [rawResponse objectForKey:@"device"];
    
    NSString *deviceId = [deviceDetails objectForKey:@"id"];
    
    if (!deviceId) {
        return;
    }
    
    DeviceDetails *device = [[self getRecordsFromEntity:kDeviceDetailsEntityName forAttribute:@"deviceId" withKey:deviceId] lastObject];
    
    if (!device) {
        device = [NSEntityDescription insertNewObjectForEntityForName:kDeviceDetailsEntityName
                                               inManagedObjectContext:self.managedObjectContext];
        [device setDeviceId:deviceId];
        
    }
    
    NSString * titulo = [deviceDetails objectForKey:@"titulo"];
    NSString * zona = [deviceDetails objectForKey:@"zona"];
    
    NSString * tipo = [deviceDetails objectForKey:@"tipo"];
    NSString * disponible = [deviceDetails objectForKey:@"disponible"];
    NSString * fechaalta = [deviceDetails objectForKey:@"fechaalta"];
    NSString * fechamodif = [deviceDetails objectForKey:@"fechamodif"];
    NSString * orden = [deviceDetails objectForKey:@"orden"];
    NSString *urlimgs = [rawResponse objectForKey:@"urlimgs"];
    NSString * latitude = nil;
    NSString * longitude = nil;
    NSString * htmldescripcion = nil;
    NSString * deviceDescription = nil;
    
    NSDictionary *data = [deviceDetails valueForKeyPath:@"data"];
    
    if (data) {
        latitude = [data valueForKeyPath:@"geopos.lat"];
        longitude = [data valueForKeyPath:@"geopos.long"];
        htmldescripcion = [data objectForKey:@"htmldescripcion"];
        deviceDescription = [data objectForKey:@"descripcion"];
    }
    
    if (titulo)
        [device setTitulo:titulo];
    
    if (zona)
        [device setZona:zona];
    
    if (tipo)
        [device setTipo:tipo];
    
    if (disponible)
        [device setDisponible:disponible];
    
    if (fechaalta)
        [device setFechaalta:fechaalta];
    
    if (fechamodif)
        [device setFechamodif:fechamodif];
    
    if (orden)
        [device setOrden:orden];
    
    if (latitude)
        [device setLatitude:latitude];
    
    if (longitude)
        [device setLongitude:longitude];
    
    if (htmldescripcion)
        [device setHtmlDescription:htmldescripcion];
    
    if (deviceDescription)
        [device setDeviceDescription:deviceDescription];
    
    if ([[rawResponse objectForKey:@"images"] count]) {
        [device setImages:[self insertImagesIntoDataBaseFromImagesArray:[rawResponse objectForKey:@"images"] withDevice:device]];
    }
    
    if ([[rawResponse objectForKey:@"calendar"] count]) {
        [device setCalendars:[self insertCalendarsIntoDataBaseFromCalendarsArray:[rawResponse objectForKey:@"calendar"] withDevice:device]];
    }
    
    if (urlimgs)
        [device setUrlimgs:urlimgs];
    
    [self saveContext];
}

/*
 @property (nonatomic, retain) NSString * userId;
 @property (nonatomic, retain) NSString * regId;
 @property (nonatomic, retain) NSString * nombre;
 @property (nonatomic, retain) NSString * apellido;
 @property (nonatomic, retain) NSString * email;
 @property (nonatomic, retain) NSString * actividad;
 @property (nonatomic, retain) NSString * empresa;
 @property (nonatomic, retain) NSString * direccion;
 @property (nonatomic, retain) NSString * tel;
 @property (nonatomic, retain) NSString * image_file;
 @property (nonatomic, retain) NSString * image_width;
 @property (nonatomic, retain) NSString * image_height;
 @property (nonatomic, retain) NSString * fechamodif;
 @property (nonatomic, retain) NSString * urlimgs;

 {
 actividad = Programmer;
 apellido = Mazaeda;
 data =         {
 imagen =             {
 file = "img139769409466420140416212153.jpg";
 height = 1600;
 width = 1200;
 };
 };
 direccion = "No s\U00e9 por ah\U00ed.";
 email = "nose@gmail.com";
 empresa = Insotec;
 fechamodif = "2014-05-09 09:48:48";
 id = 3;
 nombre = Pablo;
 regid = "APA91bFahcYOiFBCN1dgJipHWGDdMd_Y-wyJR-IuR_9HPuDCrRoYZS0klTvWEwASYHzITzLhhlqIkDG2f69-CnEmVzlEYIIbHlKneVsxBAKUkq2kLT3Zzc9MLmn0ANPPJlFRFzFM60ogZHO1nGSkERn4Cw1_kp3f3Q";
 tel = "<null>";
 urlimgs = "http://delfinomagnus.com/frontend/imgs/appusers";
 }
 */
- (void)insertUserDetailsIntoDBFromRawResponse:(NSDictionary *)rawResponse
{
    NSString *userId = [rawResponse objectForKey:@"id"];
    User *user = [[self getRecordsFromEntity:kUserEntityName forAttribute:@"userId" withKey:userId] lastObject];
    
    if (!user) {
        user = [NSEntityDescription insertNewObjectForEntityForName:kUserEntityName
                                               inManagedObjectContext:self.managedObjectContext];
        
    }
    
    NSString *regId = [rawResponse objectForKey:@"regid"];
    NSString *nombre = [rawResponse objectForKey:@"nombre"];
    NSString *apellido = [rawResponse objectForKey:@"apellido"];
    NSString *email = [rawResponse objectForKey:@"email"];
    NSString *actividad = [rawResponse objectForKey:@"actividad"];
    NSString *empresa = [rawResponse objectForKey:@"empresa"];
    NSString *direccion = [rawResponse objectForKey:@"direccion"];
    NSString *tel = [rawResponse objectForKey:@"tel"];
    NSString *image_file = [rawResponse valueForKeyPath:@"data.imagen.file"];
    NSString *image_width = [rawResponse valueForKeyPath:@"data.imagen.height"];
    NSString *image_height = [rawResponse valueForKeyPath:@"data.imagen.width"];
    NSString *fechamodif = [rawResponse objectForKey:@"fechamodif"];
    NSString *urlimgs = [rawResponse objectForKey:@"urlimgs"];
    
    if (regId && ![regId isKindOfClass:[NSNull class]])
        user.regId = regId;

    if (nombre && ![nombre isKindOfClass:[NSNull class]])
        user.nombre = nombre;

    if (apellido && ![apellido isKindOfClass:[NSNull class]])
        user.apellido = apellido;

    if (email && ![email isKindOfClass:[NSNull class]])
        user.email = email;

    if (actividad && ![actividad isKindOfClass:[NSNull class]])
        user.actividad = actividad;

    if (empresa && ![empresa isKindOfClass:[NSNull class]])
        user.empresa = empresa;

    if (direccion && ![direccion isKindOfClass:[NSNull class]])
        user.direccion = direccion;

    if (tel && ![tel isKindOfClass:[NSNull class]])
        user.tel = tel;

    if (image_file && ![image_file isKindOfClass:[NSNull class]])
        user.image_file = image_file;

    if (image_width && ![image_width isKindOfClass:[NSNull class]])
        user.image_width = [NSString stringWithFormat:@"%@", image_width];

    if (image_height && ![image_height isKindOfClass:[NSNull class]])
        user.image_height = [NSString stringWithFormat:@"%@", image_height];

    if (fechamodif && ![fechamodif isKindOfClass:[NSNull class]])
        user.fechamodif = fechamodif;
    
    if (urlimgs && ![urlimgs isKindOfClass:[NSNull class]])
        user.urlimgs = urlimgs;
    
    
    [self saveContext];
}

- (void)insertFavoritesListIntoDBFromRawResponse:(NSArray *)devicesList
{
    if ([devicesList count]) {
        [self removeAllRowsFromEntity:kFavortiesEntityName];
    }
    
    for (NSDictionary *rawDevice in devicesList) {
        
        NSString *deviceId = [rawDevice objectForKey:@"id"];
        
        if (!deviceId) {
            continue;
        }
        
        FavoriteDevice *device = [[self getRecordsFromEntity:kFavortiesEntityName forAttribute:@"deviceId" withKey:deviceId] lastObject];
        
        if (!device) {
            device = [NSEntityDescription insertNewObjectForEntityForName:kFavortiesEntityName
                                                   inManagedObjectContext:self.managedObjectContext];
            
            device.deviceId = deviceId;
            
        }
        
        NSString *fechaalta = [rawDevice objectForKey:@"fechaalta"];
        
        if (fechaalta) {
            device.fechaalta = fechaalta;
        }
    }
    
    [self saveContext];
}


#pragma mark - Private Methods
/*
 * deviceId;
 @property (nonatomic, retain) NSString * titulo;
 @property (nonatomic, retain) NSString * zona;
 @property (nonatomic, retain) NSString * tipo;
 @property (nonatomic, retain) NSString * disponible;
 @property (nonatomic, retain) NSString * fechaalta;
 @property (nonatomic, retain) NSString * fechamodif;
 @property (nonatomic, retain) NSString * orden;
 @property (nonatomic, retain) NSString * latitude;
 @property (nonatomic, retain) NSString * longitude;
 @property (nonatomic, retain) NSString * htmldescripcion;
 */
- (void)insertDevicesIntoDBFromRawArray:(NSArray *)rawDevices
{
    if ([rawDevices count]) {
        [self removeAllRowsFromEntity:kDevicesEntityName];
    }
    
    for (NSDictionary *deviceDetails in rawDevices) {
        
        NSString *deviceId = [deviceDetails objectForKey:@"id"];
        if (!deviceId) {
            continue;
        }
        
      Device *device = [[self getRecordsFromEntity:kDevicesEntityName forAttribute:@"deviceId" withKey:deviceId] lastObject];
        
        if (!device) {
            device = [NSEntityDescription insertNewObjectForEntityForName:kDevicesEntityName
                                                   inManagedObjectContext:self.managedObjectContext];
            [device setDeviceId:deviceId];

        }
        
        NSString * titulo = [deviceDetails objectForKey:@"titulo"];
        NSString * zona = [deviceDetails objectForKey:@"zona"];

        NSString * tipo = [deviceDetails objectForKey:@"tipo"];
        NSString * disponible = [deviceDetails objectForKey:@"disponible"];
        NSString * fechaalta = [deviceDetails objectForKey:@"fechaalta"];
        NSString * fechamodif = [deviceDetails objectForKey:@"fechamodif"];
        NSString * orden = [deviceDetails objectForKey:@"orden"];
        NSString * latitude = nil;
        NSString * longitude = nil;
        NSString * htmldescripcion = nil;
        NSString * deviceDescription = nil;
        
        if ([disponible isKindOfClass:[NSNull class]]) {
            disponible = @"NO";
        }
        
        NSDictionary *data = [deviceDetails valueForKeyPath:@"data"];
        
        if (data) {
            latitude = [data valueForKeyPath:@"geopos.lat"];
            longitude = [data valueForKeyPath:@"geopos.long"];
            htmldescripcion = [data objectForKey:@"htmldescripcion"];
            deviceDescription = [data objectForKey:@"descripcion"];
        }
        
        if (titulo)
            [device setTitulo:titulo];
     
        if (zona)
            [device setZona:zona];
        
        if (tipo)
            [device setTipo:tipo];
        
        if (disponible)
            [device setDisponible:disponible];
        
        if (fechaalta)
            [device setFechaalta:fechaalta];
        
        if (fechamodif)
            [device setFechamodif:fechamodif];
        
        if (orden)
            [device setOrden:orden];
        
        if (latitude)
            [device setLatitude:latitude];
        
        if (longitude)
            [device setLongitude:longitude];
        
        if (htmldescripcion)
            [device setHtmldescripcion:htmldescripcion];
        
        if (deviceDescription)
            [device setDevicedescription:deviceDescription];
    }
    
    [self saveContext];
}

/*
 archivo;
 @property (nonatomic, retain) NSString * height;
 @property (nonatomic, retain) NSString * width;
 @property (nonatomic, retain) NSString * minHeight;
 @property (nonatomic, retain) NSString * minWidth;
 @property (nonatomic, retain) NSString * fechahora;
 @property (nonatomic, retain) NSString * imageId;
 @property (nonatomic, retain) NSString * orden;
 images =     (
 {
 archivo = "au-25-de-mayo-zuviria-729.jpg";
 data =             {
 height = 488;
 minheight = 150;
 minwidth = 200;
 width = 650;
 };
 fechahora = "2014-04-23 16:10:20";
 id = 1;
 orden = 1;
 }
 );*/
- (NSSet *)insertImagesIntoDataBaseFromImagesArray:(NSArray *)rawImages withDevice:(DeviceDetails *)device
{
    NSMutableSet *imagesToReturn = [[NSMutableSet alloc]  initWithCapacity:0];
    
    for (NSDictionary *rawImage in rawImages) {
        
        NSString *imageId = [rawImage objectForKey:@"id"];
        if (!imageId) {
            continue;
        }
        
        Images *image = [[self getRecordsFromEntity:kImagesEnityName forColumn1:@"imageId" withValue1:imageId andColumn2:@"deviceId" withValue2:device.deviceId] lastObject];
                
        if (!image) {
            image = [NSEntityDescription insertNewObjectForEntityForName:kImagesEnityName
                                                   inManagedObjectContext:self.managedObjectContext];
            [image setImageId:imageId];
            [image setDeviceId:device.deviceId];
        }
        
        NSString *archivo = [rawImage objectForKey:@"archivo"];
        NSString *height = [rawImage valueForKeyPath:@"data.height"];
        NSString *width = [rawImage valueForKeyPath:@"data.width"];
        NSString *minHeight = [rawImage valueForKeyPath:@"data.minheight"];
        NSString *minWidth = [rawImage valueForKeyPath:@"data.minwidth"];
        NSString *fechahora = [rawImage objectForKey:@"fechahora"];
        NSString *orden = [rawImage objectForKey:@"orden"];
        
        if (archivo)
            image.archivo = archivo;
        
        if (height)
            image.height = [NSString stringWithFormat:@"%@", height];
        
        if (width)
            image.width = [NSString stringWithFormat:@"%@", width];
        
        if (minHeight)
            image.minHeight = [NSString stringWithFormat:@"%@", minHeight];
        
        if (minWidth)
            image.minWidth = [NSString stringWithFormat:@"%@", minWidth];
        
        if (fechahora)
            image.fechahora = fechahora;
        
        if (orden)
            image.orden = orden;
        
        if (device)
            image.device = device;
        
        
        
        [imagesToReturn addObject:image];
    }
    
    return imagesToReturn;
}

//"calendar":[{"fecha":"2014-05-21","disponible":"NO"},{"fecha":"2014-06-07","disponible":"SI"},{"fecha":"2014-07-18","disponible":"NO"},{"fecha":"2014-12-31","disponible":"SI"}]
- (NSSet *)insertCalendarsIntoDataBaseFromCalendarsArray:(NSArray *)rawCalendars withDevice:(DeviceDetails *)device
{
    
    [self removeFromEntity:kCalendarEntityName forAttribute:@"deviceId" recordWithKey:device.deviceId];
    
    NSMutableSet *calendarsToReturn = [[NSMutableSet alloc]  initWithCapacity:0];
    
    for (NSDictionary *calendarDetails in rawCalendars) {
        
        Calendar *calendar = [NSEntityDescription insertNewObjectForEntityForName:kCalendarEntityName
                                                           inManagedObjectContext:self.managedObjectContext];
        
        NSString *fecha = [calendarDetails objectForKey:@"fecha"];
        NSString *disponible = [calendarDetails valueForKeyPath:@"disponible"];
        
        if (fecha)
            calendar.fecha = fecha;
        
        if (disponible)
            calendar.disponible = disponible;
        
        calendar.deviceId = device.deviceId;
        
        if (device)
            calendar.device = device;
        
        [calendarsToReturn addObject:calendar];
    }
    
    return calendarsToReturn;
}

- (void)insertZonasListIntoDBFromRawArray:(NSArray *)zonas
{
    for (NSDictionary *zonaDetails in zonas) {
        
        NSString *zonaId = [zonaDetails objectForKey:@"id"];
        Zona *zona = [[self getRecordsFromEntity:kZonaEntityName forAttribute:@"zonaId" withKey:zonaId] lastObject];
        
        if (!zona) {
            zona = [NSEntityDescription insertNewObjectForEntityForName:kZonaEntityName
                                                  inManagedObjectContext:self.managedObjectContext];
            [zona setZonaId:zonaId];
        }

        NSString *name = [zonaDetails objectForKey:@"nombre"];
        
        if (name) {
            zona.name = name;
        }
    }
    
    [self saveContext];
}

- (void)insertTiposListIntoDBFromRawArray:(NSArray *)tipos
{
    for (NSDictionary *tipoDetails in tipos) {
        
        NSString *tipoId = [tipoDetails objectForKey:@"id"];
        Tipo *tipo = [[self getRecordsFromEntity:kTipoEntityName forAttribute:@"tipoId" withKey:tipoId] lastObject];
        
        if (!tipo) {
            tipo = [NSEntityDescription insertNewObjectForEntityForName:kTipoEntityName
                                                 inManagedObjectContext:self.managedObjectContext];
            [tipo setTipoId:tipoId];
        }
        
        NSString *name = [tipoDetails objectForKey:@"nombre"];
        
        if (name) {
            tipo.name = name;
        }
    }
    
    [self saveContext];
}

- (void)insertReservedListIntoDBFromRawArray:(NSArray *)reservedDevices
{
    if ([reservedDevices count]) {
        [self removeAllRowsFromEntity:kReservedEntityName];
    }
    
    for (NSDictionary *deviceDetails in reservedDevices) {
        
        NSString *deviceId = [deviceDetails objectForKey:@"id"];
        ReservedDevice *device = [[self getRecordsFromEntity:kReservedEntityName forAttribute:@"deviceId" withKey:deviceId] lastObject];
        
        if (!device) {
            device = [NSEntityDescription insertNewObjectForEntityForName:kReservedEntityName
                                                 inManagedObjectContext:self.managedObjectContext];
            [device setDeviceId:deviceId];
        }
        
        NSString *fechaalta = [deviceDetails objectForKey:@"fechaalta"];
        
        if (fechaalta) {
            device.fechaalta = fechaalta;
        }
    }
    
    [self saveContext];
}

#pragma mark -coreData Operational Methods

- (BOOL)insertToEntity:(NSString*)entityName withDetails:(NSDictionary *)details
{
    LogDebug(@"Start Insert into Entity");
    @try {
        
        @synchronized(self) {
            
            BOOL ret;
            Class Entity = NSClassFromString(entityName);
            
            if(!Entity){
                return NO;
            }
            
            id EntityObject = [[Entity alloc]init];
            EntityObject = [NSEntityDescription insertNewObjectForEntityForName:entityName
                                                         inManagedObjectContext:self.managedObjectContext];
            NSDictionary *attributes = [[EntityObject entity] attributesByName];
            for(NSString *attribute in attributes){
                
                id value = [details objectForKey:attribute];
                if(!value){
                    continue;
                }
                
                [EntityObject setValue:value forKey:attribute];
            }
            
            NSError *error = nil;
            ret = [self.managedObjectContext save:&error];
            
            if (error) {
                LogDebug(@"Error while saving data:%@", error);
            }
            else {
                LogDebug(@"Data Inserted successfully");
            }
            
            return ret;
        }
    }
    @catch(NSException *e){
        NSLog(@"Exception occured :%@",e);
    }
    NSLog(@" End Insert into Entity");
}

- (NSArray *)getAllRecordsFromEntity:(NSString *)entityName
{
    @try {
        @synchronized(self) {
            
            LogDebug(@" Start getAllRecordsFromEntity");
            
            NSArray *allRecords = nil;
            NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:self.managedObjectContext];
            if (!entity) {
                return nil;
            }
            
            NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:entityName];
            [fetchRequest setEntity:entity];
            
            allRecords = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
            
            LogDebug(@" End getAllRecordsFromEntity");
            
            return allRecords;
        }
    }
    @catch(NSException *e){
        LogTrace(@"Exception occured: %@",e);
    }
}

- (NSArray *)getRecordsFromEntity:(NSString *)entityName forAttribute:(NSString *)attributeName withKey:(NSString *)key
{
    @try {
        LogDebug(@" Start getRecordsFromEntity:forAttribute:withKey:");
        @synchronized(self) {
            NSArray *allRecords = nil;
            NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:self.managedObjectContext];
            if (!entity) {
                return nil;
            }
            
            NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:entityName];
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(%K == %@)", attributeName, key];
            
            [fetchRequest setEntity:entity];
            [fetchRequest setPredicate:predicate];
            
            NSError *error = nil;
            
            allRecords = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
            
            if (error) {
                NSLog(@"Error while fetching the records");
            }
            
            return allRecords;
        }
    }
    @catch(NSException *e){
        LogTrace(@"Exception occured: %@",e);
    }
    @finally {
        
        LogDebug(@" End getRecordsFromEntity:forAttribute:withKey:");
    }
}

- (NSArray *)getRecordsFromEntity:(NSString *)entityName forColumn1:(NSString *)columnName withValue1:(NSString *)value1 andColumn2:(NSString *)columnName2 withValue2:(NSString *)value2
{
    @try {
        LogDebug(@" Start getRecordsFromEntity:forAttribute:withKey:");
        @synchronized(self) {
            NSArray *allRecords = nil;
            NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:self.managedObjectContext];
            if (!entity) {
                return nil;
            }
            
            NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:entityName];
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(%K == %@) AND (%K == %@)", columnName, value1, columnName2, value2];
            
            [fetchRequest setEntity:entity];
            [fetchRequest setPredicate:predicate];
            
            NSError *error = nil;
            
            allRecords = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
            
            if (error) {
                NSLog(@"Error while fetching the records");
            }
            
            return allRecords;
        }
    }
    @catch(NSException *e){
        LogTrace(@"Exception occured: %@",e);
    }
    @finally {
        
        LogDebug(@" End getRecordsFromEntity:forAttribute:withKey:");
    }
}

- (NSArray *)getMatchedRecordFromEntity:(NSString *)entityName forColumnName:(NSString *)columnName withValueToMatch:(NSString *)valueToMatch
{    
    @try {
        LogDebug(@" Start getRecordsFromEntity:forAttribute:withKey:");
        @synchronized(self) {
            NSArray *allRecords = nil;
            NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:self.managedObjectContext];
            if (!entity) {
                return nil;
            }
            
            NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:entityName];
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K contains[cd] %@", columnName, valueToMatch];
            
            [fetchRequest setEntity:entity];
            [fetchRequest setPredicate:predicate];
            
            NSError *error = nil;
            
            allRecords = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
            
            if (error) {
                NSLog(@"Error while fetching the records");
            }
            
            return allRecords;
        }
    }
    @catch(NSException *e){
        LogTrace(@"Exception occured: %@",e);
    }
    @finally {
        
        LogDebug(@" End getRecordsFromEntity:forAttribute:withKey:");
    }
}

- (void)removeAllRowsFromEntity:(NSString*)entityName
{
    @try {
        @synchronized(self) {
            
            LogDebug(@" Start removeAllRowsFromEntity");
            
            NSArray *allRecords = nil;
            NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:self.managedObjectContext];
            if (!entity) {
                return;
            }
            
            NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:entityName];
            [fetchRequest setEntity:entity];
            
            allRecords = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
            
            for(NSManagedObject *objectToDelete in allRecords){
                [self.managedObjectContext deleteObject:objectToDelete];
            }
            
            [self.managedObjectContext save:nil];
            
            LogDebug(@" End removeAllRowsFromEntity");
            
            return;
        }
    }
    @catch(NSException *e){
        LogTrace(@"Exception occured: %@",e);
    }
}

- (void)removeFromEntity:(NSString*)entityName forAttribute:(NSString *)attributeName recordWithKey:(id)key
{
    @try {
        
        @synchronized(self) {
            LogDebug(@" Start removeFromEntity:forAttribute:recordWithKey:");
            
            NSArray *allRecords = nil;
            NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:self.managedObjectContext];
            if (!entity) {
                return;
            }
            
            NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:entityName];
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(%K == %@)", attributeName, key];
            
            [fetchRequest setEntity:entity];
            [fetchRequest setPredicate:predicate];
            
            allRecords = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
            
            for(NSManagedObject *objectToDelete in allRecords)
                [self.managedObjectContext deleteObject:objectToDelete];
            
            [self.managedObjectContext save:nil];
            
            LogDebug(@" End removeFromEntity:forAttribute:recordWithKey:");
            
            return;
        }
    }
    @catch(NSException *e){
        LogTrace(@"Exception occured: %@",e);
    }
}

- (BOOL)updateEntity:(NSString *)entityName setDetails:(NSDictionary *)details whereAttribute:(NSString *)attributeName isEqualToValue:(id)key
{
    @try {
        
        @synchronized(self) {
            
            NSArray *allRecords = nil;
            
            NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:self.managedObjectContext];
            if (!entity) {
                return NO;
            }
            
            NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:entityName];
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(%K == %@)", attributeName, key];
            
            [fetchRequest setEntity:entity];
            [fetchRequest setPredicate:predicate];
            
            allRecords = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
            
            if([allRecords count] == 0) {
                [self insertToEntity:entityName withDetails:details];
                return YES;
            }
            
            NSDictionary *attributes = [entity attributesByName];
            
            for(NSManagedObject *objectToUpdate in allRecords){
                
                for(NSString *attribute in attributes){
                    
                    id value = [details objectForKey:attribute];
                    if(!value){
                        continue;
                    }
                    NSLog(@"Before");
                    [objectToUpdate setValue:[NSNumber numberWithInt:[value intValue]] forKey:attribute];
                    NSLog(@"After");
                }
            }
            return [self.managedObjectContext save:nil];
        }
    }
    @catch(NSException *e){
        LogTrace(@"Exception occured: %@",e);
    }
}


#pragma mark -application directory

- (NSURL *)applicationLibraryDirectoryURL
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSLibraryDirectory inDomains:NSUserDomainMask] lastObject];
}


#pragma mark - CoreData Stack

- (NSManagedObjectContext *)managedObjectContext
{
    if (__managedObjectContext){
        return __managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator){
        return nil;
    }
    
    __managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    [__managedObjectContext setPersistentStoreCoordinator:coordinator];
    [__managedObjectContext setMergePolicy:NSOverwriteMergePolicy];
    
    return __managedObjectContext;
}



- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (__persistentStoreCoordinator){
        return __persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationLibraryDirectoryURL] URLByAppendingPathComponent:@"DelfinoDB.sqlite"];
    
    __autoreleasing NSError *error = nil;
    __persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    
    if (![__persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]){
        
        LogTrace(@"Unresolved error %@, %@", error, [error userInfo]);
        // abort();
    }
    
    return __persistentStoreCoordinator;
}


- (NSManagedObjectModel *)managedObjectModel
{
    if (__managedObjectModel){
        return __managedObjectModel;
    }
    
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Delfino" withExtension:@"momd"];
    __managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    
    return __managedObjectModel;
}

- (BOOL)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    
    if (![managedObjectContext hasChanges]){
        return NO;
    }
    
    if(![managedObjectContext save:&error]) {
        
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        return NO;
    }
    
    return YES;
}

@end
