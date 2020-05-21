pragma solidity ^0.6.0;

interface PoolInterface {
    // For Checking the winner
     function getDraw(uint256 _drawId) external view returns (
     uint256 feeFraction,
     address feeBeneficiary,
     uint256 openedBlock,
     bytes32 secretHash,
     bytes32 entropy,
     address winner,
     uint256 netWinnings,
     uint256 fee
  );
}
