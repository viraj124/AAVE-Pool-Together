
// File: contracts\ProxyFactory.sol

pragma solidity ^0.6.0;

// solium-disable security/no-inline-assembly
// solium-disable security/no-low-level-calls
contract ProxyFactory {

  event ProxyCreated(address proxy);

  function deployMinimal(address _logic, bytes memory _data) public returns (address proxy) {
    // Adapted from https://github.com/optionality/clone-factory/blob/32782f82dfc5a00d103a7e61a17a5dedbd1e8e9d/contracts/CloneFactory.sol
    bytes20 targetBytes = bytes20(_logic);
    assembly {
      let clone := mload(0x40)
      mstore(clone, 0x3d602d80600a3d3981f3363d3d373d3d3d363d73000000000000000000000000)
      mstore(add(clone, 0x14), targetBytes)
      mstore(add(clone, 0x28), 0x5af43d82803e903d91602b57fd5bf30000000000000000000000000000000000)
      proxy := create(0, clone, 0x37)
    }

    emit ProxyCreated(address(proxy));

    if(_data.length > 0) {
      (bool success,) = proxy.call(_data);
      require(success, "constructor call failed");
    }
  }
}

// File: contracts\intermediatefactory.sol

pragma solidity ^0.6.0;


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