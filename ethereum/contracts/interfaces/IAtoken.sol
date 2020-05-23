pragma solidity ^0.6.0;

interface ATokenInterface {
     function redirectInterestStream(address _to) external;
     function balanceOf(address _user) external;
     function redeem(uint256 _amount) external;
}
