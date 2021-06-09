pragma solidity 0.5.1;


//Now we will introduce struct. Structs help you to define your data structure.
contract MyContract {
    //Now instead of using indexing to call first item in the array with index"0", we will use mapping. With mapping we can call 1st in the array by calling "1" instead of calling "0".
    uint256 public peopleCount = 0;
    mapping(uint => Person) public people;
    
    address owner;
    
    //Now we will introduce modifiers. In this case we will add a modifier into our smart contract so that only specific addresses will have access to certain functions (admins).
    // So we will add owner address, modifier onlyOwner() and add that modifirer into the functions that we want to modify.
    modifier onlyOwner() {
        //msg.sender is a special command that tells us who is calling the function. So we will require only owner to access the function and will give an error if anything else. "require" looks whether whatever we put in is true.
        require(msg.sender == owner);
        _;
    }
    
    //We are defining our data type as a person which will have first and last name attributes as string.
    struct Person {
        uint _id;
        string _firstName;
        string _lastName;
    }
    
    //Now we will set the owner address. We want it to be executed as we deploy the smart contract. Thus, we will use a constructor function.
    constructor() public {
        owner = msg.sender;
    }
    
    //Now we will create a function to add "Person" data types into our people state variable. It means that we will basically create people.
    function addPerson(string memory _firstName, string memory _lastName) public onlyOwner {
        incrementCount();
        //Replacing indexing with new ids using mappaing. peopleCount starts with = 0, here we add +1 to the 0 th index 
        people[peopleCount] = Person(peopleCount, _firstName, _lastName);
    }
        
        //Now we will add in an internal function instead of public function, thus it won't be visible to public.
    function incrementCount() internal {
        peopleCount += 1;
    }
        
     
}