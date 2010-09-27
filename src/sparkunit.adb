with Spark_IO;
with Ada.Command_Line;

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

   procedure Initialize (Harness : out Harness_Type)
   --# derives
   --#   Harness from ;
   is
   begin
      for I in Natural range Harness'Range
      loop
         --# accept Flow, 23, Harness, "Initialized in complete loop";
         Harness (I) := Element_Type'
            (Valid => False,
             Next  => Index_Type'(Position => I),
             Data  => Null_Test);
      end loop;
      --# accept Flow, 602, Harness, Harness, "Initialized in complete loop";
   end Initialize;

   ----------------------------------------------------------------------------

   function Failure
      (Harness : in Harness_Type) return Boolean
   --# return
   --#    not Harness (Harness'First).Valid;
   is
   begin
      return not Harness (Harness'First).Valid;
   end Failure;

   ----------------------------------------------------------------------------

   procedure Allocate
      (Harness       : in out Harness_Type;
       Position      :    out Index_Type)
   --# derives
   --#    Position, Harness from Harness;
   --# post
   --#    Position.Position in Harness'Range;
   is
      Found : Boolean := False;
   begin
      Position := Index_Type'(Position => Harness'First);

      for I in Natural range Harness'First .. Harness'Last
      --# assert not Found;
      loop
         if not Harness (I).Valid then
            Position          := Index_Type'(Position => I);
            Harness (I).Valid := True;
            Found             := True;

            --# check Position.Position in Harness'Range;
            exit;
         end if;
      end loop;

      if not Found then
         Position := Index_Type'(Position => Harness'First);
         Harness (Harness'First).Valid := False;
         --# check Position.Position in Harness'Range;
      end if;

   end Allocate;

   ----------------------------------------------------------------------------

   procedure Insert_After
      (Harness  : in out Harness_Type;
       Previous : in     Index_Type;
       Current  :    out Index_Type;
       Data     : in     Test_Type)
   --# derives
   --#    Harness from Harness, Data, Previous &
   --#    Current from Harness;
   is
   begin

      Allocate
         (Harness  => Harness,
          Position => Current);

      if not Failure (Harness) and Previous.Position in Harness'Range then
         Harness (Current.Position).Next  := Harness (Previous.Position).Next;
         Harness (Current.Position).Data  := Data;
         Harness (Previous.Position).Next := Current;
      end if;

   end Insert_After;

   ----------------------------------------------------------------------------

   procedure Create_Harness
      (Harness     :    out Harness_Type;
       Description : in     String)
   is
   begin
      Initialize (Harness);

      Harness (Harness'First).Valid := True;
      Harness (Harness'First).Data  :=
          Test_Type'(Description => Copy (Description),
                     Kind        => Harness_Kind,
                     Success     => True,
                     Performance => 0);
   end Create_Harness;

   ----------------------------------------------------------------------------

   procedure Create_Suite
      (Harness     : in out Harness_Type;
       Description : in     String;
       Suite       :    out Index_Type)
   is
   begin

      Insert_After
         (Harness  => Harness,
          Previous => Index_Type'(Position => Harness'First),
          Current  => Suite,
          Data     => Test_Type'(Description => Copy (Description),
                                 Kind        => Suite_Kind,
                                 Success     => True,
                                 Performance => 0));
   end Create_Suite;

   ----------------------------------------------------------------------------

   procedure Create_Test
      (Harness     : in out Harness_Type;
       Suite       : in     Index_Type;
       Description : in     String;
       Success     : in     Boolean)
   is
      Dummy : Index_Type;
   begin

      --# accept Flow, 10, Dummy, "Unused";
      Insert_After
         (Harness  => Harness,
          Previous => Suite,
          Current  => Dummy,
          Data     => Test_Type'(Description => Copy (Description),
                                 Kind        => Test_Kind,
                                 Success     => Success,
                                 Performance => 0));

   --# accept Flow, 33, Dummy, "Unused";
   end Create_Test;

   ----------------------------------------------------------------------------

   function Calculate_Performance
      (Measurement : Measurement_Type) return Natural
   is
      --# hide Calculate_Performance;
      use Ada.Real_Time;

      D1, D2 : Time_Span;
      Result : Natural;
   begin
      D1 := Measurement.Reference_Stop   - Measurement.Reference_Start;
      D2 := Measurement.Measurement_Stop - Measurement.Measurement_Start;

      if D2 > Time_Span_Zero then
         Result := Time_Span (100 * D1) / D2;
      else
         Result := 0;
      end if;

      return Result;

   end Calculate_Performance;

   ----------------------------------------------------------------------------

   procedure Create_Benchmark
      (Harness     : in out Harness_Type;
       Suite       : in     Index_Type;
       Description : in     String;
       Measurement : in     Measurement_Type;
       Success     : in     Boolean)
   is
      Dummy       : Index_Type;
   begin

      --# accept Flow, 10, Dummy, "Unused";
      Insert_After
         (Harness  => Harness,
          Previous => Suite,
          Current  => Dummy,
          Data     => Test_Type'
                         (Description => Copy (Description),
                          Kind        => Benchmark_Kind,
                          Performance => Calculate_Performance (Measurement),
                          Success     => Success));

   --# accept Flow, 33, Dummy, "Unused";
   end Create_Benchmark;

   ----------------------------------------------------------------------------

   procedure Indent (Kind : Kind_Type)
   --# global
   --#    Spark_IO.Outputs;
   --# derives
   --#    Spark_IO.Outputs from *, Kind;
   is
   begin
      case Kind is
         when Invalid =>
            Spark_IO.Put_String (Spark_IO.Standard_Output, "ERROR: Invalid kind", 0);
         when Harness_Kind =>
            null;
         when Suite_Kind =>
            Spark_IO.New_Line (Spark_IO.Standard_Output, 1);
            Spark_IO.Put_String (Spark_IO.Standard_Output, "   ", 0);
         when Test_Kind | Benchmark_Kind =>
            Spark_IO.Put_String (Spark_IO.Standard_Output, "      ", 0);
      end case;
   end Indent;

   ----------------------------------------------------------------------------

   procedure Print_Result (Item : Test_Type)
   --# global
   --#    Spark_IO.Outputs;
   --# derives
   --#    Spark_IO.Outputs from *, Item;
   --# pre
   --#    String_Length - Item.Description.Length <= Natural'Last;
   is
   begin

      Spark_IO.Put_Char (Spark_IO.Standard_Output, ' ');
      for I in Natural range 1 .. String_Length - Item.Description.Length
      loop
         Spark_IO.Put_Char (Spark_IO.Standard_Output, '.');
      end loop;

      if Item.Success then
         Spark_IO.Put_String (Spark_IO.Standard_Output, ".... OK.", 0);

         if Item.Kind = Benchmark_Kind then
            Spark_IO.Put_String (Spark_IO.Standard_Output, " (", 0);
            Spark_IO.Put_Integer (Spark_IO.Standard_Output, Item.Performance, 3, 10);
            Spark_IO.Put_String (Spark_IO.Standard_Output, "%)", 0);
         end if;

      else
         Spark_IO.Put_String (Spark_IO.Standard_Output, " FAILED!", 0);
      end if;

   end Print_Result;

   ----------------------------------------------------------------------------

   procedure Text_Report
      (Harness : in Harness_Type)
   is
      Temp    : Element_Type;
      No_Test : Natural := 0;
      No_Fail : Natural := 0;
      Error   : Boolean := False;
      Status  : Ada.Command_Line.Exit_Status;

   begin

      if Failure (Harness) then
         Spark_IO.Put_Line (Spark_IO.Standard_Output, "OUT OF MEMORY!!!", 0);
         Error := True;
      else

         Temp := Harness (Harness'First);

         loop
            Indent (Temp.Data.Kind);

            Spark_IO.Put_String
               (File => Spark_IO.Standard_Output,
                Item => Temp.Data.Description.Data,
                Stop => Temp.Data.Description.Length);

            if Temp.Data.Kind = Test_Kind or Temp.Data.Kind = Benchmark_Kind then

               if    not (No_Test < Natural'Last) then
                  Spark_IO.Put_String (Spark_IO.Standard_Output, " NO_TEST OVERFLOW!!!", 0);
                  Error := True;
               elsif not (No_Fail < Natural'Last) then
                  Spark_IO.Put_String (Spark_IO.Standard_Output, " NO_FAIL OVERFLOW!!!", 0);
                  Error := True;
               else
                  No_Test := No_Test + 1;
                  if not Temp.Data.Success then
                     No_Fail := No_Fail + 1;
                  end if;
                  Print_Result (Temp.Data);
               end if;
            end if;

            if not (Temp.Next.Position in Harness'Range)
            then
               Spark_IO.Put_String (Spark_IO.Standard_Output, "INVALID NEXT ELEMENT!!!", 0);
               Error := True;
            end if;

            Spark_IO.New_Line (Spark_IO.Standard_Output, 1);

            exit when Error or Temp.Next.Position = Harness'First;

            Temp := Harness (Temp.Next.Position);

         end loop;

         Spark_IO.New_Line (Spark_IO.Standard_Output, 1);
         Spark_IO.Put_String (Spark_IO.Standard_Output, "FAILED: ", 0);
         Spark_IO.Put_Integer (Spark_IO.Standard_Output, No_Fail, 0, 10);
         Spark_IO.Put_String (Spark_IO.Standard_Output, "/", 0);
         Spark_IO.Put_Integer (Spark_IO.Standard_Output, No_Test, 0, 10);
         Spark_IO.New_Line (Spark_IO.Standard_Output, 1);

      end if;

      if No_Fail > 0 then
         Status := 2;
      elsif Error then
         Status := 1;
      else
         Status := 0;
      end if;

      Ada.Command_Line.Set_Exit_Status (Status);

   end Text_Report;

   ----------------------------------------------------------------------------

   procedure Reference_Start
      (Item : out Measurement_Type)
   is
   begin
      Item := Measurement_Type'
         (Reference_Start   => Ada.Real_Time.Clock,
          Reference_Stop    => Ada.Real_Time.Time_First,
          Measurement_Start => Ada.Real_Time.Time_First,
          Measurement_Stop  => Ada.Real_Time.Time_First);
   end Reference_Start;

   ----------------------------------------------------------------------------

   procedure Reference_Stop
      (Item : in out Measurement_Type)
   is
   begin
      Item.Reference_Stop := Ada.Real_Time.Clock;
   end Reference_Stop;

   ----------------------------------------------------------------------------

   procedure Measurement_Start
      (Item : in out Measurement_Type)
   is
   begin
      Item.Measurement_Start := Ada.Real_Time.Clock;
   end Measurement_Start;

   ----------------------------------------------------------------------------

   procedure Measurement_Stop
      (Item : in out Measurement_Type)
   is
   begin
      Item.Measurement_Stop := Ada.Real_Time.Clock;
   end Measurement_Stop;

end SPARKUnit;
