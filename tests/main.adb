with SPARKUnit;
--# inherit
--#    SPARKUnit,
--#    Spark_IO;

--# main_program;
procedure Main
--# global
--#    in out Spark_IO.Outputs;
--# derives
--#    Spark_IO.Outputs from *;
is
   subtype My_Harness_Index is Natural range 1 .. 100;
   subtype My_Harness_Type is SPARKUnit.Harness_Type (My_Harness_Index);

   My_Harness : My_Harness_Type;
begin
   SPARKUnit.Initialize (My_Harness, "My test suite");
   SPARKUnit.Text_Report (My_Harness);
end Main;
