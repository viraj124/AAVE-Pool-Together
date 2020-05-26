pragma solidity ^0.6.0;

import "@openzeppelin/contracts-ethereum-package/contracts/Initializable.sol";
import "@openzeppelin/contracts-ethereum-package/contracts/access/Ownable.sol";
import "@openzeppelin/contracts-ethereum-package/contracts/math/SafeMath.sol";
import "@openzeppelin/contracts-ethereum-package/contracts/token/ERC20/IERC20.sol";
 

interface PodInterface {
     // Deposit 
     function deposit(uint256 amount, bytes calldata data) external;

     // Borrow
     function redeem(uint256 amount, bytes calldata data) external;
     
     // Balance Of underlyingAsset
     function balanceOfUnderlying(address user) external view returns (uint256);
}

contract Helper {
     /**
     * @dev get Lending Pool uniswap market ropsten address
     */
    function getPod() public pure returns (address pod) {
        pod = 0x395fcB67ff8fdf5b9e2AeeCc02Ef7A8DE87a6677;
    }
}

/**
 * @dev ATOKEN Interface.
 */
interface AToken {
    function balanceOf(address account) external view returns (uint256);

    function redeem(uint256 _amount) external;
}

contract AavePool is Helper, Initializable, OwnableUpgradeSafe {
    
    using SafeMath for uint256;
    address public aToken = 0x4F96Fe3b7A6Cf9725f59d353F723c1bDb64CA6Aa;
    address public lendingPool = 0x4F96Fe3b7A6Cf9725f59d353F723c1bDb64CA6Aa;
    address public underlyingAsset= 0x4F96Fe3b7A6Cf9725f59d353F723c1bDb64CA6Aa;
	
	address public admin;
	uint256 public version;
	
	event Initialized(address indexed thisAddress);

    function initialize(address _recipient, address _admin) public initializer {
    emit Initialized(address(this));
	OwnableUpgradeSafe.__Ownable_init();
    OwnableUpgradeSafe.transferOwnership(_recipient);
	admin = _admin;
	version = 1;
    }
		  
    /**
     * @dev Invest in Pod throough your atokens
     */
    function invest() public returns(bool)
        {
          // Calling Redeem in Mock AToken
          IERC20(lendingPool).approve(aToken, IERC20(lendingPool).balanceOf(address(this)));
          AToken(aToken).redeem(IERC20(lendingPool).balanceOf(address(this)));

          // Bytes Payload for deposit
          bytes memory _data = bytes("Depositing to Pod");
          
          // Approve Pod
          IERC20(underlyingAsset).approve(getPod(), IERC20(underlyingAsset).balanceOf(address(this)));
          
          // Deposit in Pod
          PodInterface(getPod()).deposit(IERC20(underlyingAsset).balanceOf(address(this)), _data);

          return true;
        }

    function redeem() public onlyOwner returns(bool)
    {
        // Getting Underlying Balance from the Pod
        uint256 underlyingBalance = PodInterface(getPod()).balanceOfUnderlying(msg.sender);
        
        require(underlyingBalance != 0, "Amount to be redeemed should be greater thank 0");
        IERC20(underlyingAsset).approve(getPod(), underlyingBalance);
        
        // Redeeming Underlying Asset for Pod Shares
        bytes memory _data = bytes("Redeeming from Pod");

        PodInterface(getPod()).redeem(underlyingBalance, _data);
        
        // Getting total Balance of Underlying Asset(Pod share + interest)
        uint256 underlyingBalanceInPod = IERC20(underlyingAsset).balanceOf(address(this));

        // Trnasfer to user
        IERC20(underlyingAsset).transfer(msg.sender, underlyingBalanceInPod);

        return true;
    }
}


