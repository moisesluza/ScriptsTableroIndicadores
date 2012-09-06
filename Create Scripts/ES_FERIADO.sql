IF OBJECT_ID (N'ES_FERIADO', N'FN') IS NOT NULL
    DROP PROCEDURE ES_FERIADO
GO

create FUNCTION [dbo].[ES_FERIADO](@fecha as datetime)

RETURNS bit AS

BEGIN

declare @dFest as int
set @dFest = 0

	  SET @dFest = 
		CASE 
			WHEN CONVERT (char(5), @fecha, 103)='01/01' AND datepart( dw, @fecha) < 6 THEN 1
			WHEN CONVERT (char(5), @fecha, 103)='01/05' AND datepart( dw, @fecha) < 6 THEN 1
			WHEN CONVERT (char(5), @fecha, 103)='29/06' AND datepart( dw, @fecha) < 6 THEN 1
			WHEN CONVERT (char(5), @fecha, 103)='28/07' AND datepart( dw, @fecha) < 6 THEN 1
			WHEN CONVERT (char(5), @fecha, 103)='29/07' AND datepart( dw, @fecha) < 6 THEN 1
			WHEN CONVERT (char(5), @fecha, 103)='30/08' AND datepart( dw, @fecha) < 6 THEN 1
			WHEN CONVERT (char(5), @fecha, 103)='08/10' AND datepart( dw, @fecha) < 6 THEN 1
			WHEN CONVERT (char(5), @fecha, 103)='01/11' AND datepart( dw, @fecha) < 6 THEN 1
			WHEN CONVERT (char(5), @fecha, 103)='08/12' AND datepart( dw, @fecha) < 6 THEN 1
			WHEN CONVERT (char(5), @fecha, 103)='25/12' AND datepart( dw, @fecha) < 6 THEN 1
			WHEN CONVERT (char(10), @fecha, 103)='05/04/2012' THEN 1
			WHEN CONVERT (char(10), @fecha, 103)='06/04/2012' THEN 1
			WHEN CONVERT (char(10), @fecha, 103)='28/03/2013' THEN 1
			WHEN CONVERT (char(10), @fecha, 103)='29/03/2013' THEN 1
			WHEN CONVERT (char(10), @fecha, 103)='17/04/2014' THEN 1
			WHEN CONVERT (char(10), @fecha, 103)='18/04/2014' THEN 1
			WHEN CONVERT (char(10), @fecha, 103)='02/04/2015' THEN 1
			WHEN CONVERT (char(10), @fecha, 103)='03/04/2015' THEN 1
			WHEN CONVERT (char(10), @fecha, 103)='24/03/2016' THEN 1
			WHEN CONVERT (char(10), @fecha, 103)='25/03/2016' THEN 1
			ELSE 0
		END
RETURN  @dFest
END

GO