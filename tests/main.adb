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
   Suite1     : SPARKUnit.Index_Type;
begin
   SPARKUnit.Initialize (My_Harness, "My harness");
   SPARKUnit.Create_Suite (My_Harness, "My first suite", Suite1);
   SPARKUnit.Test (My_Harness, Suite1, "My first test", True);
   SPARKUnit.Text_Report (My_Harness);
end Main;
