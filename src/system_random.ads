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

   procedure Random (Output : out Element_Array);
   --  Fill Output with random data
end System_Random;
