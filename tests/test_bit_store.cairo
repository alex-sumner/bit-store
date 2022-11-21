%lang starknet

from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin, HashBuiltin
from src.bit_store import set_bit, clear_bit, get_bit

@external
func test_find_bit{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, bitwise_ptr: BitwiseBuiltin*}() {
    alloc_locals;
    let (local keys: felt*) = alloc();
    assert keys[0] = 0;
    assert keys[1] = 1;
    assert keys[2] = 248;
    assert keys[3] = 249;
    assert keys[4] = 250;
    assert keys[5] = 251;
    assert keys[6] = 252;
    assert keys[7] = 253;
    assert keys[8] = 254;
    let (local expected_vals_0: felt*) = alloc();
    assert expected_vals_0[0] = 0;
    assert expected_vals_0[1] = 0;
    assert expected_vals_0[2] = 0;
    assert expected_vals_0[3] = 0;
    assert expected_vals_0[4] = 0;
    assert expected_vals_0[5] = 0;
    assert expected_vals_0[6] = 0;
    assert expected_vals_0[7] = 0;
    assert expected_vals_0[8] = 0;
    check(9, keys, expected_vals_0);
    set_bit(0);
    set_bit(249);
    set_bit(250);
    set_bit(251);
    set_bit(252);
    set_bit(253);
    let (local expected_vals_1: felt*) = alloc();
    assert expected_vals_1[0] = 1;
    assert expected_vals_1[1] = 0;
    assert expected_vals_1[2] = 0;
    assert expected_vals_1[3] = 1;
    assert expected_vals_1[4] = 1;
    assert expected_vals_1[5] = 1;
    assert expected_vals_1[6] = 1;
    assert expected_vals_1[7] = 1;
    assert expected_vals_1[8] = 0;
    check(9, keys, expected_vals_1);
    clear_bit(0);
    clear_bit(250);
    clear_bit(251);
    clear_bit(252);
    let (local expected_vals_2: felt*) = alloc();
    assert expected_vals_2[0] = 0;
    assert expected_vals_2[1] = 0;
    assert expected_vals_2[2] = 0;
    assert expected_vals_2[3] = 1;
    assert expected_vals_2[4] = 0;
    assert expected_vals_2[5] = 0;
    assert expected_vals_2[6] = 0;
    assert expected_vals_2[7] = 1;
    assert expected_vals_2[8] = 0;
    check(9, keys, expected_vals_2);
    return();
}

func check{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, bitwise_ptr: BitwiseBuiltin*}(
    num_keys: felt, keys:felt*, expected_vals:felt*
) {
    if (num_keys == 0) {
        return();
    }
    let key = [keys];
    let (stored_bit) = get_bit(key);
    let expected = [expected_vals];
    assert stored_bit = expected;
    return check(num_keys-1, keys+1, expected_vals+1);
}
