/*
file:   VentanaToken.sol
ver:    0.0.5_freeze
updated:1-Aug-2017
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
0.0.5_freeze
* changed `function addBonusAddress()` to `function addKycAddress`
* changed `bonuses` to `kycBonuses`
* fixed missing proxyPurchase event
* fixed refund local variable overloading refund function identifier
* updated totalSupply on refund
* Code freeze.
*/


pragma solidity ^0.4.13;

/*-----------------------------------------------------------------------------\

 Ventana token sale configuration

\*----------------------------------------------------------------------------*/

// Contains token sale parameters
contract VentanaTokenConfig
{
    // ERC20 trade symbol
    string public           symbol          = "VNT";

    // Owner has power to abort, discount addresses, sweep successful funds,
    // change owner, sweep alien tokens.
    address public          owner           = msg.sender;
    
    // Fund wallet should also be audited prior to deployment
    // NOTE: Must be checksummed address!
    address public constant FUND_WALLET     = 0xCA35b7d915458EF540aDe6068dFe2F44E8fa733c;
    
    // Tokens awarded per USD contributed
    uint public constant    TOKENS_PER_USD  = 3;

    // Ether market price in USD
    uint public constant    USD_PER_ETH     = 200;
    
    // Minimum and maximum target in USD
    uint public constant    MIN_USD_FUND    = 2000000;  // $2m
    uint public constant    MAX_USD_FUND    = 20000000; // $20m
    
    // Non-KYC contribution limit in USD
    uint public constant    KYC_USD_LMT     = 10000;
    
    // Prefunding period to allow for verification, publication and
    // discounting and contributions for selected addresses
    uint constant           PREFUND_PERIOD  = 7 days;
    
    // Period for fundraising
    uint constant           FUNDING_PERIOD  = 21 days;

    // % bonus token tranches for KYC'ed funders
    uint constant T1 = 5;  // Tranch 5%
    uint constant T2 = 10; // Tranch 10%
    uint constant T3 = 15; // Tranch 15%
    uint constant T4 = 20; // Tranch 20%
    uint constant T5 = 25; // Tranch 25%
}


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
    /// @return The Total supply of tokens
    uint public totalSupply;
    
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
        returns (uint)
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

Conditional Entry Table (functions must throw on F conditions)

renetry prevention on all public mutating functions
Reentry mutex set in moveFundsToWallet(), refund()

function                LEAD_IN_PERIOD  isFunding   fundFailed  fundSucceeded
-----------------------------------------------------------------------------
()                              F     <MAX_USD_FUND     F           F
proxyPurchase()                 F     <MAX_USD_FUND     F           F
addKycAddress()                 T           T           F           F
abort()                         T           T           T           F
moveFundsToWallet()             F           F           F           T
refund(address _addr)           F           F           T           F
transfer()                      F           F           F           T
transferFrom()                  F           F           F           T
approve()                       F           F           F           T
destroy()                       F           F      !__abortFuse     F
changeOwner()                   T           T           T           T
AcceptOwnership()               T           T           T           T
transferAnyERC20Tokens()        T           T           T           T
-----------------------------------------------------------------------------

\*----------------------------------------------------------------------------*/

contract VentanaTokenAbstract
{
    event NewTokens(address indexed _addr, uint indexed _tokens);
    event DiscountedAddress(address indexed _addr, uint indexed _tranch);
    event Refunded(address indexed _addr, uint indexed _value);
    event ChangedOwner(address indexed _from, address indexed _to);
    event ChangeOwnerTo(address indexed _to);
    event FundsTransferred(address indexed _wallet, uint indexed _value);

    bool __abortFuse = true;

    // Total ether raised during funding
    uint public etherRaised;
    
    // An address authorised to take ownership
    address public newOwner;
    
    // Preauthorized tranch discount addresses
    // holder => discount
    mapping (address => uint) public kycBonuses;
    
    // Record of ether paid per address
    mapping (address => uint) public etherContributed;

    // Return `true` if time exceeds FUND_DATE, is less than END_DATE and 
    // MAX_FUNDS is not exceeded
    function isFunding() public constant returns (bool);
    
    // Return `true` if MIN_FUNDS were raised
    function fundSucceeded() public constant returns (bool);
    
    // Return `true` if MIN_FUNDS were not raised before END_DATE
    function fundFailed() public constant returns (bool);

    // Returns USD raised for set ETH/USD rate
    function usdRaised() public constant returns (uint);

    // Returns token/ether conversion given ether value and address. 
    function weiToTokens(uint _eth, address _addr)
        public constant returns (uint);

    // Processes a token purchase for a given address
    function proxyPurchase(address _addr) payable returns (bool);

    // Owner can move funds of successful fund to fundWallet 
    function moveFundsToWallet() public returns (bool);
    
    // Registers a discounted address
    function addKycAddress(address _addr, uint _tranch)
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
    using SafeMath for uint;

//
// Constants
//

    // Token conversion factors are calculated with decimal places at parity with ether
    uint8 public constant decimals = 18;

    // USD to ether conversion factors calculated from `VentanaTokenConfig` constants 
    uint public constant TOKENS_PER_ETH = TOKENS_PER_USD * USD_PER_ETH;
    uint public constant MIN_ETH_FUND   = 1 ether * MIN_USD_FUND / USD_PER_ETH;
    uint public constant MAX_ETH_FUND   = 1 ether * MAX_USD_FUND / USD_PER_ETH;
    uint public constant KYC_ETH_LMT    = 1 ether * KYC_USD_LMT  / USD_PER_ETH;

    // General funding opens LEAD_IN_PERIOD after deployment (timestamps can't be constant)
    uint public FUND_DATE = now + PREFUND_PERIOD;
    uint public END_DATE  = FUND_DATE + FUNDING_PERIOD;

//
// Modifiers
//

    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }

    // Constructor
    function VentanaToken()
    {
        // ICO parameters are set in VentanaTSConfig
        // Invalid configuration catching here
        require(bytes(symbol).length > 0);
        require(owner != 0x0);
        require(FUND_WALLET != 0x0);
        require(TOKENS_PER_USD > 0);
        require(USD_PER_ETH > 0);
        require(MIN_USD_FUND > 0);
        require(MAX_USD_FUND > MIN_USD_FUND);
        require(PREFUND_PERIOD > 0);
        require(FUNDING_PERIOD > 0);
    }
    
    // Default function
    function () payable
    {
        proxyPurchase(msg.sender);
    }

//
// Getters
//

    // ICO is funding if not aborted and time is between fund and end dates
    function isFunding() public constant returns (bool)
    {
        return __abortFuse
            && now >= FUND_DATE
            && now < END_DATE;
    }
    
    // ICO succeeds if not aborted, minimum funds are raised before end date
    // and funds have been swept to wallet
    function fundSucceeded() public constant returns (bool)
    {
        return __abortFuse
            && this.balance == 0
            && etherRaised >= MIN_ETH_FUND
            && now >= END_DATE;
    }
    
    // ICO fails if aborted or minimum funds are not raised by the end date
    function fundFailed() public constant returns (bool)
    {
        return !__abortFuse
            || (now >= END_DATE && etherRaised < MIN_ETH_FUND);
    }
    
    // Returns the USD value of ether raise at set USD/ETH rate
    function usdRaised() public constant returns (uint)
    {
        return etherRaised.mul(USD_PER_ETH).div(1 ether);
    }
    
    // Returns the number of tokens for given amount of ether for an address 
    function weiToTokens(uint _wei, address _addr) public constant returns (uint)
    {
        return _wei.mul(TOKENS_PER_ETH).mul(kycBonuses[_addr] + 100).div(100);
    }

//
// ICO functions
//

    // The fundraising can be aborted any time before funds are swept to he fundWallet
    // This will force a fail state and allow refunds to be collected.
    function abort()
        public
        noReentry
        onlyOwner
        returns (bool)
    {
        require(!fundSucceeded());
        delete __abortFuse;
        return true;
    }
    
    // General addresses can purchase tokens during funding
    function proxyPurchase(address _addr)
        payable
        noReentry
        returns (bool)
    {
        require(!fundFailed());
        require(!fundSucceeded());
        require(msg.value > 0);
        // Only discounted addresses can fund during the PREFUND_PERIOD.
        require(isFunding() || (kycBonuses[_addr] > 0 && now < END_DATE));
        
        // Non-KYC'ed funders can only contribute up to $10000USD;
        if(kycBonuses[_addr] == 0) require(msg.value <= KYC_ETH_LMT);

        // Base tokens
        uint tokens = weiToTokens(msg.value, _addr);
        
        // Update totalSupply
        totalSupply = totalSupply.add(tokens);
        
        // Update holder tokens and payments
        balances[_addr] = balances[_addr].add(tokens);
        etherContributed[_addr] = etherContributed[_addr].add(msg.value);
        
        // Update funds raised
        etherRaised = etherRaised.add(msg.value);
        
        // Bail if this pushes the fund over the USD cap or Token cap
        require(etherRaised <= MAX_ETH_FUND);

        NewTokens(_addr, tokens);
        return true;
    }
    
    // Owner can permission bonus token accounts up until close of funding
    function addKycAddress(address _addr, uint _tranch)
        public
        noReentry
        onlyOwner
        returns (bool)
    {
        require(!fundFailed());
        require(!fundSucceeded());

        uint bonus = _tranch == 5 ? T1 :
                     _tranch == 10 ? T2 :
                     _tranch == 15 ? T3 :
                     _tranch == 20 ? T4 :
                     _tranch == 25 ? T5 : 0;
        
        // Bail if no discount to apply
        require(bonus != 0);
        
        // Apply discount to account
        kycBonuses[_addr] = bonus;
        DiscountedAddress(_addr, bonus);
        return true;
    }
    
    // Owner can sweep a successful funding to the fundWallet
    // Contract can be aborted up until this action.
    function moveFundsToWallet()
        public
        onlyOwner
        preventReentry()
        returns (bool)
    {
        require(!fundFailed());
        require(this.balance >= MIN_ETH_FUND);
        require(now >= END_DATE);

        FundsTransferred(FUND_WALLET, this.balance);
        FUND_WALLET.transfer(this.balance);
        return true;
    }
    
    // Refunds can be claimed from a failed ICO
    function refund(address _addr)
        public
        preventReentry()
        returns (bool)
    {
        require(fundFailed());
        
        uint value = etherContributed[_addr];
        
        totalSupply = totalSupply.sub(balances[_addr]);
        
        // garbage collect
        delete etherContributed[_addr];
        delete balances[_addr];
        delete kycBonuses[_addr];
        
        if (value > 0) {
            _addr.transfer(value);
            Refunded(_addr, value);
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
        // Token sale must be successful and funds swept to wallet
        require(fundSucceeded());
        return super.transfer(_to, _amount);
    }

    function transferFrom(address _from, address _to, uint _amount)
        public
        noReentry
        returns (bool)
    {
        // Token sale must be successful and funds swept to wallet
        require(fundSucceeded());
        return super.transferFrom(_from, _to, _amount);
    }
    
    function approve(address _spender, uint _value)
        public
        noReentry
        returns (bool)
    {
        // Token sale must be successful and funds swept to wallet
        require(fundSucceeded());
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

    // The contract can be selfdestructed after abort and ether balance is 0.
    function destroy()
        public
        noReentry
        onlyOwner
    {
        require(!__abortFuse);
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