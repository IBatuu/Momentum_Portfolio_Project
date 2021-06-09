pragma solidity 0.5.1;

//Define the contact
contract MyContract {
    //In solidity we need to define type of the state variables, in this case our state variable is string
    string value;
    
    //In solidity, we have a function called constructer that automatically runs when we deploy a smart contract to the blockchain. Also if we want functions to be accessable to everyone, we need to make them public.
    constructor() public {
        value = "myValue";
    }
    
    //Now we are adding the get function to call the state variable, we are making it public and also making it view only so that it returns the initial variable that is deployed with the state variable.

    function get() public view returns(string memory) {
        return value;
    }
    
    //Here we are adding the set function so that we can set our initial state variable to the something different, we can only set it to smh that is string, we also make it public. 
    //The _value is not the same state variable, instead the unerscore defines it to be a local variable
    function set(string memory _value) public {
        value = _value;
    }
    
}