pragma solidity 0.5.1;

///We can write two smart contracts that can interact with each other in various ways such as parent and children anology.Here we will use one contract to request a mint from another contract.
contract ERC20Token {
    string public name;
    mapping(address => uint256) public balances;
    function mint() public {
        //Here we want to grant a token to the address that calls the funtion. However, since we use another smart contract to mint the token, we no longer can use the msg.sender since it would try to send the token to the contract address.Thus, we are going to use the tx.origin 
        balances[tx.origin]  ++;
    }
}    
contract MyContract {
    //We will define both state variables wallet and token(ERC20Token).
    address payable wallet;
    address public token;
    
    //In order for our smart contracts communicate with each other, one most access to other's adress. Hence, we will add token address of ERC20Token to MyContract's constructor.
    constructor(address payable _wallet ,address _token) public {
        wallet = _wallet;
        token = _token;
    }
    
    //We are going to add a fallback function. This function is going to have "external" modifier so that buyToken function can only be called from outside not inside.
    function() external payable {
        buyToken();
    }
    
    //We have to add payable to the function in order to be able send eth.
    function buyToken() public payable {
        
        //We are going to reference the ERC20Token contract and store it into a local variable.Also we will call the mint function from the ERC20Token using MyContract smart contract, thus two contracts are going to communicate.
        ERC20Token(address(token)).mint();
        
        //The second property of the function is we will send eth in return for the token. The eth will be paid out to whichever wallet address that we specify during smart contract deployment from the address that calls this function. msg.value gives us the value of funds transfered in return for the token.
        wallet.transfer(msg.value);        
    }
}

