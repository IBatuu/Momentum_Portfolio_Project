pragma solidity 0.5.1;


//Now we will introduce struct. Structs help you to define your data structure.
contract MyContract {
    //Now instead of using indexing to call first item in the array with index"0", we will use mapping. With mapping we can call 1st in the array by calling "1" instead of calling "0".
    uint256 public peopleCount = 0;
    mapping(uint => Person) public people;
    
    //We are defining our data type as a person which will have first and last name attributes as string.
    struct Person {
        uint _id;
        string _firstName;
        string _lastName;
    }
    
    //Now we will create a function to add "Person" data types into our people state variable. It means that we will basically create people.
    function addPerson(string memory _firstName, string memory _lastName) public {
        peopleCount += 1;
        //Replacing indexing with new ids using mappaing. peopleCount starts with = 0, here we add +1 to the 0 th index 
        people[peopleCount] = Person(peopleCount, _firstName, _lastName);
        
        
    } 
}