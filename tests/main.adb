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

   My_Harness             : My_Harness_Type;
   Suite1, Suite2, Suite3 : SPARKUnit.Index_Type;
   M1                     : SPARKUnit.Measurement_Type;

begin
   SPARKUnit.Create_Harness (My_Harness, "My harness");

   SPARKUnit.Create_Suite (My_Harness, "My first suite", Suite1);
   SPARKUnit.Create_Test (My_Harness, Suite1, "My first test", True);
   SPARKUnit.Create_Test (My_Harness, Suite1, "My second test", False);

   SPARKUnit.Create_Suite (My_Harness, "My second suite", Suite2);
   SPARKUnit.Create_Test (My_Harness, Suite2, "My third test", True);
   SPARKUnit.Create_Test (My_Harness, Suite2, "My fourth test", False);
   SPARKUnit.Create_Test (My_Harness, Suite2, "My fifth test", True);

   SPARKUnit.Create_Suite (My_Harness, "My third suite", Suite3);
   SPARKUnit.Create_Test (My_Harness, Suite3, "My sixth test", False);

   SPARKUnit.Reference_Start (M1);
   --# accept Flow, 10, "Delay loop";
   for I in Natural range 1 .. 1000
   loop
      null;
   end loop;
   SPARKUnit.Reference_Stop (M1);

   SPARKUnit.Measurement_Start (M1);
   --# accept Flow, 10, "Delay loop";
   for I in Natural range 1 .. 10000
   loop
      null;
   end loop;
   SPARKUnit.Measurement_Stop (M1);

   SPARKUnit.Create_Benchmark (My_Harness, Suite3, "My benchmark", M1, True);
   SPARKUnit.Create_Benchmark (My_Harness, Suite3, "Failed benchmark", M1, False);

   SPARKUnit.Text_Report (My_Harness);
end Main;
