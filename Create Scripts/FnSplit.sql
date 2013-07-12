IF OBJECT_ID (N'FnSplit', N'TF') IS NOT NULL
    DROP FUNCTION FnSplit
GO

CREATE FUNCTION FnSplit
(
    @List nvarchar(2000),
    @SplitOn nvarchar(5)
)  
RETURNS @RtnValue table 
(
    Id int identity(1,1),
    Value nvarchar(100)
) 
AS  
BEGIN
    While (Charindex(@SplitOn,@List)>0)
    Begin 
        Insert Into @RtnValue (value)
        
        Select Value = ltrim(rtrim(Substring(@List,1,Charindex(@SplitOn,@List)-1))) 
        Set @List = Substring(@List,Charindex(@SplitOn,@List)+len(@SplitOn),len(@List))
    End 

    Insert Into @RtnValue (Value)
    Select Value = ltrim(rtrim(@List))
    Return
END
GO


GRANT EXECUTE ON OBJECT::dbo.FnSplit
    TO public;
GO