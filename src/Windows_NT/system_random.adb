pragma Ada_2012;

with System;

package body System_Random is
   --  Underlying OS function, note that program must be linked with bcrypt lib
   function BCryptGenRandom
     (hAlgorithm :     System.Address; --  Algorithm provider handle
      pBuffer    : out Element_Array; --  Output buffer
      cbBuffer   :     Unsigned_32; --  Size, in bytes, of output buffer
      dwFlags    :     Unsigned_32 --  Special flags
   ) return Unsigned_32 with -- Status code is returned
      Import        => True,
      Convention    => C,
      External_Name => "BCryptGenRandom";

      --  Flag for BCryptGenRandom, use system-preferred rng algorithm
   BCRYPT_USE_SYSTEM_PREFERRED_RNG : constant Unsigned_32 := 16#0000_0002#;

   procedure Random (Output : aliased out Element_Array) is
      Return_Code : Unsigned_32 := 0;
   begin
      if Output'Length = 0 then
         return;
      end if;

      Return_Code :=
        BCryptGenRandom
          (System.Null_Address,
      --  For BCRYPT_USE_SYSTEM_PREFERRED_RNG flag, this must be null
      Output,
      --  We're okay with this as Ada should automagically pass an address
      --  of the first array element. Array is defined as aliased array of
      --  aliased Elements, so that no funny business occurs
      Unsigned_32 (Output'Length),
      --  We already checked in contract that Output'Length is less or
      --  equal to Unsigned_32'Last, therefore Constraint_Error is not
      --  going to ever occur here

           BCRYPT_USE_SYSTEM_PREFERRED_RNG);

      --  In windows, status codes less than 0x40000000 indicate success,
      --  and those less than 0x80000000 indicate some kind of informational
      --  message, and can be safely ignored
      if Return_Code >= 16#8000_0000# then
         raise System_Random_Error
           with "BCryptGenRandom failed with status code " & Return_Code'Image;
      end if;
   end Random;
end System_Random;
