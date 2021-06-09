pragma solidity 0.5.1;


//Now we will introduce struct. Structs help you to define your data structure.
contract MyContract {
    //Here we create an array of datatype Person that we defined below , we will make it public and store it into the people state variable.
    Person[] public people;
    
    //We are defining our data type as a person which will have first and last name attributes as string.
    struct Person {
        string _firstName;
        string _lastName;
    }
    
    //Now we will create a function to add "Person" data types into our people state variable. It means that we will basically create people.
    function addPerson(string memory _firstName, string memory _lastName) public {
        people.push(Person(_firstName, _lastName));
        
    } 
    
}