pragma solidity 0.5.1;

//Here we are going to introduce libraries and math inside the solidity. We use libraries to DRY or "Don't repeat yourself ". Libraries can be used to store functions and help us achieve leaner smart contracts. They are much more limited then smart contracts in terms of functionality.
library Math {
    //Pure functions ensure that they not read or modify the state. A function can be declared as pure.
    function divide(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b > 0);
        uint256 c = a / b;
        return c;
    }
}

contract MyContract {
    uint256 public value;
    
    //We are going to store the value with the above method and then we will compute it with the following.
    function calculate(uint256 _value1, uint256 _value2) public {
        //Normally we could use the following method instead of having a library: value = _value1 / _value;. However, what if the denominator is 0? Our smart contract would fail the computation.Thus, we use library to prevent it and not allow 0.
        value = Math.divide(_value1, _value2);
    }
}
//We only need to deploy MyContract because Math is also going to compile with MyContract and will be functional.

                                                             //                               //


//One final basic method is to importing Math library from another file so that this file only includes our smart contracts and stay lean.

pragma solidity 0.5.1;

import "./Math.sol";

contract MyContract {
    uint256 public value;
    
    //We are going to store the value with the above method and then we will compute it with the following.
    function calculate(uint256 _value1, uint256 _value2) public {
        //Normally we could use the following method instead of having a library: value = _value1 / _value;. However, what if the denominator is 0? Our smart contract would fail the computation.Thus, we use library to prevent it and not allow 0.
        value = Math.divide(_value1, _value2);
    }
}
