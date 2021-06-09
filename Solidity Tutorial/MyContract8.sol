pragma solidity 0.5.1;
contract MyContract {
    mapping(address => uint256) public balances;
    //We will define a state variable called wallet
    address payable wallet;
    
    //Here we are going to introduce events in solidity. Events broadcast information within smartcontracts to the subscribers in the blockchain. So, if people subscribe to a smart contract that has events in it, they can know every time a function is used and triggered an event. 
    event Purchase(
    //We will add "_buyer" local variable which highlights the buyer of a coin. "indexed" modifier helps us to differentiate buyers.
    address indexed _buyer,
    //"_amount" local variable helps to highlight the amount of coins transacted.
    uint256 _amount
    );
    
    constructor(address payable _wallet) public {
        wallet = _wallet;
    }
    
    //We are going to add a fallback function. This function is going to have "external" modifier so that buyToken function can only be called from outside not inside.
    function() external payable {
        buyToken();
    }
    
    //We have to add payable to the function in order to be able send eth.
    function buyToken() public payable {
        //This function will have two properties to it. First one is that whenever we call this function, we will be granted a token.
        balances[msg.sender]  +=1;
        
        //The second property of the function is we will send eth in return for the token. The eth will be paid out to whichever wallet address that we specify during smart contract deployment from the address that calls this function. msg.value gives us the value of funds transfered in return for the token.
        wallet.transfer(msg.value);
        
        //Here we add the event trigger for every purchase that takes place. `emit` keyword has been introduced to emit the event. This will help to differentiate the functions from event.
        emit Purchase(msg.sender, 1);
    }
}