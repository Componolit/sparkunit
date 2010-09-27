with Ada.Real_Time;

--# inherit
--#    Ada.Command_Line,
--#    Ada.Real_Time,
--#    Spark_IO;

package SPARKUnit
is

   -- Type representing a harness, test suite, unit test or benchmark
   type Element_Type is limited private;

   -- Index to a harness, test suite or unit test
   type Index_Type is limited private;

   -- A test harness
   type Harness_Type is array (Natural range <>) of Element_Type;

   -- A context for a timing measurement
   type Measurement_Type is limited private;

   -- Maximum length of strings passed to SPARKUnit
   String_Length : constant := 50;

   -- Create the given @Harness@ using @Description@
   procedure Create_Harness
      (Harness     :    out Harness_Type;
       Description : in     String);
   --# derives
   --#    Harness from Description;
   --# pre
   --#    Harness'Last       >  Harness'First     and
   --#    Description'Last   >  Description'First and
   --#    Description'Length <= String_Length;

   --  Create and return a test suite in @Harness@ using @Description@
   procedure Create_Suite
      (Harness     : in out Harness_Type;
       Description : in     String;
       Suite       :    out Index_Type);
   --# derives
   --#    Harness from Harness, Description &
   --#    Suite   from Harness;
   --# pre
   --#    Harness'Last       >  Harness'First     and
   --#    Description'Last   >  Description'First and
   --#    Description'Length <= String_Length;

   --  Insert test case with result @Success@ as child of @Suite@ in @Harness@.
   --  Use @Description@ for the case.
   procedure Create_Test
      (Harness     : in out Harness_Type;
       Suite       : in     Index_Type;
       Description : in     String;
       Success     : in     Boolean);
   --# derives
   --#    Harness from Harness, Suite, Description, Success;
   --# pre
   --#    Harness'Last       >  Harness'First     and
   --#    Description'Last   >  Description'First and
   --#    Description'Length <= String_Length;

   --  Insert benchmark with results @Success@ and @Measurement@ as child of
   --  @Suite@ in @Harness@.
   --  Use @Description@ for the measurement.

   procedure Create_Benchmark
      (Harness     : in out Harness_Type;
       Suite       : in     Index_Type;
       Description : in     String;
       Measurement : in     Measurement_Type;
       Success     : in     Boolean);
   --# derives
   --#    Harness from Harness, Suite, Description, Success, Measurement;
   --# pre
   --#    Harness'Last       >  Harness'First     and
   --#    Description'Last   >  Description'First and
   --#    Description'Length <= String_Length;

   -- Output the test report of @Harness@ in text format
   procedure Text_Report
      (Harness : in Harness_Type);
   --# global
   --#    in out Spark_IO.Outputs;
   --# derives
   --#    Spark_IO.Outputs from *, Harness;

   --  Start a reference measurement using the context @Item@
   procedure Reference_Start
      (Item : out Measurement_Type);
   --# derives
   --#    Item from ;

   --  Stop a reference measurement using the context @Item@
   procedure Reference_Stop
      (Item : in out Measurement_Type);
   --# derives
   --#    Item from Item;

   --  Start a measurement using the context @Item@
   procedure Measurement_Start
      (Item : in out Measurement_Type);
   --# derives
   --#    Item from Item;

   --  Stop a measurement using the context @Item@
   procedure Measurement_Stop
      (Item : in out Measurement_Type);
   --# derives
   --#    Item from Item;

private

   subtype String_Data_Index is Natural range 1 .. String_Length;
   subtype String_Data_Type is String (String_Data_Index);

   Null_String_Data : constant String_Data_Type := String_Data_Type'
      (String_Data_Index => Character'Val (0));

   type String_Type is
   record
      Data   : String_Data_Type;
      Length : Natural;
   end record;

   Null_String : constant String_Type := String_Type'
      (Data   => Null_String_Data,
       Length => 0);

   type Kind_Type  is (Invalid, Harness_Kind, Suite_Kind, Test_Kind, Benchmark_Kind);

   type Index_Type is
   record
      Position : Natural;
   end record;

   Null_Index : constant Index_Type := Index_Type'(Position => 0);

   type Test_Type is
   record
      Description  : String_Type;
      Kind         : Kind_Type;
      Success      : Boolean;
      Performance  : Natural;
   end record;

   Null_Test : constant Test_Type := Test_Type'
      (Description => Null_String,
       Kind        => Invalid,
       Success     => False,
       Performance => 0);

   type Element_Type is
   record
      Valid : Boolean;
      Next  : Index_Type;
      Data  : Test_Type;
   end record;

   type Measurement_Type is
   record
      Measurement_Start : Ada.Real_Time.Time;
      Measurement_Stop  : Ada.Real_Time.Time;
      Reference_Start   : Ada.Real_Time.Time;
      Reference_Stop    : Ada.Real_Time.Time;
   end record;

--# accept Warning, 394, Element_Type, "Initialized indirectly via Create_Test";
end SPARKUnit;
