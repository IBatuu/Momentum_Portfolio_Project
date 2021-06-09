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