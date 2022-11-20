Protostar project containing Starknet contract and test that packs individual bit values into felt storage slots.

Functions as a map from felt to bool, with three `@external` funcs.

`set_bit(key: felt)` - sets the value stored for `key` to be 1

`clear_bit(key: felt)` - sets the value stored for `key` to be 0

`get_bit(key:felt) -> (value: felt)` returns the value stored for `key`. Returns 0 if no value has ever been set for `key`.

Internally the values are stored in felt words, with 124 values stored in each felt. This is just under half the theoretical 
maximum of 251 bits per felt, but still uses less than 1% of the storage that a simple implementation using one felt for each value
would need. The reason we are limited to 124 bits is that the implementation uses  `unsigned_div_rem` from 
`starkware.cairo.common.math` to divide the felt value by 2 to the power n, where n is the index of the bit we are 
interested in, to move it to the least significant bit position. This means passing `2**n` as the `div` argument to 
`unsigned_div_rem` and 124 is the largest value of n for which `2**n` is accepted by that function.
 
