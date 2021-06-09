pragma solidity 0.5.1;

contract MyContract {
    //Now we introduce the enum which is the short version of enumarable. Enums restrict a variable to have one of only a few predefined values. The values in this enumerated list are called enums.
    //With the use of enums it is possible to reduce the number of bugs in your code.
    enum State { Waiting, Ready, Active }
    State public state;
    
    constructor() public {
        state = State.Waiting;
    }
    
    //We have set the initial state to waiting, now we will create a function to activate it.
    function activate() public {
        state = State.Active;
    }
    
    //We will write a function to check whether the state is active or not.
    function isActive() public view returns(bool) {
        return state == State.Active;
    }
    //As we compile and deploy our contract and test it, state gives uint answers. Those indicate the indexes of the enum states that are currently valid.
}