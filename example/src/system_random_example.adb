with Ada.Unchecked_Conversion;

with Ada.Streams; use Ada.Streams;
with Ada.Text_IO; use Ada.Text_IO;
with System_Random;

procedure System_Random_Example is
   package Streams_Random is new System_Random
     (Element       => Stream_Element, Index => Stream_Element_Offset,
      Element_Array => Stream_Element_Array);

   --  We have to make sure that byte sizes of both parameters are equal
   function Convert is new Ada.Unchecked_Conversion
     (Stream_Element_Array, Integer);

   use Streams_Random;

   Random_Values : Stream_Element_Array (1 .. 4) := (others => 0);
begin
   Random (Random_Values); --  Fill with random data
   Put_Line ("Random integer: " & Convert (Random_Values)'Image);
end System_Random_Example;
