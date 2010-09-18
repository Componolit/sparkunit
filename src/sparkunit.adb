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
            Harness (I) := Test_Type'(Description => Copy (Description),
                                      Next        => Null_Index,
                                      Kind        => Harness_Kind,
                                      Success     => True);
         else
            --# accept Flow, 23, Harness, "Initialized in complete loop";
            Harness (I) := Null_Test;
         end if;
      end loop;
      --# accept Flow, 602, Harness, Harness, "Initialized in complete loop";
   end Initialize;

   ----------------------------------------------------------------------------

   procedure Create_Suite
      (Harness     : in out Harness_Type;
       Description : in     String;
       Suite       :    out Index_Type)
   is
      Next : Natural;
   begin

      Next := Harness (Harness'First).Next.Position;

      if Next >= Harness'First and Next < Harness'Last
      then
         Harness (Next) := Test_Type'(Description => Copy (Description),
                                      Kind        => Suite_Kind,
                                      Next        => Null_Index,
                                      Success     => True);

         Suite := Index_Type'(Position => Next + 1);
         Harness (Harness'First).Next.Position := Next + 1;
      else
         Suite := Index_Type'(Position => Harness'First);
         Harness (Harness'First).Success := False;
      end if;

   end Create_Suite;

   ----------------------------------------------------------------------------

   procedure Test
      (Harness     : in out Harness_Type;
       Suite       : in     Index_Type;
       Description : in     String;
       Success     : in     Boolean)
   is
      Next : Natural;
   begin

      Next := Harness (Harness'First).Next.Position;

      if Next >= Harness'First and Next < Harness'Last and
         Suite.Position in Harness'Range
      then
         Harness (Next) :=
            Test_Type'(Description => Copy (Description),
                       Kind        => Test_Kind,
                       Next        => Index_Type'(Position => Next),
                       Success     => Success);

         Harness (Suite.Position).Next := Index_Type'(Position => Next);
         Harness (Harness'First).Next  := Index_Type'(Position => Next + 1);
      else
         Harness (Harness'First).Success := False;
      end if;

   end Test;

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
