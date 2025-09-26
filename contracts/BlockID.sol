
pragma solidity ^0.8.0;


contract BlockID {
    
   
    struct Identity {
        string name;
        string email;
        uint256 timestamp;
        bool isVerified;
        bool exists;
    }
    
    
    mapping(address => Identity) private identities;
    

    mapping(address => bool) public verifiedUsers;
    

    event IdentityCreated(address indexed user, string name);
    event IdentityVerified(address indexed user);
    event IdentityUpdated(address indexed user, string newName, string newEmail);

    modifier identityExists(address _user) {
        require(identities[_user].exists, "Identity does not exist");
        _;
    }
    
   
    modifier onlyOwner(address _user) {
        require(msg.sender == _user, "Not authorized to modify this identity");
        _;
    }
    
    
    function createIdentity(string memory _name, string memory _email) public {
        require(!identities[msg.sender].exists, "Identity already exists");
        require(bytes(_name).length > 0, "Name cannot be empty");
        require(bytes(_email).length > 0, "Email cannot be empty");
        
        identities[msg.sender] = Identity({
            name: _name,
            email: _email,
            timestamp: block.timestamp,
            isVerified: false,
            exists: true
        });
        
        emit IdentityCreated(msg.sender, _name);
    }
    
   
    function verifyIdentity(address _user) public identityExists(_user) {
       
        identities[_user].isVerified = true;
        verifiedUsers[_user] = true;
        
        emit IdentityVerified(_user);
    }
    
    
    function updateIdentity(string memory _newName, string memory _newEmail) 
        public 
        identityExists(msg.sender) 
        onlyOwner(msg.sender) 
    {
        require(bytes(_newName).length > 0, "Name cannot be empty");
        require(bytes(_newEmail).length > 0, "Email cannot be empty");
        
        identities[msg.sender].name = _newName;
        identities[msg.sender].email = _newEmail;
        
        emit IdentityUpdated(msg.sender, _newName, _newEmail);
    }
    
 
    function getIdentity(address _user) 
        public 
        view 
        identityExists(_user) 
        returns (string memory name, string memory email, uint256 timestamp, bool isVerified) 
    {
        Identity memory identity = identities[_user];
        return (identity.name, identity.email, identity.timestamp, identity.isVerified);
    }
    
    
    function isVerified(address _user) public view returns (bool) {
        return identities[_user].exists && identities[_user].isVerified;
    }
}
