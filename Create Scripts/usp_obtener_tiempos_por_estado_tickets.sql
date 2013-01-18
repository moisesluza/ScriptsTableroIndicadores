IF OBJECT_ID (N'usp_obtener_tiempos_por_estado_tickets', N'P') IS NOT NULL
    DROP PROCEDURE usp_obtener_tiempos_por_estado_tickets
GO

CREATE PROCEDURE usp_obtener_tiempos_por_estado_tickets
	@FecIni DATETIME,
	@FecFin DATETIME,
	@estados varchar(max),
    @grupos varchar(max),
    @categorias varchar(max),
    @tipo varchar(1)
AS
BEGIN

select 
	obj_id, 
	DATEADD(ss, open_date - 18000, '19700101') as open_date,
	l.location_name as Sede_Usuario, 
	left(l.location_name,2) as Tipo_Sede_Usuario, 
	g.last_name AS Grupo_Asignado, 
	p.sym AS Prioridad, 
   case 
       when p.sym = '0' and field_value in ('Asignado','Registrado') and left(l.location_name,2)='OP' then 20*60 
       when p.sym = '0' and field_value = 'En Proceso' and left(l.location_name,2)='OP' then 50*60 
       when p.sym = '1' and field_value in ('Asignado','Registrado') and left(l.location_name,2)='OP' then 35*60 
       when p.sym = '1' and field_value = 'En Proceso' and left(l.location_name,2)='OP' then 70*60 
       when p.sym = '2' and field_value in ('Asignado','Registrado') and left(l.location_name,2)='OP' then 40*60 
       when p.sym = '2' and field_value = 'En Proceso' and left(l.location_name,2)='OP' then 90*60 
       when p.sym = '3' and field_value in ('Asignado','Registrado') and left(l.location_name,2)='OP' then 50*60 
       when p.sym = '3' and field_value = 'En Proceso' and left(l.location_name,2)='OP' then 100*60 
       when p.sym = '4' and field_value in ('Asignado','Registrado') and left(l.location_name,2)='OP' then 70*60 
       when p.sym = '4' and field_value = 'En Proceso' and left(l.location_name,2)='OP' then 130*60 
       when left(l.location_name,2) = 'OD' and field_value in ('Asignado','Registrado') then 120*60 
       when left(l.location_name,2) = 'OD' and field_value = 'En Proceso' then 120*60 
       when left(l.location_name,2) = 'OR' and field_value in ('Asignado','Registrado') then 60*60 
       when left(l.location_name,2) = 'OR' and field_value = 'En Proceso' then 120*60 
       else 0 
   end as Tiempo_Minimo, 
	field_value as Estado, 
	sum(dbo.DIFFTIME_segundos(DATEADD(ss, prev_time - 18000, '19700101'),DATEADD(ss, end_time - 18000, '19700101'))) as tiempo 
from usp_kpi_ticket_data kpi with(nolock)
	inner join call_req cr with(nolock) on kpi.obj_id=cr.id 
	inner join ca_contact c with(nolock) ON  c.contact_uuid = cr.customer 
	inner join ca_location l with(nolock) ON c.location_uuid = l.location_uuid 
	inner join ca_contact g with(nolock) ON cr.group_id = g.contact_uuid 
	inner join pri p with(nolock) ON cr.priority = p.enum 
	inner join prob_ctg cat with(nolock) ON cr.category = cat.persid 
where field_name='status' and 
	(DATEADD(ss, cr.resolve_date - 18000, '19700101') between @FecIni and @FecFin or DATEADD(ss, cr.close_date - 18000, '19700101') between @FecIni and @FecFin)
	and cr.status in (select value from dbo.FnSplit(@estados,',')) 
	and (g.last_name in (select value from dbo.FnSplit(@grupos,',')) or @grupos = '')
	and (cat.sym in (select value from dbo.FnSplit(@categorias,',')) or @categorias = '')
    and (cr.type=@tipo or @tipo = '')
    and obj_id not in (select distinct obj_id from usp_kpi_ticket_data where prev_time is null) 
group by obj_id, field_value, l.location_name, g.last_name, p.sym, DATEADD(ss, open_date - 18000, '19700101') 
order by obj_id;


END
GO

--Otrogar permisos de ejecucion al usuario
GRANT EXECUTE ON OBJECT::dbo.usp_obtener_tiempos_por_estado_tickets
    TO reportesweb;
GO