%lang starknet

from starkware.cairo.common.bitwise import bitwise_and, bitwise_not, bitwise_or
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin, HashBuiltin
from starkware.cairo.common.math import unsigned_div_rem
from starkware.cairo.common.math_cmp import is_le_felt

const BITS_IN_FELT = 124;

@storage_var
func store(index: felt) -> (value: felt) {
}

@external
func set_bit{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, bitwise_ptr: BitwiseBuiltin*}(
   key: felt
) {
    alloc_locals;
    let (local word_index, local bit_index) = find_bit(key);
    let (local word_before) = store.read(word_index);
    let (bit_mask) = two_to_the_n(bit_index);
    let (word_after) = bitwise_or(word_before, bit_mask);
    store.write(word_index, word_after);
    return();
}

@external
func clear_bit{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, bitwise_ptr: BitwiseBuiltin*}(
   key: felt
) {
    alloc_locals;
    let (local word_index, local bit_index) = find_bit(key);
    let (local word_before) = store.read(word_index);
    let (inv_bit_mask) = two_to_the_n(bit_index);
    let (bit_mask) = bitwise_not(inv_bit_mask);
    let (word_after) = bitwise_and(word_before, bit_mask);
    store.write(word_index, word_after);
    return();
}

@external
func get_bit{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, bitwise_ptr: BitwiseBuiltin*}(
   key: felt
) -> (value: felt) {
    alloc_locals;
    let (local word_index, local bit_index) = find_bit(key);
    let (local word) = store.read(word_index);
    let (bit_mask) = two_to_the_n(bit_index);
    let (bit_in_lsb, _) = unsigned_div_rem(word, bit_mask);
    let (bit) = bitwise_and(bit_in_lsb, 1);
    return(value=bit);
}

func find_bit{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
   key: felt
) -> (word_index: felt, bit_index: felt){
    let (word_index, bit_index) = unsigned_div_rem(key, BITS_IN_FELT);
    return (word_index, bit_index);
}

func two_to_the_n{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
   n: felt
) -> (result: felt) {
    let result = two_to_the_n_acc(n=n, accumulator=1);
    return(result);
}

// Multiplying by 2 up to 123 times in a recursive loop is a bit inefficient, and we
// can't use the expression 2**n as Cairo v0.9 doesn't support that. We can use constant
// expressions like 2**120, so one possible approach would be to store all 123 possible
// powers of 2 and have a giant if statement that returns the correct one with no
// mutliplications required. The compromise approach used here is to store just a
// selection of the powers of 2 spread  over the range from 2 to 120 and build the
// result in a series of up to 7 multiplications.

func two_to_the_n_acc{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
   n: felt, accumulator: felt
) -> (result: felt) {
    if (n == 0) {
        return(result=accumulator);
    }
    let n_gt_120 = is_le_felt(120, n);
    if (n_gt_120 == 1) {
        return two_to_the_n_acc(n=n-120, accumulator=accumulator*(2**120));
    }
    let n_gt_64 = is_le_felt(64, n);
    if (n_gt_64 == 1) {
        return two_to_the_n_acc(n=n-64, accumulator=accumulator*(2**64));
    }
    let n_gt_32 = is_le_felt(32, n);
    if (n_gt_32 == 1) {
        return two_to_the_n_acc(n=n-32, accumulator=accumulator*(2**32));
    }
    let n_gt_16 = is_le_felt(16, n);
    if (n_gt_16 == 1) {
        return two_to_the_n_acc(n=n-16, accumulator=accumulator*(2**16));
    }
    let n_gt_8 = is_le_felt(8, n);
    if (n_gt_8 == 1) {
        return two_to_the_n_acc(n=n-8, accumulator=accumulator*(2**8));
    }
    let n_gt_4 = is_le_felt(4, n);
    if (n_gt_4 == 1) {
        return two_to_the_n_acc(n=n-4, accumulator=accumulator*(2**4));
    }
    let n_gt_2 = is_le_felt(2, n);
    if (n_gt_2 == 1) {
        return two_to_the_n_acc(n=n-2, accumulator=accumulator*(2**2));
    }
    return two_to_the_n_acc(n=n-1, accumulator=accumulator*2);
}
