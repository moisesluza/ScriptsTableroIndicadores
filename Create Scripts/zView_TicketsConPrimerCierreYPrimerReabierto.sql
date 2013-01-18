CREATE VIEW zView_TicketsConPrimerCierreYPrimerReabierto
AS
select tkts_primer_cierre.obj_id as idTicket, fecha_primer_cierre, fecha_primer_reabierto,field_value    
from (    
    select obj_id, DATEADD(ss, min(end_time) - 18000, '19700101') as fecha_primer_cierre
    from usp_kpi_ticket_data     
    where field_name = 'status' and next_value ='Cerrado'     
    group by obj_id    
) as tkts_primer_cierre left join  (    
    select obj_id, DATEADD(ss, min(prev_time) - 18000, '19700101') as fecha_primer_reabierto,field_value
    from usp_kpi_ticket_data     
    where field_name = 'status' and field_value ='Reabierto'     
    group by obj_id, field_value   
) as tkts_primer_reabierto on tkts_primer_cierre.obj_id=tkts_primer_reabierto.obj_id
