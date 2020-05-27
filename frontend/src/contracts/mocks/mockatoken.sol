
// File: openzeppelin-solidity\contracts\token\ERC20\IERC20.sol

pragma solidity ^0.6.0;

/**
 * @dev Interface of the ERC20 standard as defined in the EIP.
 */
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
    function approve(address spender, uint256 amount) external returns (bool);

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

// File: contracts\mocks\mockatoken.sol

pragma solidity ^0.6.0;


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
       atokenaddress.transfer(_to ,atokenaddress.balanceOf(address(this)));
     }
}