create view zView_FechaCancelacionDuplicidadTicket as 
SELECT obj_id AS idTicket
	, max(DATEADD(ss, end_time - 18000, '19700101')) as fecha_cancelado_duplicidad
FROM dbo.usp_kpi_ticket_data
where field_name='status' and next_value = 'Cancelado por duplicidad'
group by obj_id