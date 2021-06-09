pragma solidity 0.5.1;

//We can actually simplify our initial contract by removing get and constructor function and defining them into the contract.Also we will make a small adjustments, we will make our state variable constant.
//Thus, our set function will become obsolete and give and error.
contract MyContract {
    string public constant stringValue = "myValue";
    //We can define boolean type state variables as well
    bool public myBool = true;
    //We can add signed and unsigned integers. Uints are the unsigned while ints are the signed integers. That means uints can't have minus signes and etc, while ints can.You can also specify the amounts of bytes in the integer.
    int public myInt = -1;
    uint public myUint = 1;
    uint256 public myUint256 = 9999;
    
}    
    
    
    