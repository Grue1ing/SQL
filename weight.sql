DECLARE @maxWeight float, @productKey integer  
SET @maxWeight = 1000.00  
SET @productKey = 400  
IF @maxWeight <= (SELECT Weight FROM Production.Product
                  WHERE ProductID = @productKey)   
    (SELECT @productKey AS ProductKey, Name, Weight, 
    'This product is too heavy to ship and is only available for pickup.' 
        AS ShippingStatus
    FROM Production.Product WHERE ProductID = @productKey);  
ELSE  
    (SELECT @productKey AS ProductKey, Name, Weight, 
    'This product is available for shipping or pickup.' 
        AS ShippingStatus
    FROM Production.Product WHERE ProductID = @productKey); 