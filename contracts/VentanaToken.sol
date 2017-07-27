/*
file:   VentanaToken.sol
ver:    0.0.1
updated:27-July-2017
author: Darryl Morris
email:  o0ragman0o AT gmail.com

A collated contract set for a token sale specific to the requirments of
Veredictum's Ventana token product.

This software is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  
See MIT Licence for further details.
<https://opensource.org/licenses/MIT>.

Release Notes
-------------
0.0.1
* initial code.
*/


pragma solidity ^0.4.13;


library SafeMath
{
    // a add to b
    function add(uint a, uint b) internal returns (uint c) {
        c = a + b;
        assert(c >= a);
    }
    
    // a subtract b
    function sub(uint a, uint b) internal returns (uint c) {
        c = a - b;
        assert(c <= a);
    }
    
    // a multiplied by b
    function mul(uint a, uint b) internal returns (uint c) {
        c = a * b;
        assert(a == 0 || c / a == b);
    }
    
    // a divided by b
    function div(uint a, uint b) internal returns (uint c) {
        c = a / b;
        // No assert required as no overflows are posible.
    }
}
   
contract ReentryProtected
{
    // The reentry protection state mutex.
    bool __reMutex;

    // Sets and resets mutex in order to block functin reentry
    modifier preventReentry() {
        require(!__reMutex);
        __reMutex = true;
        _;
        delete __reMutex;
        return;
    }

    // Blocks function entry if mutex is set
    modifier noReentry() {
        require(!__reMutex);
        _;
    }
}


contract ERC20TokenAbstract
{
/* Constants */

    // none
    
/* State variable */
    // The Total supply of tokens
    uint public totalSupply;
    
    uint8 public decimals;
    
    /// @return Token symbol
    string public symbol;
    
    // Token ownership mapping
    mapping (address => uint) balances;
    
    // Allowances mapping
    mapping (address => mapping (address => uint)) allowed;

/* Events */
    // Triggered when tokens are transferred.
    event Transfer(
        address indexed _from,
        address indexed _to,
        uint256 _value);

    // Triggered whenever approve(address _spender, uint256 _value) is called.
    event Approval(
        address indexed _owner,
        address indexed _spender,
        uint256 _value);

/* Modifiers */

    // none

/* Function Abstracts */
    /// @param _addr The address of a token holder
    /// @return The amount of tokens held by `_addr`
    function balanceOf(address _addr) public constant returns (uint);

    /// @param _owner The address of a token holder
    /// @param _spender the address of a third-party
    /// @return The amount of tokens the `_spender` is allowed to transfer
    function allowance(address _owner, address _spender) public constant
        returns (uint);

    /// @notice Send `_amount` of tokens from `msg.sender` to `_to`
    /// @param _to The address of the recipient
    /// @param _amount The amount of tokens to transfer
    function transfer(address _to, uint256 _amount) public returns (bool);

    /// @notice Send `_amount` of tokens from `_from` to `_to` on the condition
    /// it is approved by `_from`
    /// @param _from The address of the sender
    /// @param _to The address of the recipient
    /// @param _amount The amount of tokens to transfer
    function transferFrom(address _from, address _to, uint256 _amount)
        public returns (bool);

    /// @notice `msg.sender` approves `_spender` to spend `_amount` tokens on
    /// its behalf
    /// @param _spender The address of the approved spender
    /// @param _amount The amount of tokens to transfer
    function approve(address _spender, uint256 _amount) public returns (bool);
}

contract ERC20Token is ReentryProtected, ERC20TokenAbstract
{
    using SafeMath for uint;

    // Using an explicit getter allows for function overloading    
    function balanceOf(address _addr)
        public
        constant
        returns (uint)
    {
        return balances[_addr];
    }
    
    // Using an explicit getter allows for function overloading    
    function allowance(address _owner, address _spender)
        public
        constant
        returns (uint remaining_)
    {
        return allowed[_owner][_spender];
    }

    // Send _value amount of tokens to address _to
    // Reentry protection prevents attacks upon the state
    function transfer(address _to, uint256 _value)
        public
        noReentry
        returns (bool)
    {
        return xfer(msg.sender, _to, _value);
    }

    // Send _value amount of tokens from address _from to address _to
    // Reentry protection prevents attacks upon the state
    function transferFrom(address _from, address _to, uint256 _value)
        public
        noReentry
        returns (bool)
    {
        require(_value <= allowed[_from][msg.sender]);
        
        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
        
        return xfer(_from, _to, _value);
    }

    // Process a transfer internally.
    function xfer(address _from, address _to, uint _value)
        internal
        returns (bool)
    {
        require(_value > 0 && _value <= balances[_from]);
        
        balances[_from]  = balances[_from].sub(_value);
        balances[_to]    = balances[_to].add(_value);
        
        Transfer(_from, _to, _value);
        return true;
    }

    // Approves a third-party spender
    // Reentry protection prevents attacks upon the state
    function approve(address _spender, uint256 _value)
        public
        noReentry
        returns (bool)
    {
        require(balances[msg.sender] != 0);
        
        allowed[msg.sender][_spender] = _value;
        Approval(msg.sender, _spender, _value);
        return true;
    }
}


/*-----------------------------------------------------------------------------\

 Ventana token sale implimentation

\*----------------------------------------------------------------------------*/

// Contains token sale parameters
contract VentanaTokenConfig
{
    string public           symbol          = "VNT";
    address public          owner           = msg.sender;
    address public          fundWallet      = 0x0;
    
    uint public constant    MAX_TOKENS      = 300000000;
    
    // Minimum and maximum target in USD
    uint public constant    TOKENS_PER_ETHER= 1;
    uint public constant    MIN_FUNDS       = 2000000;
    uint public constant    MAX_FUNDS       = 20000000;

    // Post deployment period to allow for verification, publication and
    // discounted addresses
    uint public constant    LEAD_IN_PERIOD  = 7 days;
    
    // Period for fundraising
    uint public constant    FUNDING_PERIOD  = 28 days;

    // Funding opens LEAD_IN_PERIOD after deployment
    uint public             START_DATE      = now + LEAD_IN_PERIOD;
    uint public             END_DATE        = START_DATE + FUNDING_PERIOD;
    
    // Tranch discount multipliers
    uint public constant    T1_WHOLESALER   = 25; // Tranch 1
    uint public constant    T2_WHOLESALER   = 20; // Tranch 2
    uint public constant    T3_MEDIA        = 10; // Tranch 3

    // Preassigned tranch discount addresses
    // holder => discount
    mapping (address => uint) public discounted;
    
}


contract VentanaTokenAbstract is ERC20TokenAbstract
{
    event ChangedOwner(address indexed _from, address indexed _to);
    event ChangeOwnerTo(address indexed _to);
    event NewTokens(address indexed _addr, uint indexed _tokens);
    event DiscountedAddress(address indexed _addr, uint indexed _tranch);

    // Total ether raised during funding
    uint public fundsRaised;
    
    // An address authorised to take ownership
    address public newOwner;
    
    // Return `true` if time exceeds START_DATE, is less than END_DATE and 
    // MAX_FUNDS is not exceeded
    function isFunding() public constant returns (bool);
    
    // Return `true` if MIN_FUNDS were raised
    function fundSucceeded() public constant returns (bool);
    
    // Return `true` if MIN_FUNDS were not raised before END_DATE
    function fundFailed() public constant returns (bool);

    // Registers a discounted address
    function addDiscountedAddress(address _addr, uint _discount)
        public returns (bool);

// TODO  
    // Refund on failed or aborted sale 
    // function refund() public returns (bool);

    // To cancel token sale prior to START_DATE
    // function abort() public returns (bool);
}


contract VentanaToken is ERC20Token, VentanaTokenAbstract, VentanaTokenConfig
{
    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }

    function VentanaTS()
        // VentanaTokenConfig()
    {
        // All parameters in VentanaTSAbstract
    }
    
    function ()
        payable
    {
        proxyPurchase(msg.sender);
    }
    
    function isFunding()
        public
        constant
        returns (bool)
    {
        return now > START_DATE && now < END_DATE && fundsRaised <= MAX_FUNDS;
    }
    
    function fundSucceeded()
        public
        constant
        returns (bool)
    {
        return fundsRaised >= MIN_FUNDS;
    }
    
    function fundFailed()
        public
        constant
        returns(bool)
    {
        return fundsRaised < MIN_FUNDS && now >= END_DATE;
    }
    
    function proxyPurchase(address _addr)
        payable
        preventReentry
    {
        require(isFunding());
        
        // Base tokens
        uint tokens = msg.value.mul(TOKENS_PER_ETHER);
        // Add discounted tokens
        tokens = tokens.mul(discounted[_addr]).add(tokens);
        
        // Update totalSupply
        totalSupply = totalSupply.add(tokens);
        
        // Update holder tokens
        balances[_addr] = balances[_addr].add(tokens);
        
        // Update funds raised
        fundsRaised = fundsRaised.add(msg.value);
        
        // Send funds to fund wallet
        fundWallet.transfer(msg.value);
    }
    
    function addDiscountedAddress(address _addr, uint _tranch)
        public
        onlyOwner
        returns (bool)
    {
        // Discounts can be applied on empty accounts before funding is closed
        require(!fundSucceeded() && !fundFailed());
        // Token account must be empty
        require(balances[_addr] == 0);
        
        uint discount = _tranch == 1 ? T1_WHOLESALER :
                        _tranch == 2 ? T2_WHOLESALER :
                        _tranch == 3 ? T3_MEDIA : 0;
        
        // Bail is no discount to apply
        require(discount != 0);
        
        // apply discount to account
        discounted[_addr] = discount;
        DiscountedAddress(_addr, discount);
    }
        
    function transfer(address _to, uint _amount) returns (bool success) {
        // Token sale must be successful before transfers
        require(fundSucceeded());
        // Standard transfer
        return super.transfer(_to, _amount);
    }

    function transferFrom(address _from, address _to, uint _amount) 
        returns (bool success)
    {
        // Cannot transfer before crowdsale ends or cap reached
        require(fundSucceeded());
        // Standard transferFrom
        return super.transferFrom(_from, _to, _amount);
    }

    // To initiate a ownership change
    function changeOwner(address _newOwner)
        public
        onlyOwner
    {
        ChangeOwnerTo(_newOwner);
        newOwner = _newOwner;
    }
 
    // To accept ownership
    function acceptOwnership()
        public
    {
        require(msg.sender == newOwner);
        ChangedOwner(owner, newOwner);
        owner = newOwner;
    }

    // To salvage ERC20 tokens that may have been sent to the account
    function transferExternalERC20Token(address tokenAddress, uint amount)
      onlyOwner
      returns (bool success) 
    {
        return ERC20Token(tokenAddress).transfer(owner, amount);
    }
}