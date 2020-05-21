pragma solidity ^0.6.0;

import "openzeppelin-solidity/contracts/token/ERC20/IERC20.sol";
import "openzeppelin-solidity/contracts/token/ERC20/ERC20.sol";

contract mocklendingpool is ERC20 {

     IERC20 public underlyingtokenaddress;
	 
	 //just useless Returns
     uint256 totalLiquidity = 1000000;
     uint256 availableLiquidity = 100000;
     uint256 totalBorrowsStable = 100000;
     uint256 totalBorrowsVariable = 100000;
     uint256 liquidityRate = 100000;
     uint256 variableBorrowRate = 100000;
     uint256 stableBorrowRate = 100000;
     uint256 averageStableBorrowRate = 100000;
     uint256 utilizationRate = 100000;
     uint256 liquidityIndex = 100000;
     uint256 variableBorrowIndex = 100000;
     address aTokenAddress = 0x6F5587E191C8b222F634C78111F97c4851663ba4;
     uint40 lastUpdateTimestamp = 100;

     constructor(IERC20 _underlyingtokenaddress) ERC20("adai", "adai") public {
       underlyingtokenaddress = _underlyingtokenaddress;
     }

     function getReserveData(address _reserve) external view returns (
       uint256,
       uint256,
       uint256,
       uint256,
       uint256,
       uint256,
       uint256,
       uint256,
       uint256,
       uint256,
       uint256,
       address,
       uint40
       ) {
            return (
           totalLiquidity,
           availableLiquidity,
          totalBorrowsStable,
           totalBorrowsVariable,
          liquidityRate,
           variableBorrowRate,
           stableBorrowRate,
            averageStableBorrowRate,
             utilizationRate,
             liquidityIndex,
             variableBorrowIndex,
             aTokenAddress,
             lastUpdateTimestamp
            );
          }

      //first approve this contract by calling approve method of _underlyingtokenaddress
      //then call depost with reserve addess as mockatoken _amount and have referrel code as any uint16 number
      //this will transfer underlying tokens to this contracts
      //mint atokens to msg.sender
      //create interest balance out of thin air
      //transfer interets balance in form of atokens to mockatoken so they can be used further for redirection

      function deposit(address _reserve, uint256 _amount, uint16 _referralCode) external payable {
        underlyingtokenaddress.transferFrom(msg.sender,address(this),_amount);
        uint256 interest = 1000;
        _mint(msg.sender,_amount);
        _mint(address(this),interest);
        transfer(_reserve,interest);
      }
}
