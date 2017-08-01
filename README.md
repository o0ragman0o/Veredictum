# Veredictum Ventana Token Sale

Ethereum Token sale and embedded ERC20 Token for the Veredictum anti-piracy platform on distributed technology.

[www.veredictum.io](https://www.veredictum.io/)

This contract is written in order to raise an inital fund of ether in exchange for ERC20 tokens which will have utility value upon the Veredictum platform.

The fund raising period is from deployment and over 28 days with the first 7 days being reserved for lodging KYC authorised addresses and funding.
Non-KYC addresses may fund after the first 7 days but will be limited according to juristictional regulations to a maximum equivilent contribution of $10,000USD.
KYC'ed addresses will also receive bonus tokens from 5% to 25% be determined at time of registration.

The ICO fund raising has a minimum cap of $2,000,000USD and maximum of $20,000,000USD with a base conversion ratio of 3 VNT tokens per US dollar.

ETH/USD calculations are at the rate given at deployment.

The ICO will only be considered successful if the funds raised exceed the minimum cap by the 29th day.
Successfully raised funds can be swept by the owner into the fund wallet after close of funding.

The ICO will be considered failed if the minimum cap has not been reach by the 29th day or the owner has aborted the ICO.
In the event of a failed ICO, the ether funds can be recovered unto the funders using the `refund(address)` function.
This function will return ether contributed by the address back to the address. It may be called by anyone on the condition the fund has failed.

If a security issue arrises during the time of funding and up until funds are swept to the fund wallet, the owner can call `abort()`. This will halt any further funding and allow refunds to be enacted.

ERC20 token transfers are prevented until successfully raised funds are swept to the fund wallet.

## Release Notes v0.0.5_freeze

* changed `function addBonusAddress()` to `function addKycAddress`
* changed `bonuses` to `kycBonuses`
* fixed missing proxyPurchase event
* fixed refund local variable overloading refund function identifier
* updated totalSupply on refund
* using `__sweptFuse` to allow/deny abort (in case issue arrises with fund wallet during funding)
* Code freeze.

## Deployment Instructions

The contract parameters are hard coded and must be updated before compilation and depolyment.
(note: USD_PER_ETH may be moved into the constructor as a parameter to allow for rate at time of deployment)

## ABI
```
[{"constant":false,"inputs":[{"name":"_spender","type":"address"},{"name":"_value","type":"uint256"}],"name":"approve","outputs":[{"name":"","type":"bool"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"FUND_DATE","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"isFunding","outputs":[{"name":"","type":"bool"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"totalSupply","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_from","type":"address"},{"name":"_to","type":"address"},{"name":"_amount","type":"uint256"}],"name":"transferFrom","outputs":[{"name":"","type":"bool"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"decimals","outputs":[{"name":"","type":"uint8"}],"payable":false,"type":"function"},{"constant":false,"inputs":[],"name":"abort","outputs":[{"name":"","type":"bool"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"MAX_ETH_FUND","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_addr","type":"address"}],"name":"proxyPurchase","outputs":[{"name":"","type":"bool"}],"payable":true,"type":"function"},{"constant":false,"inputs":[],"name":"moveFundsToWallet","outputs":[{"name":"","type":"bool"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"END_DATE","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"fundSucceeded","outputs":[{"name":"","type":"bool"}],"payable":false,"type":"function"},{"constant":true,"inputs":[{"name":"_wei","type":"uint256"},{"name":"_addr","type":"address"}],"name":"weiToTokens","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"fundFailed","outputs":[{"name":"","type":"bool"}],"payable":false,"type":"function"},{"constant":true,"inputs":[{"name":"_addr","type":"address"}],"name":"balanceOf","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"MIN_ETH_FUND","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"MAX_USD_FUND","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[],"name":"acceptOwnership","outputs":[{"name":"","type":"bool"}],"payable":false,"type":"function"},{"constant":false,"inputs":[],"name":"destroy","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"owner","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"symbol","outputs":[{"name":"","type":"string"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"KYC_ETH_LMT","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_newOwner","type":"address"}],"name":"changeOwner","outputs":[{"name":"","type":"bool"}],"payable":false,"type":"function"},{"constant":true,"inputs":[{"name":"","type":"address"}],"name":"etherContributed","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_to","type":"address"},{"name":"_amount","type":"uint256"}],"name":"transfer","outputs":[{"name":"","type":"bool"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"MIN_USD_FUND","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"USD_PER_ETH","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":true,"inputs":[{"name":"","type":"address"}],"name":"kycBonuses","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"TOKENS_PER_ETH","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_addr","type":"address"},{"name":"_tranch","type":"uint256"}],"name":"addKycAddress","outputs":[{"name":"","type":"bool"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"etherRaised","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"KYC_USD_LMT","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"newOwner","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"TOKENS_PER_USD","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"tokenAddress","type":"address"},{"name":"amount","type":"uint256"}],"name":"transferAnyERC20Token","outputs":[{"name":"","type":"bool"}],"payable":false,"type":"function"},{"constant":true,"inputs":[{"name":"_owner","type":"address"},{"name":"_spender","type":"address"}],"name":"allowance","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"FUND_WALLET","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"usdRaised","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_addr","type":"address"}],"name":"refund","outputs":[{"name":"","type":"bool"}],"payable":false,"type":"function"},{"inputs":[],"payable":false,"type":"constructor"},{"payable":true,"type":"fallback"},{"anonymous":false,"inputs":[{"indexed":true,"name":"_addr","type":"address"},{"indexed":true,"name":"_tokens","type":"uint256"}],"name":"NewTokens","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"name":"_addr","type":"address"},{"indexed":true,"name":"_tranch","type":"uint256"}],"name":"DiscountedAddress","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"name":"_addr","type":"address"},{"indexed":true,"name":"_value","type":"uint256"}],"name":"Refunded","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"name":"_from","type":"address"},{"indexed":true,"name":"_to","type":"address"}],"name":"ChangedOwner","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"name":"_to","type":"address"}],"name":"ChangeOwnerTo","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"name":"_wallet","type":"address"},{"indexed":true,"name":"_value","type":"uint256"}],"name":"FundsTransfered","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"name":"_from","type":"address"},{"indexed":true,"name":"_to","type":"address"},{"indexed":false,"name":"_value","type":"uint256"}],"name":"Transfer","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"name":"_owner","type":"address"},{"indexed":true,"name":"_spender","type":"address"},{"indexed":false,"name":"_value","type":"uint256"}],"name":"Approval","type":"event"}]
```

## Ventana token sale configuration
The ICO configuration is by way of precompiled constants. At a minimum, `FUNDWALLET` and `USD_PER_ETH` are required to be edited with correct values.

```
contract VentanaTokenConfig
{
    // ERC20 trade symbol
    string public           symbol          = "VNT";

    // Owner has power to abort, discount addresses, sweep successful funds,
    // change owner, sweep alien tokens.
    address public          owner           = msg.sender;
    
    // Fund wallet should also be audited prior to deployment
    // NOTE: Must be checksummed address!
    address public constant FUNDWALLET      = 0x0;
    
    // Tokens awarded per USD contributed
    uint public constant    TOKENS_PER_USD  = 3;

    // Ether market price in USD
    uint public constant    USD_PER_ETH     = 200;
    
    // Minimum and maximum target in USD
    uint public constant    MIN_USD_FUND    = 2000000;  // $2m
    uint public constant    MAX_USD_FUND    = 20000000; // $20m
    
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
```

`symbol` Ventana trade symbol "VNT"

`owner` The address of the contract owner.
The owner has powers to call:

* `moveFundsToWallet()` On condition the ICO is successful
* `addDiscountAddress()` Up until the END_DATE
* `abort()` On condition the ICO has not succeeded
* `changeOwner()` At any time

`fundWallet` The wallet that raised funds will be swept if the ICO is successful

`TOKENS_PER_USD` The base number of tokens to be created per US dollar equivilent paid 

`USD_PER_ETH` The ETH/USD market rate at the time of deployment.
This is used for token creation calculations.

`MIN_USD_FUND` The minimum USD funds required for the ICO to be successful

`MAX_USD_FUND` The maximum USD funds that can be raised

`KYC_USD_LMT` The USD limit over which *Know Your Customer* regulations apply.
Funders who are not KYC'd can only contribute up to this amount.
    
`PREFUND_PERIOD` The period before general funding opens.
KYC'ed contributors can contribute during this period until funding closes.
Anonymous contributors must wait until funding opens.
    
`FUNDING_PERIOD` The period after PREFUND_PERIOD until funding closes.

`T1` Tranch 5%

`T2` Tranch 10%

`T3` Tranch 15%

`T4` Tranch 20%

`T5` Tranch 25%

Tranch table. A table of bonus tokens percentages for precommitted and KYC's funders.

## ERC20 Functions

### symbol
```
function symbol() public constant returns (string)
```
Returns the ERC20 trade symbol

### totalSupply
```
function totalSupply() public constant returns (uint)
```
Returns the total supply of tokens

### balanceOf
```
function balanceOf(address _addr) public constant returns (uint)
```
Returns the balance of tokens for an address

### allowance
```
function allowance(address _owner, address _spender) public constant returns (uint)
```
Returns the balance of tokens a thridparty may transfer from an address

### transfer
```
function transfer(address _to, uint256 _amount) public returns (bool)
```
Transfers an amount of tokens to a recipient address

`_to` The address of the recipient

`_amount` The amount of tokens to transfer

Returns success bool

### transferFrom
```
function transferFrom(address _from, address _to, uint256 _amount) public returns (bool)
```
Transfers and amount of tokens from a third party address to a recipient on the condition
it is approved by the third party

`_from` The holder address of tokens to be sent
`_to` The address of the recipient
`_amount` The amount of tokens to transfer

### approve
```
function approve(address _spender, uint256 _amount) public returns (bool)
```
Approves a spend to transfer an amount of tokens

`_spender` The address of the approved spender

`_amount` The amount of tokens the spender is allowed to transfer

## VentanaToken Functions

### ()
```
function () payable
```
The default function is payable and calls `proxyPurchase(msg.sender)`

### isFunding
```
function isFunding() public constant returns (bool)
```
Returns `true` if time exceeds FUND_DATE, is less than END_DATE and 
ICO has not been aborted

### fundSucceeded
```
function fundSucceeded() public constant returns (bool)
```
Returns `true` if MIN_FUNDS were raised by END_DATE and ICO was not
aborted
    
### fundFailed
```
function fundFailed() public constant returns (bool)
```
Returns `true` if MIN_FUNDS were not raised before END_DATE or ICO was
aborted
    
### etherRaised
```
function etherRaised() public constant returns (uint)
```
Returns the total ether raised during funding

### usdRaised
```
function usdRaised() public constant returns (uint)
```
Returns the USD equivilent raised for the set ETH/USD rate

### TOKENS_PER_ETH
```
function TOKENS_PER_ETH() public constant returns(uint)
```
Returns the base eth to tokens conversion ratio

### MIN_ETH_FUND
```
function MIN_ETH_FUND() public constant returns (uint)
```
Returns the minimum ether to be raised for the ICO to not fail

### MAX_ETH_FUND
```
function MAX_ETH_FUND() public constant returns (uint)
```
Returns the ether value beyond which the ICO will deny further funding.

### KYC_ETH_LMT
```
function KYC_ETH_LMT() public constant returns (uint)
```
Returns the ether limit above which KYC is required

### FUND_DATE
```
function FUND_DATE() public constant returns (uint)
```
Returns the timestamp after which general funding will be allowed

### weiToTokens
```
function weiToTokens(uint _eth, address _addr) public constant returns (uint);
```
Returns token/ether conversion given an ether value (in wei) and an address.
This takes into account any bonus tokens for the address
        
### kycBonuses
```
function bonuses(address _addr) public constant returns (uint)
```
Returns the bonus tranch level applied to an address

`_addr` An address

### etherContributed
```
function etherContributed(address _addr) public constant returns (uint)
```
Return the ether value contributed by an address

`_addr` An address

### proxyPurchase
```
function proxyPurchase(address _addr) payable returns (bool)
```
Converts sent ether to a number of tokens on the condition
the ICO has neither failed nor succeded.

`_addr` An address to register tokens against

### moveFundsToWallet
```
function moveFundsToWallet() public returns (bool)
```
The owner can move the funds raised during a successful ICO to the fund wallet

### addKycAddress
```
function addKycAddress(address _addr, uint _tranch) public returns (bool)
```
Registers a discount tranch against an address. The address will be awarded a
percentage of bonus tokens above the base price.

`_addr` An address

`_tranch` A tranch index being one of, `5`: 5% `10`: 10% `15`: 15% `20`:20% `25`:25%

### abort
```
function abort() public returns (bool)
```
The owner can cancel the token sale any time prior to funds being swept into the fund wallet

### refund
```
function refund(address _addr) public returns (bool);
```
A token holder can call a refund of contributed ether from a failed ICO

`_addr` The address of a token holder to refund

### changeOwner
```
function changeOwner(address _newOwner) public returns (bool)
```
The owner can initiate an ownership change at any time.
The new owner must call `acceptOwnership()` for ownership to be transfered

`_newOwner` The new owner address

### acceptOwnership
```
function acceptOwnership() public returns (bool)
```
For a potential owner to accept ownership.
Required to prove new owner address can call the contract.

### transferAnyERC20Token
```
function transferAnyERC20Token(address tokenAddress, uint amount) public returns (bool)
```
Allows any ERC20 tokens owned by this contract's address to transferred to the owner address
   
## Events

### NewTokens
```
NewTokens(address indexed _addr, uint indexed _tokens);
```
Triggered upon creation of tokens

### DiscountedAddress
```
DiscountedAddress(address indexed _addr, uint indexed _tranch);
```
Triggered when the owner registers an address with a tranched bonus

### FundsTransferred
```
FundsTransferred(address intexed _wallet, uint indexed _value);
```
Triggered when raised funds are transfered to the fund wallet. This also indicated that tokens have become transferable

### Refunded
```
Refunded(address indexed _addr, uint indexed _value);
```
Triggered when an account is refunded after a failed ICO

### ChangeOwnerTo
```
ChangeOwnerTo(address indexed _to);
```
Triggered when the owner initiates a change of ownership

### ChangedOwner
```
ChangedOwner(address indexed _from, address indexed _to);
```
Triggered when a new owner accepts ownership

### Transfer
```
Transfer(address indexed _from, address indexed _to, uint256 _value);
```
Triggered when tokens have been transferred

### Approval
```
Approval(address indexed _owner, address indexed _spender, uint256 _value);
```
Triggered when a third party sender is approved

## Conditional Entry Table

Functions must throw on F conditions
```
Renetry prevention on all public mutating functions
Reentry mutex set in moveFundsToWallet(), refund()

function                LEAD_IN_PERIOD  isFunding   fundFailed  fundSucceeded
-----------------------------------------------------------------------------
()                              F     <MAX_USD_FUND     F           F
proxyPurchase()                 F     <MAX_USD_FUND     F           F
addKycAddress()					T           T           F           F
abort()                         T           T           T           F
moveFundsToWallet()             F           F           F           T
refund(address _addr)           F           F           T           F
transfer()                      F           F           F       	T
transferFrom()                  F           F           F       	T
approve()                       F           F           F       	T
destroy()                       F           F      !__abortFuse     F
changeOwner()					T 			T			T			T
AcceptOwnership()				T 			T			T			T
transferAnyERC20Tokens()		T 			T			T			T
-----------------------------------------------------------------------------
```