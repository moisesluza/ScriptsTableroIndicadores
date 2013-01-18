IF OBJECT_ID (N'AddWorkDays', N'FN') IS NOT NULL
    DROP FUNCTION AddWorkDays
GO

CREATE FUNCTION AddWorkDays 
(    
    @WorkingDays As Int, 
    @StartDate AS DateTime 
) 
RETURNS DateTime 
AS 
BEGIN 
    DECLARE @Count AS Int 
    DECLARE @i As Int 
    DECLARE @NewDate As DateTime 
    SET @Count = 0 
    SET @i = 0 

    WHILE (@i < @WorkingDays) --runs through the number of days to add 
    BEGIN 
-- increments the count variable 
        SELECT @Count = @Count + 1 
-- increments the i variable 
        SELECT @i = @i + 1 
-- adds the count on to the StartDate and checks if this new date is a Saturday or Sunday 
-- if it is a Saturday or Sunday it enters the nested while loop and increments the count variable 
           WHILE DATENAME(weekday,DATEADD(d, @Count, @StartDate)) IN ('Sunday','Saturday','Sábado','Domingo') or dbo.ES_FERIADO(@StartDate) = 1
            BEGIN 
                SELECT @Count = @Count + 1 
            END 
    END 

-- adds the eventual count on to the Start Date and returns the new date 
    SELECT @NewDate = DATEADD(d,@Count,@StartDate) 
    RETURN @NewDate 
END 
GO

--Otrogar permisos de ejecucion al usuario
GRANT EXECUTE ON OBJECT::dbo.AddWorkDays
    TO reportesweb;
GO
