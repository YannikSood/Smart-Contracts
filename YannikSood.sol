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
    
    //need to add more things to this struct
    struct Friend {
        string name;
        bool bestFriend;
    }
    
    bool public mintStatus = true;
    uint256 public price = 0.0001 ether;
    uint256 public bestiePrice = 1 ether;
    
    Friend[] public yanniksFriends;
    mapping(address => uint8) public friendsInWallet;
    mapping(address => uint) public whichFriend;
    
    address public constant yanniksWallet = 0xeB6b72e202123B401B0940F905f22097DEeb3ACa;
    
    constructor() public ERC721("yanniksood", "YANNY") {
        //todo: add to ipfs
        
        // mint the first friend for yannik
        _safeMint(yanniksWallet, 1);
        
        // add it to the array
        yanniksFriends.push(Friend("Yannik Sood", true));
        friendsInWallet[yanniksWallet] = friendsInWallet[yanniksWallet].add(1);
        whichFriend[yanniksWallet] = yanniksFriends.length() - 1;
    }
    
    //mint a friend. only one per wallet
    function mintFriend(string friendName) public payable {
        
        //do our checks
        require(mintStatus == true);
        require(friendsInWallet[msg.sender] == 0);
        require(msg.value >= price);
    
        //mint the token
        _safeMint(msg.sender, yanniksFriends.length - 1);
        payable(yanniksWallet).transfer(msg.value);
        
        //add the friend to my list of friends
        yanniksFriends.push(Friend(friendName, false));
        
        //now that we are friends, you can't be my friend again. sorry.
        friendsInWallet[msg.sender] = friendsInWallet[msg.sender].add(1);
        
        //save the index where this address's friend is chilling
        whichFriend[msg.sender] = yanniksFriends.length() - 1;
    }
    
    //once you are a friend, you can upgrade yourself to become a best friend. this will come with perks
    function selfUpgradeToBestie() public payable {
        require(friendsInWallet[msg.sender] == 1);
        require(msg.value >= bestiePrice);
        require(yanniksFriends[whichFriend[msg.sender]].bestFriend == false);
        yanniksFriends[whichFriend[msg.sender]].bestFriend = true;
        payable(yanniksWallet).transfer(msg.value);
    }
    
    //if i really fuck with you ill upgrade you to best friend status for free <3
    function upgradeToBestie(address addy) public onlyOwner {
        require(yanniksFriends[whichFriend[addy]].bestFriend == false);
        yanniksFriends[whichFriend[addy]].bestFriend = true;
    }
    
    //in case i feel like keeping my circle small
    function changeMintStatus(bool _mintStatus) public onlyOwner {
        mintStatus = _mintStatus;
    }
    
    //to see how many friends i have
    function getNumberOfFriends() returns (uint) {
        return yanniksFriends.length;
    }
}
