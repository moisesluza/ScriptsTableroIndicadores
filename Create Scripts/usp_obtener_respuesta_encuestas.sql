
IF OBJECT_ID (N'usp_obtener_respuesta_encuestas', N'P') IS NOT NULL
    DROP PROCEDURE usp_obtener_respuesta_encuestas
GO

CREATE PROCEDURE usp_obtener_respuesta_encuestas
	@FecIni DATETIME,
	@FecFin DATETIME,
	@estados varchar(max),
    @grupos varchar(max)

AS
BEGIN

SELECT g.last_name as Grupo, c.sequence AS SurveyAnswerSequence, c.txt AS SurveyAnswerTxt, count(cr.id) as Cantidad 
FROM survey a 
    inner join survey_question b ON a.id = b.owning_survey 
    inner join survey_answer c ON b.id = c.own_srvy_question 
    inner join call_req cr ON a.object_id = cr.id 
    inner join ca_contact g ON cr.group_id = g.contact_uuid 
where 
	(DATEADD(ss, cr.resolve_date - 18000, '19700101') between @FecIni and @FecFin or DATEADD(ss, cr.close_date - 18000, '19700101') between @FecIni and @FecFin) 
	and cr.status in (select value from dbo.FnSplit(@estados,',')) 
	and g.last_name in (select value from dbo.FnSplit(@grupos,',')) 
   and (c.selected = 1) and a.id = (select top 1 ss.id from survey ss where ss.object_id=a.object_id order by last_mod_dt) 
group by c.sequence, c.txt, g.last_name 
order by g.last_name, c.sequence

END
GO

--Otrogar permisos de ejecucion al usuario
GRANT EXECUTE ON OBJECT::dbo.usp_obtener_respuesta_encuestas
    TO reportesweb;
GO