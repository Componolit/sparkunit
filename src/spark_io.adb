-------------------------------------------------------------------------------
-- This file is part of SPARKUnit.
--
-- Copyright (C) 2018 Componolit GmbH
-- All rights reserved.
--
-- Redistribution  and  use  in  source  and  binary  forms,  with  or  without
-- modification, are permitted provided that the following conditions are met:
--
--    * Redistributions of source code must retain the above copyright notice,
--      this list of conditions and the following disclaimer.
--
--    * Redistributions in binary form must reproduce the above copyright
--      notice, this list of conditions and the following disclaimer in the
--      documentation and/or other materials provided with the distribution.
--
--    * Neither the name of the  nor the names of its contributors may be used
--      to endorse or promote products derived from this software without
--      specific prior written permission.
--
-- THIS SOFTWARE IS PROVIDED BY THE  COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
-- AND ANY  EXPRESS OR IMPLIED WARRANTIES,  INCLUDING, BUT NOT LIMITED  TO, THE
-- IMPLIED WARRANTIES OF  MERCHANTABILITY AND FITNESS FOR  A PARTICULAR PURPOSE
-- ARE  DISCLAIMED. IN  NO EVENT  SHALL  THE COPYRIGHT  HOLDER OR  CONTRIBUTORS
-- BE  LIABLE FOR  ANY  DIRECT, INDIRECT,  INCIDENTAL,  SPECIAL, EXEMPLARY,  OR
-- CONSEQUENTIAL  DAMAGES  (INCLUDING,  BUT  NOT  LIMITED  TO,  PROCUREMENT  OF
-- SUBSTITUTE GOODS  OR SERVICES; LOSS  OF USE,  DATA, OR PROFITS;  OR BUSINESS
-- INTERRUPTION)  HOWEVER CAUSED  AND ON  ANY THEORY  OF LIABILITY,  WHETHER IN
-- CONTRACT,  STRICT LIABILITY,  OR  TORT (INCLUDING  NEGLIGENCE OR  OTHERWISE)
-- ARISING IN ANY WAY  OUT OF THE USE OF THIS SOFTWARE, EVEN  IF ADVISED OF THE
-- POSSIBILITY OF SUCH DAMAGE.
-------------------------------------------------------------------------------

with Ada.Text_IO;

package body SPARK_IO
is
   procedure Put_Line (Item : in String;
                       Stop : in Natural)
   is
      Last : constant Natural := (if Stop = 0 then Item'Last else Stop);
   begin
      Ada.Text_IO.Put_Line (Item (Item'First .. Last));
   end Put_Line;

   procedure Put_String (Item : in String;
                         Stop : in Natural)
   is
      Last : constant Natural := (if Stop = 0 then Item'Last else Stop);
   begin
      Ada.Text_IO.Put (Item (Item'First .. Last));
   end Put_String;

   procedure New_Line (Spacing : in Positive)
   is
   begin
      Ada.Text_IO.New_Line (Ada.Text_IO.Positive_Count (Spacing));
   end New_Line;

   procedure Put_Char (Item : in Character)
   is
   begin
      Ada.Text_IO.Put (Item);
   end Put_Char;

   procedure Put_Integer (Item : in Integer)
   is
      Val : constant String := Item'Img;
   begin
      if Item > 0 then
         Ada.Text_IO.Put (Val (Val'First + 1 .. Val'Last));
      else
         Ada.Text_IO.Put (Val);
      end if;
   end Put_Integer;

end SPARK_IO;
