DECLARE @buildingDetails VARCHAR(MAX)

SELECT @buildingDetails = BulkColumn FROM
OPENROWSET(BULK'/home/shidi/Downloads/singapore-postal-codes-master/buildings.json', SINGLE_BLOB) JSON;
SELECT @buildingDetails as SingleRow_Column

IF (ISJSON(@buildingDetails) = 1)
    BEGIN
        PRINT 'Imported JSON is valid'
    END
ELSE
    BEGIN
        PRINT 'Invalid JSON Imported'
    END

-- ALTER DATABASE CAPRIS2 SET COMPATIBILITY_LEVEL = 130
SELECT * FROM OPENJSON(@buildingDetails, '$.Building')

INSERT INTO dbo.test_buildings(Address, BLK_NO, BUILDING, LATITUDE, LONGTITUDE, POSTAL, ROAD_NAME, SEARCHVAL, X, Y)
SELECT Building_address, Blk_no, Building, Latitude, Longtitude, Postal, Road_name, Searchval, X, Y
FROM OPENJSON(@buildingDetails, '$.Building')
WITH(
    Building_address VARCHAR(66) '$.ADDRESS',
    Blk_no VARCHAR(7) '$.BLK_NO',
    Building NVARCHAR(50) '$.BUILDING',
    Latitude DECIMAL(38,20) '$.LATITUDE',
    Longtitude DECIMAL(38,20) '$.LONGTITUDE',
    Postal VARCHAR(6) '$.POSTAL',
    Road_name VARCHAR(60) '$.ROAD_NAME',
    Searchval NVARCHAR(60) '$.SEARCHVAL',
    X DECIMAL(38,20) '$.X',
    Y DECIMAL(38,20) '$.Y'
)


