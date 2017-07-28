/*
file:   VentanaToken.sol
ver:    0.0.2
updated:28-July-2017
author: Darryl Morris
email:  o0ragman0o AT gmail.com
(c) Darryl Morris 2017

A collated contract set for a token sale specific to the requirments of
Veredictum's Ventana token product.

This software is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  
See MIT Licence for further details.
<https://opensource.org/licenses/MIT>.

Release Notes
-------------
0.0.2
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
    
    // Move decimal of a, b places to the left 
    function leftShift(uint a, uint b) internal returns (uint c) {
        c = a * uint(10)**b;
        // not a sufficient assert as powers may overflow multiple times
        assert(c > a);
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


contract ERC20Token is ERC20TokenAbstract
{
    using SafeMath for *;

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
        returns (bool)
    {
        return xfer(msg.sender, _to, _value);
    }

    // Send _value amount of tokens from address _from to address _to
    // Reentry protection prevents attacks upon the state
    function transferFrom(address _from, address _to, uint256 _value)
        public
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
        returns (bool)
    {
        require(balances[msg.sender] != 0);
        
        allowed[msg.sender][_spender] = _value;
        Approval(msg.sender, _spender, _value);
        return true;
    }
}


/*-----------------------------------------------------------------------------\

 Ventana token sale configuration

\*----------------------------------------------------------------------------*/

// Contains token sale parameters
contract VentanaTokenConfig
{
    string public           symbol          = "VNT";
    //`2` is minimum precision for discounting calculation
    uint8 public            decimals        = 2;
    address public          owner           = msg.sender;
    
    // Fund wallet should also be audited prior to deployment
    // address public          fundWallet      = 0x0;
    address public          fundWallet      = 0xCA35b7d915458EF540aDe6068dFe2F44E8fa733c;
    
    // Token Cap
    uint constant           MAX_TOKENS      = 300000000;
    
    // Conversion rates. 
    // Can be set post deployment
    uint public             ethUsd          = 5 finney; // (0.005 ether/USD)

    // closest whole number to $0.35/token in spec paper
    uint public constant    TOKENS_PER_USD  = 3;

    // Minimum and maximum target in USD
    uint public constant    MIN_USD_FUNDS   = 2000000;  // $2m
    uint public constant    MAX_USD_FUNDS   = 20000000; // $20m

    // Post deployment period to allow for verification, publication and
    // discounting of selected addresses
    // uint constant           LEAD_IN_PERIOD  = 7 days;
    uint constant           LEAD_IN_PERIOD  = 1 minutes; // 7 days;
    
    // Period for fundraising
    // uint constant           FUNDING_PERIOD  = 28 days;
    uint constant           FUNDING_PERIOD  = 3 minutes; //28 days;

    // Funding opens LEAD_IN_PERIOD after deployment (timestamps can't be constant)
    uint public             START_DATE      = now + LEAD_IN_PERIOD;
    uint public             END_DATE        = START_DATE + FUNDING_PERIOD;
    
    // discounts 
    uint constant           T1_WHOLESALER   = 25; // Tranch 1 25%
    uint constant           T2_WHOLESALER   = 20; // Tranch 2 20%
    uint constant           T3_WHOLESALER   = 15; // Tranch 3 15%
    uint constant           T4_MEDIA        = 10; // Tranch 4 10%
}

/*-----------------------------------------------------------------------------\

Conditional Call Table (functions must throw on F conditions)

function                LEAD_IN_PERIOD  isFunding   fundFailed  fundSucceeded
-----------------------------------------------------------------------------
()                              F        < Caps         F           F
proxyPurchase()                 F        < Caps         F           F
setEthUsd()                     T           TBD         F           T
addDiscountedAddress()          T           T           F           F
abort()                         T           T           T           F
moveFundsToWallet()             F           F           F           T
refund(address _addr)           F           F           T           F
transfer()                      F           F           F           T
transferFrom()                  F           F           F           T
approve()                       F           F           F           T
destroy()                       F           F       !abortFuse      F
                                                    && 0 balance

\*----------------------------------------------------------------------------*/

contract VentanaTokenAbstract
{
    event NewTokens(address indexed _addr, uint indexed _tokens);
    event DiscountedAddress(address indexed _addr, uint indexed _tranch);
    event Refunded(address indexed _addr, uint indexed _value);
    event ChangedOwner(address indexed _from, address indexed _to);
    event ChangeOwnerTo(address indexed _to);

    bool __abortFuse = true;

    // Total ether raised during funding
    uint public etherRaised;
    
    // An address authorised to take ownership
    address public newOwner;
    
    // Preauthorized tranch discount addresses
    // holder => discount
    mapping (address => uint) public discounted;
    
    // Record of ether paid per address
    mapping (address => uint) public etherPaid;

    // Return `true` if time exceeds START_DATE, is less than END_DATE and 
    // MAX_FUNDS is not exceeded
    function isFunding() public constant returns (bool);
    
    // Return `true` if MIN_FUNDS were raised
    function fundSucceeded() public constant returns (bool);
    
    // Return `true` if MIN_FUNDS were not raised before END_DATE
    function fundFailed() public constant returns (bool);

    // Returns USD raised for set ETH/USD rate
    function usdRaised() public constant returns (uint);

    // Returns token/ether conversion given ether value and address. 
    function ethToTokens(uint _eth, address _addr)
        public constant returns (uint);

    // Processes a token purchase for a given address
    function proxyPurchase(address _addr) payable returns (bool);

    // Sets the ETH/USD exchange rate
    function setEthUsd(uint _ethUsd) public returns (bool);

    // Owner can move funds of successful fund to fundWallet 
    function moveFundsToWallet() public returns (bool);
    
    // Registers a discounted address
    function addDiscountedAddress(address _addr, uint _tranch)
        public returns (bool);

    // Refund on failed or aborted sale 
    function refund(address _addr) public returns (bool);

    // To cancel token sale prior to START_DATE
    function abort() public returns (bool);

    // For owner to salvage tokens sent to contract
    function transferAnyERC20Token(address tokenAddress, uint amount)
        returns (bool);
}


/*-----------------------------------------------------------------------------\

 Ventana token implimentation

\*----------------------------------------------------------------------------*/

contract VentanaToken is 
    ReentryProtected,
    ERC20Token,
    VentanaTokenAbstract,
    VentanaTokenConfig
{
    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }

    function VentanaToken()
    {
        // ICO parameters are set in VentanaTSConfig
        // Invalid configuration catching here
        require(owner != 0x0);
        require(fundWallet != 0x0);
        require(decimals >= 2);
        require(MAX_TOKENS != 0);
        require(FUNDING_PERIOD != 0);
        require(ethUsd > 0);
        require(TOKENS_PER_USD > 0);
        require(MAX_USD_FUNDS > 0);
    }
    
    function ()
        payable
    {
        proxyPurchase(msg.sender);
    }

//
// Getters
//

    // ICO is funding if not aborted, time is between start and end dates
    function isFunding()
        public
        constant
        returns (bool)
    {
        return __abortFuse
            && now > START_DATE
            && now < END_DATE;
    }
    
    // ICO succeeds if not aborted and minimum funds are raised before end date
    function fundSucceeded()
        public
        constant
        returns (bool)
    {
        return __abortFuse
            && usdRaised() >= MIN_USD_FUNDS;
    }
    
    // ICO fails if aborted or minimum funds are not raised by the end date
    function fundFailed()
        public
        constant
        returns (bool)
    {
        return !__abortFuse
            || (usdRaised() < MIN_USD_FUNDS && now >= END_DATE);
    }
    
    // Returns the USD value of ether raise at set ETH/USD rate
    function usdRaised()
        public
        constant
        returns (uint)
    {
        return etherRaised.div(ethUsd);
    }
    
    // Returns the number of tokens for given amount of ether for and address 
    function ethToTokens(uint _eth, address _addr)
        public
        constant
        returns (uint)
    {
        // (ether * tokensPerUSD / USD per Eth) * 10^decimals
        uint tokens = _eth.mul(TOKENS_PER_USD).div(ethUsd).leftShift(decimals);
        
        // Add discounted tokens
        tokens = tokens.add(tokens.mul(discounted[_addr]).div(100));
        return tokens;
    }

//
// ICO functions
//

    // The fundraising can be aborted any time before the fund is successful
    function abort()
        public
        noReentry
        onlyOwner
        returns (bool)
    {
        require(!fundSucceeded());
        require(__abortFuse);
        delete __abortFuse;
        return true;
    }
    
    // General addresses can purchase tokens during funding
    function proxyPurchase(address _addr)
        payable
        preventReentry
        returns (bool)
    {
        require(isFunding() || discounted[_addr] > 0);
        require(msg.value > 0);
        
        // Base tokens
        uint tokens = ethToTokens(msg.value, _addr);

        // Update totalSupply
        totalSupply = totalSupply.add(tokens);
        
        // Update holder tokens and payments
        balances[_addr] = balances[_addr].add(tokens);
        etherPaid[_addr] = etherPaid[_addr].add(msg.value);
        
        // Update funds raised
        etherRaised = etherRaised.add(msg.value);
        
        // Bail if this pushes the fund over the USD cap or Token cap
        require(usdRaised() <= MAX_USD_FUNDS);
        require(totalSupply <= MAX_TOKENS.leftShift(decimals));
        
        return true;
    }
    
    // Owner can permission discounts for empty addresses up until close of
    // funding
    function addDiscountedAddress(address _addr, uint _tranch)
        public
        noReentry
        onlyOwner
        returns (bool)
    {
        // Discounts can before funding is closed
        require(!fundSucceeded() && !fundFailed());
        
        // Token account must be empty (else can break refund amounts)
        require(balances[_addr] == 0);
        
        uint discount = _tranch == 1 ? T1_WHOLESALER :
                        _tranch == 2 ? T2_WHOLESALER :
                        _tranch == 3 ? T3_WHOLESALER :
                        _tranch == 4 ? T4_MEDIA : 0;
        
        // Bail if no discount to apply
        require(discount != 0);
        
        // apply discount to account
        discounted[_addr] = discount;
        DiscountedAddress(_addr, discount);
        return true;
    }
    
// TODO investigate using oracle or prevent rate change during funding

    // ETH/USD rate can be changed by the owner.
    function setEthUsd(uint _ethUsd)
        public
        noReentry
        onlyOwner
        returns (bool)
    {
        ethUsd = _ethUsd;
        return true;
    }
    
    // Funds of a successful funding can be moved by the owner to the fundWallet
    function moveFundsToWallet()
        public
        onlyOwner
        preventReentry()
        returns (bool)
    {
        require(fundSucceeded());
        require(this.balance > 0);
        
        fundWallet.transfer(this.balance);
        return true;
    }
    
    // Refunds can be claimed from a failed ICO
    function refund(address _addr)
        public
        preventReentry()
        returns (bool)
    {
        require(fundFailed());
        
        uint refund = etherPaid[_addr];
        
        // garbage collect
        delete etherPaid[_addr];
        delete balances[_addr];
        delete discounted[_addr];
        
        if (refund > 0) {
            _addr.transfer(refund);
            Refunded(_addr, refund);
        }
        return true;
    }

//
// ERC20 overloaded functions
//

    function transfer(address _to, uint _amount)
        public
        noReentry
        returns (bool)
    {
        // Token sale must be successful
        require(fundSucceeded());
        
        // Standard transfer
        return super.transfer(_to, _amount);
    }

    function transferFrom(address _from, address _to, uint _amount)
        public
        noReentry
        returns (bool)
    {
        // Token sale must be successful
        require(fundSucceeded());
        
        // Standard transferFrom
        return super.transferFrom(_from, _to, _amount);
    }
    
    function approve(address _spender, uint _value)
        public
        noReentry
        returns (bool)
    {
        // Token sale must be successful
        require(fundSucceeded());
        
        // Standard approve
        return super.approve(_spender, _value);
    }

//
// Contract managment functions
//

    // To initiate an ownership change
    function changeOwner(address _newOwner)
        public
        noReentry
        onlyOwner
        returns (bool)
    {
        ChangeOwnerTo(_newOwner);
        newOwner = _newOwner;
        return true;
    }
 
    // To accept ownership. Required to prove new address can call the contract.
    function acceptOwnership()
        public
        noReentry
        returns (bool)
    {
        require(msg.sender == newOwner);
        ChangedOwner(owner, newOwner);
        owner = newOwner;
        return true;
    }

    // The contract can be selfdestructed on condition that fund has failed
    // and ether balance is 0.
    function destroy()
        public
        noReentry
        onlyOwner
    {
        require(fundFailed());
        require(this.balance == 0);
        selfdestruct(owner);
    }
    
    // To salvage ERC20 tokens that may have been sent to the account
    function transferAnyERC20Token(address tokenAddress, uint amount)
        onlyOwner
        noReentry
        returns (bool) 
    {
        return ERC20TokenAbstract(tokenAddress).transfer(owner, amount);
    }
}