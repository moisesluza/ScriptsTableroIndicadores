IF OBJECT_ID (N'usp_obtener_llamadas', N'P') IS NOT NULL
    DROP PROCEDURE usp_obtener_llamadas
GO

CREATE PROCEDURE usp_obtener_llamadas
	@FecIni DATETIME,
	@FecFin DATETIME,
	@HoraIni INT,
	@HoraFin INT

AS
BEGIN
	
	select estado,t_cola, t_talk, fecha_inicio 
    from detalle_llamadas_prueba 
    where fecha_inicio between @FecIni and @FecFin
       and datepart(hour,fecha_inicio)  between @HoraIni and @HoraFin
       and Datepart(weekday, fecha_inicio) not in (1,7)  --Se excluyen fines de semana
       and dbo.ES_FERIADO(convert(varchar,fecha_inicio,112))=0  --Se excluyen días feriados
       and proy = 'OSINERGMIN';
	
	
END
GO