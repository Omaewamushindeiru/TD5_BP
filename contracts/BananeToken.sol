pragma solidity >= 0.4.24;  
  
import "../openzeppelin-solidity/contracts/token/ERC20/StandardToken.sol";  
import "../openzeppelin-solidity/contracts/ownership/Ownable.sol";  

contract BananeToken is StandardToken, Ownable{  
  
    uint256 public TotalSupply;  
    string public name;  
    string public ticker;  
    uint32 public decimals;

    uint public levels;
    //mapping(uint => uint) levelsValue;
    mapping(address => uint) whitelist;
    address[] public whitelisted;

   
    constructor() public {  
        ticker = "BNT";  
        name = "BananeToken";  
        decimals = 5;  
        TotalSupply = 100000000000;
        levels = 1; 
  
        owner = msg.sender;  
        balances[msg.sender] = TotalSupply;  
    }

// add to white list and set up multi level distribution
    function addToWhiteList(address addr, uint level) public {
        require(msg.sender == owner);
        require(whitelist[addr] == 0);
        require(level > 0 && level <= levels);
        whitelist[addr] = level;
        whitelisted.push(addr);
    }

    function airdrop(uint256 tokenPerAddr) public {
        require(msg.sender == owner);
        require(tokenPerAddr * whitelisted.length <= balances[owner] && tokenPerAddr > 0);

        for(uint256 i = 0; i < whitelisted.length; i++){
            transfer(whitelisted[i], tokenPerAddr);
        }
    }

    function addLevel() public {
        require(msg.sender == owner);
        levels++;
    }

    function levelOf(address tokenOwner) public view returns (uint) {
        return whitelist[tokenOwner];
    }


    function totalSupply() public view returns (uint256) {
        return totalSupply_;
    }

    function balanceOf(address tokenOwner) public view returns (uint) {
        return balances[tokenOwner];
    }


    function allowance(address owner,address delegate) public view returns (uint) {
        return allowed[owner][delegate];
    }

    function isWhitelisted(address tokenOwner) public view returns (bool){
        return (whitelist[tokenOwner] != 0);
    }

    function transfer(address receiver,uint numTokens) public returns (bool) {
        require(whitelist[receiver] != 0);
        require(numTokens <= balances[msg.sender]);
        balances[msg.sender] = balances[msg.sender] - numTokens;
        balances[receiver] = balances[receiver] + numTokens;
        emit Transfer(msg.sender, receiver, numTokens);
        return true;
    }

    function approve(address delegate, uint numTokens) public returns (bool) {
        allowed[msg.sender][delegate] = numTokens;
        emit Approval(msg.sender, delegate, numTokens);
        return true;
    }


    function transferFrom(address owner, address buyer,uint numTokens) public returns (bool) {
        require(whitelist[buyer] != 0);
        require(numTokens <= balances[owner]);
        require(numTokens <= allowed[owner][msg.sender]);
        balances[owner] = balances[owner] - numTokens;
        allowed[owner][msg.sender] = allowed[buyer][msg.sender] - numTokens;
        balances[buyer] = balances[buyer] + numTokens;
        emit Transfer(owner, buyer, numTokens);
        return true;
    }
}