pragma solidity ^0.6.0;

import "openzeppelin-solidity/contracts/token/ERC20/IERC20.sol";

contract mockatoken {

     IERC20 public atokenaddress;
	 IERC20 public underlying;
     
	 //underlying address is contract address of dai
     //instead of creating another atoken contract I have inherited it in lending pool so plz pass address of lending pool here
     constructor(IERC20 _atokenaddress,IERC20 _underlying) public {
       atokenaddress = _atokenaddress;
	   underlying = _underlying;
     }
     
	 //mocking atoken redeem functionality
	 //first approve adai on this contract just as normal adai approval
	 function redeem(uint256 _amount) external {
	 atokenaddress.transferFrom(msg.sender,address(this),_amount);
	 underlying.transfer(msg.sender,_amount);
	 }
	 
     //mocking aave atoken redirectInterestStream function but transfers balance of this contract to _to
     //after it recieves atokens minted in previous step this will send atokens in this contract to _to
     //this will mimic atoken contract on mainet
     function redirectInterestStream(address _to) external {
       atokenaddress.transfer(_to,atokenaddress.balanceOf(address(this)));
     }
}
