pragma solidity 0.5.1;


//Now we will introduce struct. Structs help you to define your data structure.
contract MyContract {
    //Now instead of using indexing to call first item in the array with index"0", we will use mapping. With mapping we can call 1st in the array by calling "1" instead of calling "0".
    uint256 public peopleCount = 0;
    mapping(uint => Person) public people;
    
    //Here we are going to define the time which we want function to be able to get activated. In solidity we use epoch time.
    uint256 openingTime = 1622386500;
    
    //Now we will introduce modifiers. In this case we will add a modifier into our smart contract so that only specific time frames will have access to specific functions.
    // So we will add owner address, modifier onlyWhileOpen() and add that modifirer into the functions that we want to modify.
    modifier onlyWhileOpen() {
        //Above we defined the opening time of the contract, here we will compare opening time with the current time which we will access via current block time stamp and make a decision accordingly.
        require(block.timestamp >= openingTime);
        _;
    }
    
    //We are defining our data type as a person which will have first and last name attributes as string.
    struct Person {
        uint _id;
        string _firstName;
        string _lastName;
    }
    
    //Now we will create a function to add "Person" data types into our people state variable. It means that we will basically create people. Here we will add time modifier so that fn can only be called in specified times.
    function addPerson(string memory _firstName, string memory _lastName) public onlyWhileOpen {
        incrementCount();
        //Replacing indexing with new ids using mappaing. peopleCount starts with = 0, here we add +1 to the 0 th index 
        people[peopleCount] = Person(peopleCount, _firstName, _lastName);
    }
        
        //Now we will add in an internal function instead of public function, thus it won't be visible to public.
    function incrementCount() internal {
        peopleCount += 1;
    }
        
     
}