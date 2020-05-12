pragma solidity ^0.5.0;



contract LendingPoolInterface {
     // Deposit 
     function deposit(address _reserve, uint256 _amount, uint16 _referralCode) external payable;
     
     function getReserveData(address _reserve) external view 
            returns (
            uint256 totalLiquidity,
            uint256 availableLiquidity,
            uint256 totalBorrowsStable,
            uint256 totalBorrowsVariable,
            uint256 liquidityRate,
            uint256 variableBorrowRate,
            uint256 stableBorrowRate,
            uint256 averageStableBorrowRate,
            uint256 utilizationRate,
            uint256 liquidityIndex,
            uint256 variableBorrowIndex,
            address aTokenAddress,
            uint40 lastUpdateTimestamp
            );
}

contract ATokenInterface {
     function redirectInterestStream(address _to) external;
}

contract DSMath {

    function add(uint x, uint y) internal pure returns (uint z) {
        require((z = x + y) >= x, "math-not-safe");
    }

    function sub(uint x, uint y) internal pure returns (uint z) {
        z = x - y <= x ? x - y : 0;
    }

    function mul(uint x, uint y) internal pure returns (uint z) {
        require(y == 0 || (z = x * y) / y == x, "math-not-safe");
    }

    uint constant WAD = 10 ** 18;

    function wmul(uint x, uint y) internal pure returns (uint z) {
        z = add(mul(x, y), WAD / 2) / WAD;
    }

    function wdiv(uint x, uint y) internal pure returns (uint z) {
        z = add(mul(x, WAD), y / 2) / y;
    }

}


contract Helper is DSMath {
     /**
     * @dev get Lending Pool address
     */
    function getLendingPool() public pure returns (address lendingpool) {
        lendingpool = 0x398eC7346DcD622eDc5ae82352F02bE94C62d119;
    }
     /**
     * @dev get pool contract address 
     */
    function getPoolBase() public pure returns (address poolToken) {
        poolToken = 0x29fe7D60DdF151E5b52e5FAB4f1325da6b2bD958;
    }
}


interface IERC20 {
    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `recipient`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address recipient, uint256 amount) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint amount) external returns (bool);

    /**
     * @dev Moves `amount` tokens from `sender` to `recipient` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

contract AavePool is Helper {
    
     /**
     * @dev Pool Together Pool Entering Functionality through Redirecting Interest from Aave
     * @param token - token to deposit
     * @param depositAmt - amount to deposit on AAVE
     */
    function addPool(
        address token,
        uint depositAmt
        ) public
        {
            // Depositing Token on Aave to get AToken
            LendingPoolInterface(getLendingPool()).deposit.value(0)(token, depositAmt, 0);
            // Fetching the ATOKEN Address from the reserve address
            (, , , , , , , , , , , address atoken,) = LendingPoolInterface(getLendingPool()).getReserveData(msg.sender);
            // Redirtecting Interest to Enter into a Pool
            // Right Now Using Pool Dai Address will have to add condition based on the reserve token whether to redirect token to Pool Dai or Pool Usdc
            ATokenInterface(atoken).redirectInterestStream(getPoolBase());
        }
        
}

