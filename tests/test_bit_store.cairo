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
    assert keys[2] = 118;
    assert keys[3] = 119;
    assert keys[4] = 122;
    assert keys[5] = 123;
    assert keys[6] = 124;
    assert keys[7] = 125;
    assert keys[8] = 248;
    assert keys[9] = 249;
    assert keys[10] = 250;
    assert keys[11] = 251;
    assert keys[12] = 252;
    print(13, keys);
    set_bit(0);
    set_bit(123);
    set_bit(124);
    set_bit(250);
    set_bit(251);
    set_bit(249);
    %{
        print('set bits: 0, 123, 124, 249, 250, 251')
    %}
    print(13, keys);
    clear_bit(0);
    clear_bit(123);
    clear_bit(250);
    %{
        print('cleared bits: 0, 123, 250')
    %}
    print(13, keys);
    return();
}

func print{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, bitwise_ptr: BitwiseBuiltin*}(
    num_keys: felt, keys:felt*
) {
    if (num_keys == 0) {
        return();
    }
    let key = [keys];
    let (bit) = get_bit(key);
    %{
        print(f'{ids.key} -> {ids.bit}')
    %}
    return print(num_keys-1, keys+1);
}
