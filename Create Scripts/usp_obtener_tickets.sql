
IF OBJECT_ID (N'usp_obtener_tickets', N'P') IS NOT NULL
    DROP PROCEDURE usp_obtener_tickets
GO

CREATE PROCEDURE usp_obtener_tickets
	@FecIni DATETIME,
	@FecFin DATETIME,
	@estados varchar(max),
    @grupos varchar(max)

AS
BEGIN

select cr.id, ctg.sym as Categoria_Ticket, g.last_name as Grupo_Resolutor --Cambiar por grupo asignado!
from call_req cr 
    inner join ca_contact g with(nolock) ON cr.group_id = g.contact_uuid 
    inner join prob_ctg ctg with(nolock) ON cr.category = ctg.persid 
    inner join ca_contact gctg with(nolock) ON ctg.group_id = gctg.contact_uuid 
where 
	(DATEADD(ss, cr.resolve_date - 18000, '19700101') between @FecIni and @FecFin or DATEADD(ss, cr.close_date - 18000, '19700101') between @FecIni and @FecFin) 
	and cr.status in (select value from dbo.FnSplit(@estados,',')) 
	and gctg.last_name in (select value from dbo.FnSplit(@grupos,',')) 
    and cr.type='I'
   
END
GO

--Otrogar permisos de ejecucion al usuario
GRANT EXECUTE ON OBJECT::dbo.usp_obtener_tickets
    TO reportesweb;
GO