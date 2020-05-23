pragma solidity ^0.6.0;

import "./interfaces/IAtoken.sol";
import "./interfaces/IPod.sol";
import "openzeppelin-solidity/contracts/token/ERC20/IERC20.sol";

contract intermediate {
  mapping(address=>bool) public call_limit;
  ATokenInterface public atokenaddress;
  IERC20 public underlyingtoken;

  constructor(ATokenInterface _atokenaddress,IERC20 _underlyingtoken) public {
    atokenaddress = _atokenaddress;
    underlyingtoken = _underlyingtoken;
  }

  //exchange atokens interest in this contract to underlying and sends to Pod contract
  function accumulateredeem() public {
    //only those who redirected interest to intermediate contract are true
    require(call_limit[msg.sender] == true,"not allowed sorry");
    uint256 tempbalance = atokenaddress.balanceOf(address(this));
    //redemm all atokens accumulated in this contract as atokens to underlying token
    uint256 tempdaiamt = atokenaddress.redeem(tempbalance);
    //sending tempdaiamt to pod contract
  }

}
