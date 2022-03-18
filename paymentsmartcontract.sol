pragma solidity ^0.4.17;

import "https://github.com/giupt/BIMvalidation/blob/main/OracleInterface.sol";
import "https://github.com/giupt/BIMvalidation/blob/main/Ownable.sol";


/// @title BIMvalidation
/// @notice Takes verifications and handles payouts if they are validated 
contract BIMvalidation is Ownable {
    

    //this creates a simple mapping of an ethereum address to a number
    mapping(address => uint) public balances;

    //mappings 
    mapping(bytes32 => Validation[]) private verificationToValidations;

    /// send/deposit money in the contract
    function deposit() onlyOwner public payable {
        balances[msg.sender] += msg.value;
    }
    
    //This returns the full amount of ETH the contract holds
    function getBalance() public view returns (uint) {
        return balances[msg.sender];
    }

    //BIM verification results oracle 
    address internal BIMOracleAddr = 0;
    OracleInterface internal BIMOracle = OracleInterface(BIMOracleAddr); 


    struct Validation {
        bytes32 verificationId;
        uint amount;
        uint obtainedPercentage;
        uint8 chosenResult;
    }


    /// @notice sets the address of the boxing oracle contract to use 
    /// @dev setting a wrong address may result in false return value, or error 
    /// @param _oracleAddress the address of the boxing oracle 
    /// @return true if connection to the new oracle address was successful
    function setOracleAddress(address _oracleAddress) external onlyOwner returns (bool) {
        BIMOracleAddr = _oracleAddress;
        BIMOracle = OracleInterface(BIMOracleAddr); 
        return BIMOracle.testConnection();
    }

    /// @notice gets the address of the boxing oracle being used 
    /// @return the address of the currently set oracle 
    function getOracleAddress() external view returns (address) {
        return BIMOracleAddr;
    }
 

    /// @notice returns the full data of the specified verification 
    /// @param _verificationId the id of the desired verification
    /// @return verification data 
    function getVerification(bytes32 _verificationId) public view returns (
        bytes32 id,
        string discipline,
        string team,
        uint cycle,
        uint date,
        uint percentage,
        OracleInterface.VerificationResult result) {

        return BIMOracle.getVerification(_verificationId); 
    }

    ///a specific account can withdraw the money if the result is approved this withdraws all the money that an account has send to the contract
    /// @param _amount is the amount of money to be sent to the design team 
    function withdraw(address _receiver, uint _amount, uint _obtainedPercentage, uint8 _chosenResult) onlyOwner public payable {
        require(balances[msg.sender] >= _amount, "Insufficient funds");
        require(_obtainedPercentage >=90, "Insufficient percentage");
        require(_chosenResult == 1, "Design not validated");
        balances[msg.sender] -= _amount;
        balances[_receiver] += _amount;
    }


    /// @notice for testing; tests that the BIM oracle is callable 
    /// @return true if connection successful 
    function testOracleConnection() public view returns (bool) {
        return BIMOracle.testConnection(); 
    }
}
