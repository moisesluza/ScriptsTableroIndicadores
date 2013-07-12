 IF OBJECT_ID (N'usp_obtener_tickets_reabiertos', N'P') IS NOT NULL
    DROP PROCEDURE usp_obtener_tickets_reabiertos
GO

CREATE PROCEDURE usp_obtener_tickets_reabiertos
	@FecIni SMALLDATETIME,
	@FecFin SMALLDATETIME
AS
BEGIN
	select idTicket,fecha_primer_reabierto,fecha_primer_cierre
    from call_req cr 
        left join zView_TicketsConPrimerCierreYPrimerReabierto z on cr.id = z.idTicket
        left join ca_contact g ON cr.group_id = g.contact_uuid
    where 
        dateadd(day, datediff(day, 0, fecha_primer_cierre), 0) between @FecIni and @FecFin
        and g.last_name in ('PRIMER NIVEL','SOPORTE EN SITIO - LIMA','SOPORTE EN SITIO - PROV','GESTION ADMINISTRATIVA','SEGUNDO NIVEL INFRAESTRUCTURA') 
	    and cr.type in ('I','R')  
	    and cr.status<>'CNCL'
	    and Z.field_value='Reabierto' AND (fecha_primer_reabierto IS NULL OR dateadd(day, datediff(day, 0, fecha_primer_reabierto), 0) between @FecIni and dbo.addWorkDays(2, @FecFin))
END 
GO

--Otrogar permisos de ejecucion al usuario
GRANT EXECUTE ON OBJECT::dbo.usp_obtener_tickets_reabiertos
    TO public;
GO