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

   pragma Compile_Time_Error
     (Element'Modulus /= 2**8,
      "'Element' type must be mod 2**8, i.e. represent a byte");

   System_Random_Error : exception;

   procedure Random (Output : aliased out Element_Array) with
      Pre => Output'Length <= Interfaces.Unsigned_32'Last and
      Output'Length <= Interfaces.C.size_t'Last;
      --  Fill Output with random data
end System_Random;
