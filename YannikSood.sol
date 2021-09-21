pragma solidity >=0.6.0 <0.7.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/math/SafeMath.sol";

/**
 * @title Contract that eternalizes your friendship with Yannik Sood on the blockchain
 */
contract YannikSood is ERC721, Ownable {
    
    using SafeMath for uint256;
    using SafeMath32 for uint32;
    using SafeMath8 for uint8;
    
    //need to add more things to this struct. for now, we leave it with a name and a dream
    struct Friend {
        string name;
    }
    
    Friend[] public yanniksFriends;
    
    
    mapping(address => uint8) public friendsInWallet;
    uint256 public constant price = 0.001 ether;
    
    address public constant yanniksWallet = 0xeB6b72e202123B401B0940F905f22097DEeb3ACa;
    
    constructor() public ERC721("yanniksood", "YANNY") {
        // mint the first friend for yannik
        _safeMint(yanniksWallet, 1);
        
        // add it to the array
        yanniksFriends.push(Friend("Yannik Sood"));
    }
    
    //mint a friend. only one per wallet
    function mintFriend(string friendName) public payable {
        
        //do our checks. make sure whoever wants to be my friend isnt already a friend & isnt broke
        require(friendsInWallet[msg.sender] == 0);
        require(msg.value >= price);
    
        //add the friend to my list of friends
        yanniksFriends.push(Friend(friendName));
        
        //now that we are friends, you can't be my friend again. sorry.
        friendsInWallet[msg.sender] = friendsInWallet[msg.sender].add(1);
        
        //mint the token
        _safeMint(msg.sender, yanniksFriends.length - 1);
        
        //pay me. my friendship is valuable
        payable(yanniksWallet).transfer(msg.value);
    }
    
}
