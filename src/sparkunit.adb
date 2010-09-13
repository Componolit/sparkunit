with Spark_IO;

package body SPARKUnit
is

   function Copy (String_Data : String) return String_Type
   --# pre
   --#    String_Data'Last >  String_Data'First and
   --#    String_Data'Last <= String_Data_Type'Last;
   --# return Result =>
   --#    Result.Length = String_Data'Length;
   is
      Temp_Data : String_Type;
   begin

      for I in String_Data_Index
      loop
         if I in String_Data'Range
         then
            --# accept Flow, 23, Temp_Data.Data, "Initialized in complete loop";
            Temp_Data.Data (I) := String_Data (I);
         else
            --# accept Flow, 23, Temp_Data.Data, "Initialized in complete loop";
            Temp_Data.Data (I) := ' ';
         end if;
      end loop;

      Temp_Data.Length := String_Data'Length;

      --# accept Flow, 602, Temp_Data.Data, "Initialized in complete loop";
      return Temp_Data;
   end Copy;

   ----------------------------------------------------------------------------

   procedure Initialize
      (Harness     :    out Harness_Type;
       Description : in     String)
   is
   begin
      for I in Natural range Harness'Range
      loop
         --# accept Flow, 20, Harness, "Why is access to 'First illegal here?";
         if I = Harness'First
         then
            --# accept Flow, 23, Harness, "Initialized in complete loop";
            Harness (I) := Test_Type'(Description => Copy (Description));
         else
            --# accept Flow, 23, Harness, "Initialized in complete loop";
            Harness (I) := Null_Test;
         end if;
      end loop;
      --# accept Flow, 602, Harness, Harness, "Initialized in complete loop";
   end Initialize;

   ----------------------------------------------------------------------------

   procedure Text_Report
      (Harness : in Harness_Type)
   is
      Temp : Test_Type;
   begin

      Temp := Harness (Harness'First);

      Spark_IO.Put_Line
         (File => Spark_IO.Standard_Output,
          Item => Temp.Description.Data,
          Stop => Temp.Description.Length);

   end Text_Report;

end SPARKUnit;
