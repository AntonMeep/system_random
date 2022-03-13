pragma Ada_2012;

package body System_Random is
   --  Underlying libc function
   function getentropy
     (buffer : out Element_Array; length : size_t) return int with
      Import        => True,
      Convention    => C,
      External_Name => "getentropy";

   procedure Random (Output : aliased out Element_Array) is
      Return_Code : int := 0;
   begin
      Return_Code := getentropy (Output, size_t (Output'Length));
      --  We're okay with this as Ada should automagically pass an address
      --  of the first array element. Array is defined as aliased array of
      --  aliased Elements, so that no funny business occurs
      --  We already checked in contract that Output'Length is less or
      --  equal to size_t'Last, therefore Constraint_Error is not
      --  going to ever occur here

      if Return_Code /= 0 then
         raise System_Random_Error
           with "getentropy failed with status code " & Return_Code'Image;
      end if;
   end Random;
end System_Random;
