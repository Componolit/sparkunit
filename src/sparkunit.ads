--# inherit
--#    Spark_IO;

package SPARKUnit
is

   -- Type representing a harness, test suite or unit test
   type Test_Type is private;

   -- A test harness
   type Harness_Type is array (Natural range <>) of Test_Type;

   -- Maximum length of strings passed to SPARKUnit
   String_Length : constant := 30;

   -- Initialize the given harness @Harness@ using @Description@
   procedure Initialize
      (Harness     :    out Harness_Type;
       Description : in     String);
   --# derives
   --#    Harness from Description;
   --# pre
   --#    Harness'Last       >  Harness'First and
   --#    Description'Length <= String_Length;

   -- function Create_Suite
   --    (Harness     : in out Harness_Type;
   --     Description : in     String) return Suite_Type;

   -- procedure Test
   --    (Harness     : in out Context_Type;
   --     Suite       : in     Suite_Type;
   --     Description : in     String;
   --     Success     : in     Boolean);

   -- Output the test report of @Harness@ in text format
   procedure Text_Report
      (Harness : in Harness_Type);
   --# global
   --#    Spark_IO.Outputs;
   --# derives
   --#    Spark_IO.Outputs from *, Harness;

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

   type Test_Type is
   record
      Description : String_Type;
   end record;

   Null_Test : constant Test_Type := Test_Type'
      (Description => Null_String);

--# accept Warning, 394, Test_Type, "Initialized indirectly via Test procedure";
end SPARKUnit;
