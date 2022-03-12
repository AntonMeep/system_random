pragma Ada_2012;

with Interfaces; use Interfaces;
with System;

package body System_Random is
   function BCryptGenRandom
     (hAlgorithm : System.Address; pBuffer : access Element;
      cbBuffer   : Unsigned_32; dwFlags : Unsigned_32) return Unsigned_32 with
      Import        => True,
      Convention    => C,
      External_Name => "BCryptGenRandom";

   BCRYPT_USE_SYSTEM_PREFERRED_RNG : constant Unsigned_32 := 16#0000_0002#;

   procedure Random (Output : out Element_Array) is
      Ret : Unsigned_32;
   begin
      if Output'Length = 0 then
         return;
      end if;

      Ret :=
        BCryptGenRandom
          (System.Null_Address, Output (Output'First)'Access,
           Unsigned_32 (Output'Length), BCRYPT_USE_SYSTEM_PREFERRED_RNG);
      if Ret /= 0 then
         --  Not correct, fix this
         raise System_Random_Error;
      end if;
   end Random;
end System_Random;
