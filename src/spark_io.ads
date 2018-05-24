-- $Id: spark_io.ads 15664 2010-01-19 12:16:03Z rod chapman $
--------------------------------------------------------------------------------
-- (C) Altran Praxis Limited
--------------------------------------------------------------------------------
--
-- The SPARK toolset is free software; you can redistribute it and/or modify it
-- under terms of the GNU General Public License as published by the Free
-- Software Foundation; either version 3, or (at your option) any later
-- version. The SPARK toolset is distributed in the hope that it will be
-- useful, but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General
-- Public License for more details. You should have received a copy of the GNU
-- General Public License distributed with the SPARK toolset; see file
-- COPYING3. If not, go to http://www.gnu.org/licenses for a complete copy of
-- the license.
--
-- As a special exception, if other files instantiate generics from this unit,
-- or you link this unit with other files to produce an executable, this unit
-- does not by itself cause the resulting executable to be covered by the GNU
-- General Public License. This exception does not however invalidate any other
-- reasons why the executable file might be covered by the GNU Public License. 
--
--==============================================================================


with Ada.Text_IO;
package Spark_IO
--# own State   : State_Type;
--#     Inputs  : Inputs_Type;
--#     Outputs : Outputs_Type;
--# initializes State,
--#             Inputs,
--#             Outputs;
is
   --# type State_Type is abstract;
   --# type Inputs_Type is abstract;
   --# type Outputs_Type is abstract;

   type File_Type is private;
   type File_Mode is (In_File, Out_File, Append_File);
   type File_Status is (Ok, Status_Error, Mode_Error, Name_Error, Use_Error,
                        Device_Error, End_Error,  Data_Error, Layout_Error,
                        Storage_Error, Program_Error);

   subtype Number_Base is Integer range 2 .. 16;

   Standard_Input  : constant File_Type;
   Standard_Output : constant File_Type;
   Null_File       : constant File_Type;

   ------------------
   -- File Management
   ------------------

   procedure Create (File         :    out File_Type;
                     Name_Of_File : in     String;
                     Form_Of_File : in     String;
                     Status       :    out File_Status);
   --# global in out State;
   --# derives State,
   --#         File,
   --#         Status   from State, Name_Of_File, Form_Of_File;
   --# declare delay;

   procedure Open (File         :    out File_Type;
                   Mode_Of_File : in     File_Mode;
                   Name_Of_File : in     String;
                   Form_Of_File : in     String;
                   Status       :    out File_Status);
   --# global in out State;
   --# derives State,
   --#         File,
   --#         Status from State, Mode_Of_File, Name_Of_File,
   --#                     Form_Of_File;
   --# declare delay;

   procedure Close (File   : in out File_Type;
                    Status :    out File_Status);
   --# global in out State;
   --# derives State,
   --#         Status   from State, File &
   --#         File     from ;
   --# declare delay;

   procedure Delete (File   : in out  File_Type;
                     Status :    out File_Status);
   --# global in out State;
   --# derives State,
   --#         Status   from State, File &
   --#         File     from ;
   --# declare delay;

   procedure Reset (File         : in out File_Type;
                    Mode_Of_File : in     File_Mode;
                    Status       :    out File_Status);
   --# derives File,
   --#         Status   from File, Mode_Of_File;
   --# declare delay;

   function Valid_File (File : File_Type) return Boolean;
   -- This is a potentially blocking function.
   -- DO NOT CALL THIS FUNCTION FROM A PROTECTED OPERATION.

   function Mode (File : File_Type) return File_Mode;
   -- This is a potentially blocking function.
   -- DO NOT CALL THIS FUNCTION FROM A PROTECTED OPERATION.

   procedure Name (File         : in     File_Type;
                   Name_Of_File :    out String;
                   Stop         :    out Natural);
   --# derives Name_Of_File,
   --#         Stop          from File;
   --# declare delay;

   procedure Form (File         : in      File_Type;
                   Form_Of_File :    out String;
                   Stop         :    out Natural);
   --# derives Form_Of_File,
   --#         Stop             from File;
   --# declare delay;

   function Is_Open (File : File_Type) return Boolean;
   --# global State;
   -- This is a potentially blocking function.
   -- DO NOT CALL THIS FUNCTION FROM A PROTECTED OPERATION.

   --------------------------------------------
   -- Control of default input and output Files
   --------------------------------------------

   --
   -- Not supported in Spark_IO
   --

   -----------------------------------------
   -- Specification of line and page lengths
   -----------------------------------------

   --
   -- Not supported in Spark_IO
   --

   --------------------------------
   -- Column, Line and Page Control
   --------------------------------

   procedure New_Line (File    : in File_Type;
                       Spacing : in Positive);
   --# global in out Outputs;
   --# derives Outputs from Outputs, File, Spacing;
   --# declare delay;

   procedure Skip_Line (File    : in File_Type;
                        Spacing : in Positive);
   --# global in out Inputs;
   --# derives Inputs from Inputs, File, Spacing;
   --# declare delay;

   procedure New_Page (File : in File_Type);
   --# global in out Outputs;
   --# derives Outputs from Outputs, File;
   --# declare delay;

   function End_Of_Line (File : File_Type) return Boolean;
   --# global Inputs;
   -- This is a potentially blocking function.
   -- DO NOT CALL THIS FUNCTION FROM A PROTECTED OPERATION.

   function End_Of_File (File : File_Type) return Boolean;
   --# global Inputs;
   -- This is a potentially blocking function.
   -- DO NOT CALL THIS FUNCTION FROM A PROTECTED OPERATION.

   procedure Set_In_File_Col (File : in File_Type;
                              Posn : in Positive);
   --# global in out Inputs;
   --# derives Inputs from Inputs, File, Posn;
   --# declare delay;
   --# pre Mode (File) = In_File;

   procedure Set_Out_File_Col (File : in File_Type;
                               Posn : in Positive);
   --# global in out Outputs;
   --# derives Outputs from Outputs, File, Posn;
   --# declare delay;
   --# pre Mode( File ) = Out_File or
   --#     Mode (File) = Append_File;

   function In_File_Col (File : File_Type) return Positive;
   --# global Inputs;
   --# pre Mode (File) = In_File;
   -- This is a potentially blocking function.
   -- DO NOT CALL THIS FUNCTION FROM A PROTECTED OPERATION.

   function Out_File_Col (File : File_Type) return Positive;
   --# global Outputs;
   --# pre Mode (File) = Out_File or
   --#     Mode (File) = Append_File;
   -- This is a potentially blocking function.
   -- DO NOT CALL THIS FUNCTION FROM A PROTECTED OPERATION.

   function In_File_Line (File : File_Type) return Positive;
   --# global Inputs;
   --# pre Mode (File) = In_File;
   -- This is a potentially blocking function.
   -- DO NOT CALL THIS FUNCTION FROM A PROTECTED OPERATION.

   function Out_File_Line (File : File_Type) return Positive;
   --# global Outputs;
   --# pre Mode (File) = Out_File or
   --#     Mode (File) = Append_File;
   -- This is a potentially blocking function.
   -- DO NOT CALL THIS FUNCTION FROM A PROTECTED OPERATION.

   -------------------------
   -- Character Input-Output
   -------------------------

   procedure Get_Char (File : in      File_Type;
                       Item :    out Character);
   --# global in out  Inputs;
   --# derives Inputs,
   --#         Item     from Inputs, File;
   --# declare delay;

   procedure Put_Char (File : in File_Type;
                       Item : in Character);
   --# global in out Outputs;
   --# derives Outputs from Outputs, File, Item;
   --# declare delay;

   procedure Get_Char_Immediate (File   : in     File_Type;
                                 Item   :    out Character;
                                 Status :    out File_Status);
   --# global in out Inputs;
   --# derives Inputs,
   --#         Item,
   --#         Status from Inputs,
   --#                     File;
   --# declare delay;
   -- NOTE.  Only the variant of Get_Immediate that waits for a character to become
   -- available is supported.
   -- On return Status is one of Ok, Mode_Error or End_Error. See ALRM A.10.7
   -- Item is Character'First if Status /= Ok

   ----------------------
   -- String Input-Output
   ----------------------

   procedure Get_String (File     : in     File_Type;
                         Item     :    out String;
                         Stop     :    out Natural);
   --# global in out Inputs;
   --# derives Inputs,
   --#         Item,
   --#         Stop         from Inputs, File;
   --# declare delay;

   procedure Put_String (File     : in File_Type;
                         Item     : in String;
                         Stop     : in Natural);
   --# global in out Outputs;
   --# derives Outputs from Outputs, File, Item, Stop;
   --# declare delay;

   procedure Get_Line (File     : in     File_Type;
                       Item     :    out String;
                       Stop     :    out Natural);
   --# global in out Inputs;
   --# derives Inputs,
   --#         Item,
   --#         Stop     from Inputs, File;
   --# declare delay;

   procedure Put_Line (File     : in File_Type;
                       Item     : in String;
                       Stop     : in Natural);
   --# global in out Outputs;
   --# derives Outputs from Outputs, File, Item, Stop;
   --# declare delay;


   -----------------------
   -- Integer Input-Output
   -----------------------

   -- Spark_IO only supports input-output of
   -- the built-in Integer type Integer

   procedure Get_Integer (File  : in     File_Type;
                          Item  :    out Integer;
                          Width : in     Natural;
                          Read  :    out Boolean);
   --# global in out Inputs;
   --# derives Inputs,
   --#         Item,
   --#         Read     from Inputs, File, Width;
   --# declare delay;

   procedure Put_Integer (File  : in File_Type;
                          Item  : in Integer;
                          Width : in Natural;
                          Base  : in Number_Base);
   --# global in out Outputs;
   --# derives Outputs from Outputs, File, Item, Width, Base;
   --# declare delay;

   procedure Get_Int_From_String (Source    : in     String;
                                  Item      :    out Integer;
                                  Start_Pos : in     Positive;
                                  Stop      :    out Natural);
   --# derives Item,
   --#         Stop from Source, Start_Pos;
   --# declare delay;

   procedure Put_Int_To_String (Dest      : in out String;
                                Item      : in     Integer;
                                Start_Pos : in     Positive;
                                Base      : in     Number_Base);
   --# derives Dest from Dest, Item, Start_Pos, Base;
   --# declare delay;


   ---------------------
   -- Float Input-Output
   ---------------------

   -- Spark_IO only supports input-output of
   -- the built-in real type Float

   procedure Get_Float (File  : in     File_Type;
                        Item  :    out Float;
                        Width : in     Natural;
                        Read  :    out Boolean);
   --# global in out Inputs;
   --# derives Inputs,
   --#         Item,
   --#         Read     from Inputs, File, Width;
   --# declare delay;

   procedure Put_Float (File  : in File_Type;
                        Item  : in Float;
                        Fore  : in Natural;
                        Aft   : in Natural;
                        Exp   : in Natural);
   --# global in out Outputs;
   --# derives Outputs from Outputs, File, Item, Fore, Aft, Exp;
   --# declare delay;

   procedure Get_Float_From_String (Source    : in     String;
                                    Item      :    out Float;
                                    Start_Pos : in     Positive;
                                    Stop      :    out Natural);
   --# derives Item,
   --#         Stop from Source, Start_Pos;
   --# declare delay;

   procedure Put_Float_To_String (Dest      : in out String;
                                  Item      : in     Float;
                                  Start_Pos : in     Positive;
                                  Aft       : in     Natural;
                                  Exp       : in     Natural);
   --# derives Dest from Dest, Item, Start_Pos, Aft, Exp;
   --# declare delay;

private
   --# hide Spark_IO;

   type IO_TYPE   is (Stdin, Stdout, NamedFile);
   type File_PTR  is access Ada.Text_IO.File_Type;

   -- In addition to the fields listed here, we consider the
   -- FILE_PTR.all record to contain the name and mode of the
   -- file from the point of view of the annotations above.
   type File_Type is
      record
         File    : File_PTR := null;
         IO_Sort : IO_TYPE  := NamedFile;
      end record;

   Standard_Input  : constant File_Type := File_Type'(null, StdIn);
   Standard_Output : constant File_Type := File_Type'(null, StdOut);
   Null_File       : constant File_Type := File_Type'(null, NamedFile);

end Spark_IO;
