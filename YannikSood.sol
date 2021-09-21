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
    
    
    struct Friend {
        uint256 traits;
        string name;
    }
    
    Friend[] public yanniksFriends;
    
    
    mapping(address => uint8) public friendsInWallet;
    uint256 public constant price = 0.001 ether;
    
    address public constant yanniksWallet = 0xeB6b72e202123B401B0940F905f22097DEeb3ACa;
    
    
    //mint a friend. only one per wallet
    function mintFriend(string friendName) public payable {
        
        //do our checks. make sure whoever wants to be my friend isnt already a friend & isnt broke
        require(friendsInWallet[msg.sender] == 0);
        require(msg.value >= price);
        
        //create a random sequence for our friend based on the name, to be used for traits. similar to cryptozombies
        
        //ddd the friend to my list of friends
        yanniksFriends.push(friendName, 123);
        
        //now that we are friends, you can't be my friend again. sorry.
        friendsInWallet[msg.sender] = friendsInWallet[msg.sender].add(1);
        
    }
    
    function generateFriendTraits(string friendName) private returns (uint256) {
        uint traits = uint(keccak256(abi.encodePacked(friendName)));
        
        
    }
}
