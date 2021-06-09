pragma solidity 0.5.1;

//Now we are going to introduce contract inheretance realtionship. Similarly to the last section, we are going to have two smart contracts interacting with eachother. But this time, their relationship will be child-parent or inheretance.
contract ERC20Token {
    string public name;
    mapping(address => uint256) public balances;
    
    constructor(string memory _name) public {
        name = _name;
    }
    
    function mint() public {
        //Here we want to grant a token to the address that calls the funtion. However, since we use another smart contract to mint the token, we no longer can use the msg.sender since it would try to send the token to the contract address.Thus, we are going to use the tx.origin 
        balances[tx.origin]  ++;
    }
}

//Under this contract, we are going to override the first contract by defining it the second time.
contract MyToken is ERC20Token {
    //string public name =  "My Token";
    
    //Above commented line overrides the first contract with a hard value. Instead, we can inherete the contact with another constructor method.
    string public symbol;
    
    //Here we want to keep track of the people who owns the token.
    address[] public owners;
    uint256 ownerCount;
    
    constructor(string memory _name, string memory _symbol) ERC20Token(_name) public {
        symbol = _symbol;
    }
    //Here we are going to override the mint function.
    function mint() public {
        //super.mint is going to call the mint function of the parent contract.The super keyword in Solidity gives access to the immediate parent contract from which the current contract is derived. When having a contract A with a function f() that derives from B which also has a function f(), A overrides the f of B. That means that myInstanceOfA.f() will call the version of f that is implemented inside A itself, the original version implemented inside B is not visible anymore
        super.mint();
        //Then we will increment balances who already own.
        ownerCount ++;
        //Then we will add them to the array of owners.
        owners.push(msg.sender);
    }

}

//Instead of deploying both smart contracts to the blockchain, we only need to deploy the child contract that is My Token thanks to the inheretance property.