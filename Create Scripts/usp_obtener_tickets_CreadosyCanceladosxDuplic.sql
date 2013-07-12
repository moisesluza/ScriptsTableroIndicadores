 
IF OBJECT_ID (N'usp_obtener_tickets_CreadosyCanceladosxDuplic', N'P') IS NOT NULL
    DROP PROCEDURE usp_obtener_tickets_CreadosyCanceladosxDuplic
GO

CREATE PROCEDURE usp_obtener_tickets_CreadosyCanceladosxDuplic
	@FecIni DATETIME,
	@FecFin DATETIME,
	@tipos varchar(max)

AS
BEGIN

select cr.id, cr.status, DATEADD(ss, cr.open_date - 18000, '19700101') as FechaApertura, tcd.fecha_cancelado_duplicidad
from call_req cr 
    left join zView_FechaCancelacionDuplicidadTicket tcd on cr.id=tcd.idTicket
where 
	(
	    DATEADD(ss, cr.open_date - 18000, '19700101') between @FecIni and @FecFin 
	    or
	    tcd.fecha_cancelado_duplicidad between @FecIni and @FecFin 
	) 
    and cr.type in (select value from dbo.FnSplit(@tipos,',')) 
   
END
GO

--Otrogar permisos de ejecucion al usuario
GRANT EXECUTE ON OBJECT::dbo.usp_obtener_tickets_CreadosyCanceladosxDuplic
    TO public;
GO