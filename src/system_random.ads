with Interfaces;   use Interfaces;
with Interfaces.C; use Interfaces.C;

generic
   type Element is mod <>;
   --  ELement type, must be mod 2**8, i.e. represent a byte

   type Index is range <>;
   --  Index type

   type Element_Array is array (Index range <>) of aliased Element;
   --  An array of aliased Elements
package System_Random with
   Preelaborate
is
   --  @summary
   --  Ada interface to system sources of randomness
   --
   --  @description
   --  This package provides generic interface to OS' sources of randomeness.
   --  On Windows, BCryptGenRandom() is used, on other platforms such as Linux,
   --  BSD, Mac OS portable getentropy() is used.
   --
   --  This is a generic package as it is intended to be used with user-defined
   --  byte array type, that would later be converted to a seed value used to
   --  seed an appropriate strong PRNG algorithm.

   pragma Compile_Time_Error
     (Element'Modulus /= 2**8,
      "'Element' type must be mod 2**8, i.e. represent a byte");

   System_Random_Error : exception;
   --  Raised whenever an underlying system function has failed

   procedure Random (Output : aliased out Element_Array) with
      Pre => Output'Length <= Interfaces.Unsigned_32'Last and
      Output'Length <= Interfaces.C.size_t'Last;
      --  Fill Output with random data. This function call blocks, thus it's
      --  better to call it as few times as possible.
      --
      --  Maximum length of Output array is determined by the underlying system
      --  implementation, and for unix is equal to 256 bytes.
end System_Random;
