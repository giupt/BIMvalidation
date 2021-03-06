//SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.4.17;

import "https://github.com/giupt/BIMvalidation/blob/main/Ownable.sol";

contract IPFSupload is Ownable {
    string public file = "IPFS_hash";
    
    //number of delivery of the same type of file 
    uint public myUint;
    
    function setMyUint(uint _myUint) public {
        myUint = _myUint;
    }
        
    function setIPFShash(string memory _file) public{
    file = _file;
    }
}
