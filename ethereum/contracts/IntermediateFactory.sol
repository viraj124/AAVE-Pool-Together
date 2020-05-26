pragma solidity ^0.6.0;

import "./ProxyFactory.sol";

contract IntermediateFactory is ProxyFactory {

    mapping (address => address) public intermediateList; // maps user => intermediate proxy

    event IntermediateCreated(address indexed _address);

    function createIntermediate(address _target, address _user) external {

        address _admin = msg.sender;
        bytes memory _payload = abi.encodeWithSignature("initialize(address,address)", _user, _admin);

        // Deploy proxy
        address _intermediate = deployMinimal(_target, _payload);
        emit IntermediateCreated(_intermediate);

        intermediateList[_user] = _intermediate;
    }
	
	function getIntermediateUser(address _user) public view returns (address) {
    return intermediateList[_user];
    }
}