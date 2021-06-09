pragma solidity 0.5.1;

//Finally we have a really useful library from openzeppelin called SafeMath. We can also import and use it in the following methods
import "./SafeMath.sol";

contract MyContract {
    using SafeMath for uint256;
    uint256 public value;
    
    //We are going to store the value with the above method and then we will compute it with the following.
    function calculate(uint256 _value1, uint256 _value2) public {
        //Normally we could use the following method instead of having a library: value = _value1 / _value;. However, what if the denominator is 0? Our smart contract would fail the computation.Thus, we use library to prevent it and not allow 0.
        value = _value1.div(_value2);
    }
}