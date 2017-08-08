# Veredictum Ventana Token Sale

Ethereum ERC20 Token sale for the Veredictum anti-piracy platform on distributed technology.

[www.veredictum.io](https://www.veredictum.io/)

This contract is written in order to raise an inital fund of ether in exchange for ERC20 tokens which will have utility value upon the Veredictum platform.

All funds are held in the contract as escrow until the ICO is conditionally successful allowing for the funds to be removed into the fund wallet.

Contributors of a failed fund raising will be able claim a refund of the amount of ether they have contributed.

The fund raising period is from the configured start date upto 28 days.  The contract may accept pre-funds from KYC'ed addresses in the period between deployment and the start date up to the limit of the maximum funding cap.

Non-KYC addresses may fund up to the juristictional regulated maximum equivilent of $10,000USD.

Bonus tokens will be generated at the following funding tranches **per transaction**.

|Contributed| Bonus Tokens|
|-----------|------------:|
|$2,000,000 |          35%|
|$500,000   |          30%|
|$100,000   |          20%|
|$25,000    |          15%|
|$10,000    |          10%|
|$5,000     |           5%|


The ICO fund raising has a minimum cap of $2,000,000USD and maximum of $20,000,000USD with a base conversion ratio of 3 VNT tokens per US dollar.

ETH/USD calculations are at the rate given at deployment.

The ICO will only be considered successful if the funds raised exceed the minimum cap and those funds have been swept to the `FUND_WALLET`.

Owners of an ICO which has raised minimum funds may call `finalizeICO()` before the end date is reached which sets `icoSuccessful` to `true`. No further ether deposits will be accepted by the contract.

ERC20 token transfers are prevented until the ICO is successful.

The ICO will be considered failed if the minimum cap has not been reach by the 29th day or the owner has aborted the ICO.
In the event of a failed ICO, the ether contributed can be recovered unto the funders address using the `refund(address)` function.
It may be called by anyone on the condition the fund has failed.

If a security issue arrises during the time of funding and up until funds are swept to the fund wallet, the owner can call `abort()`. This will force the ICO to fail and allow refunds to be enacted.


## Deployment and Operation Instructions

The contract parameters are hard coded and must be updated before compilation and depolyment.

The constructor takes no arguments. Some protection against invalid parameters is coded into the constructor. If the contract fails to deploy, it may be because of an invalid configuration.

1. Audit predeployed fund wallet and address.
2. Copy and paste the fund wallet address to `FUND_WALLET` constant in `VentanaTokenConfig`.
3. Replace `USD_PER_ETH = 0` with the market price at time of configuration of `VentanaTokenConfig`.
4. Optionally replace `owner = msg.sender` with an alternative audited address if the deploying account is not to be the owner.
5. Check all parameters of `VentanaTokenConfig` are correct.
6. Compile and deploy by prefered method.
7. Verify the deployed contract on `etherscan.io`.
8. Audit the verified contract's getters.
9. Owner and parties Watch the contract in their preferred wallets.


## ABI
```
[{"constant":true,"inputs":[],"name":"name","outputs":[{"name":"","type":"string"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_spender","type":"address"},{"name":"_amount","type":"uint256"}],"name":"approve","outputs":[{"name":"","type":"bool"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"totalSupply","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"veredictum","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_from","type":"address"},{"name":"_to","type":"address"},{"name":"_amount","type":"uint256"}],"name":"transferFrom","outputs":[{"name":"","type":"bool"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"decimals","outputs":[{"name":"","type":"uint8"}],"payable":false,"type":"function"},{"constant":false,"inputs":[],"name":"abort","outputs":[{"name":"","type":"bool"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"START_DATE","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[],"name":"finaliseICO","outputs":[{"name":"","type":"bool"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"MAX_ETH_FUND","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_addr","type":"address"},{"name":"_kyc","type":"bool"}],"name":"addKycAddress","outputs":[{"name":"","type":"bool"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_addr","type":"address"}],"name":"proxyPurchase","outputs":[{"name":"","type":"bool"}],"payable":true,"type":"function"},{"constant":true,"inputs":[],"name":"END_DATE","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_addr","type":"address"}],"name":"changeVeredictum","outputs":[{"name":"","type":"bool"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"fundSucceeded","outputs":[{"name":"","type":"bool"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"fundFailed","outputs":[{"name":"","type":"bool"}],"payable":false,"type":"function"},{"constant":true,"inputs":[{"name":"_addr","type":"address"}],"name":"balanceOf","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"MIN_ETH_FUND","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"MAX_USD_FUND","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[],"name":"acceptOwnership","outputs":[{"name":"","type":"bool"}],"payable":false,"type":"function"},{"constant":false,"inputs":[],"name":"destroy","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"icoSuccessful","outputs":[{"name":"","type":"bool"}],"payable":false,"type":"function"},{"constant":true,"inputs":[{"name":"","type":"address"}],"name":"kycAddresses","outputs":[{"name":"","type":"bool"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"owner","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function"},{"constant":true,"inputs":[{"name":"_wei","type":"uint256"}],"name":"ethToUsd","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"symbol","outputs":[{"name":"","type":"string"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"KYC_ETH_LMT","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":true,"inputs":[{"name":"_wei","type":"uint256"}],"name":"ethToTokens","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_newOwner","type":"address"}],"name":"changeOwner","outputs":[{"name":"","type":"bool"}],"payable":false,"type":"function"},{"constant":true,"inputs":[{"name":"","type":"address"}],"name":"etherContributed","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_to","type":"address"},{"name":"_amount","type":"uint256"}],"name":"transfer","outputs":[{"name":"","type":"bool"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"MIN_USD_FUND","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"USD_PER_ETH","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"TOKENS_PER_ETH","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":true,"inputs":[{"name":"_usd","type":"uint256"}],"name":"usdToEth","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"etherRaised","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"KYC_USD_LMT","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"newOwner","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"TOKENS_PER_USD","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"tokenAddress","type":"address"},{"name":"amount","type":"uint256"}],"name":"transferAnyERC20Token","outputs":[{"name":"","type":"bool"}],"payable":false,"type":"function"},{"constant":true,"inputs":[{"name":"_owner","type":"address"},{"name":"_spender","type":"address"}],"name":"allowance","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"FUND_WALLET","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"usdRaised","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"MAX_TOKENS","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"FUNDING_PERIOD","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_addr","type":"address"}],"name":"refund","outputs":[{"name":"","type":"bool"}],"payable":false,"type":"function"},{"inputs":[],"payable":false,"type":"constructor"},{"payable":true,"type":"fallback"},{"anonymous":false,"inputs":[{"indexed":true,"name":"_addr","type":"address"},{"indexed":true,"name":"_kyc","type":"bool"}],"name":"KYCAddress","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"name":"_addr","type":"address"},{"indexed":true,"name":"_value","type":"uint256"}],"name":"Refunded","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"name":"_from","type":"address"},{"indexed":true,"name":"_to","type":"address"}],"name":"ChangedOwner","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"name":"_to","type":"address"}],"name":"ChangeOwnerTo","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"name":"_wallet","type":"address"},{"indexed":true,"name":"_value","type":"uint256"}],"name":"FundsTransferred","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"name":"_from","type":"address"},{"indexed":true,"name":"_to","type":"address"},{"indexed":false,"name":"_amount","type":"uint256"}],"name":"Transfer","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"name":"_owner","type":"address"},{"indexed":true,"name":"_spender","type":"address"},{"indexed":false,"name":"_amount","type":"uint256"}],"name":"Approval","type":"event"}]
```
## Release Notes
```
Release Notes
-------------
0.0.10
* remove `constant` from FUND_WALLET declaration as assigning `msg.sender` is
not compile time constant.
* redeclared FUND_WALLET to `address public fundWallet`
* `fundSucceeded()` returns true on `etherRaised >= MIN_ETH_FUND` instead of
waiting for `END_DATE`
```

## Ventana token sale configuration
The ICO configuration is by way of precompiled constants. At a minimum, `FUND_WALLET` and `USD_PER_ETH` are required to be edited with correct values.

```
contract VentanaTokenConfig
{
    // ERC20 trade name and symbol
    string public           name            = "Ventana";
    string public           symbol          = "VNT";

    // Owner has power to abort, discount addresses, sweep successful funds,
    // change owner, sweep alien tokens.
    address public          owner           = msg.sender;
    
    // Fund wallet should also be audited prior to deployment
    // NOTE: Must be checksummed address!
    address public          fundWallet      = 0x0;
    
    // Tokens awarded per USD contributed
    uint public constant    TOKENS_PER_USD  = 3;

    // Ether market price in USD
    uint public constant    USD_PER_ETH     = 0;
    
    // Minimum and maximum target in USD
    uint public constant    MIN_USD_FUND    = 2000000;  // $2m
    uint public constant    MAX_USD_FUND    = 20000000; // $20m
    
    // Non-KYC contribution limit in USD
    uint public constant    KYC_USD_LMT     = 10000;
    
    // There will be exactly 300,000,000 tokens regardless of number sold
    // Unsold tokens are put into the Strategic Growth token pool
    uint public constant    MAX_TOKENS      = 300000000;
    
    // Funding begins on 14th August 2017
    // `+ new Date('14 August 2017 GMT+0')/1000`
    uint public constant    START_DATE      = 1502668800;
    
    // Period for fundraising
    uint public constant    FUNDING_PERIOD  = 28 days;
}
```
`name` The Ventana token name "Ventana"

`symbol` Ventana trade symbol "VNT"

`owner` The address of the contract owner.

The deployer may wish this address be singularly controlled (rather than multi-sig) to facilite efficient adding of KYC'd addresses or causing an emergency abort. It does not have permissions to control or access funds.  Ownership should be handed over to the multisig after a successful ICO.

The owner is permissioned to call:

* `finalizeICO()` On condition the ICO is successful
* `addKycAddress()` Up until the END_DATE
* `abort()` On condition the ICO has not succeeded
* `changeOwner()` At any time
* `changeVeredictum(address _addr)` at any time

`fundWallet` The wallet that raised funds will be swept when finalizeICO() is called after a successful funding.

`TOKENS_PER_USD` The base number of tokens to be created per US dollar equivilent paid 

`USD_PER_ETH` The ETH/USD market rate at the time of deployment.
This is used for token creation calculations.

`MIN_USD_FUND` The minimum USD funds required for the ICO to be successful

`MAX_USD_FUND` The maximum USD funds that can be raised

`MAX_TOKENS` The total number of tokens that will be in supply

`KYC_USD_LMT` The USD limit over which *Know Your Customer* regulations apply.
Funders who are not KYC'd can only contribute up to this amount.
    
`START_DATE` The date at which funds will be accepted from non-KYC'ed addresses. KYC'ed addresses can contribute funds before this date.
    
`FUNDING_PERIOD` The period after START_DATE until funding closes.

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

Token transfers are blocked until `icoSuccessful==true`

`_to` The address of the recipient

`_amount` The amount of tokens to transfer

Returns success bool

### transferFrom
```
function transferFrom(address _from, address _to, uint256 _amount) public returns (bool)
```
Transfers and amount of tokens from a third party address to a recipient on the condition
it is approved by the third party.

Token transfers are blocked until `icoSuccessful==true`

`_from` The holder address of tokens to be sent

`_to` The address of the recipient

`_amount` The amount of tokens to transfer

### approve
```
function approve(address _spender, uint256 _amount) public returns (bool)
```
Approves a spend to transfer an amount of tokens

Approval is blocked until `icoSuccessful==true`

`_spender` The address of the approved spender

`_amount` The amount of tokens the spender is allowed to transfer

## VentanaToken Functions

### ()
```
function () payable
```
The default function is payable and calls `proxyPurchase(msg.sender)`

### fundSucceeded
```
function fundSucceeded() public constant returns (bool)
```
Returns `true` if `MIN_FUNDS` were raised and the ICO was not aborted
    
### fundFailed
```
function fundFailed() public constant returns (bool)
```
Returns `true` if the ICO was aborted or `MIN_FUNDS` were not raised before `END_DATE`.

### icoSuccessful
```
function icoSuccessful() public constant returns (bool)
```
Returns `true` if `MIN_FUNDS` has been raised and the funds have been sweept to the fund wallet.

Token transfers are blocked until `icoSuccessful==true`

A successful ICO will reject further ether deposits.

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

### START_DATE
```
function START_DATE() public constant returns (uint)
```
Returns the timestamp after which funding from non-KYC accounts is accepted.
It also determines the `END_DATE` as `START_DATE + FUNDING_PERIOD`

### weiToTokens
```
function weiToTokens(uint _wei) public constant returns (uint);
```
Returns token/ether conversion given an ether value (in wei).
This calculation includes the following bonus token tranches for levels of
USD contributed:

|Contributed| Bonus Tokens|
|-----------|------------:|
|$2,000,000 |          35%|
|$500,000   |          30%|
|$100,000   |          20%|
|$25,000    |          15%|
|$10,000    |          10%|
|$5,000     |           5%|

`_wei` An amount of ether denominated in wei

### kycAddresses
```
function kycAddresses(address _addr) public constant returns (bool)
```
Returns the KYC boolean state for an address

`_addr` An address

### etherContributed
```
function etherContributed(address _addr) public constant returns (uint)
```
Return the ether value contributed by an address

`_addr` An address

### abort
```
function abort() public returns (bool)
```
The owner can cancel the token sale any time prior to funds being swept into the fund wallet

### proxyPurchase
```
function proxyPurchase(address _addr) payable returns (bool)
```
Converts sent ether to a number of tokens which are transferred to`_addr` on the condition the ICO has neither failed nor succeded.

`_addr` An address to register tokens against

### addKycAddress
```
function addKycAddress(address _addr, bool _kyc) public returns (bool)
```
Registers or deregisters an address as a known customer (KYC) which allows funds to be contributed above the KYC limit. 

`_addr` An address.

`_kyc` A boolean KYC state.

### finaliseICO
```
function finaliseICO() public returns (bool)
```
This action will set `icoSuccessful` to `true` if `fundSucceeded()` returns true.
Raised funds are then swept to `FUND_WALLET`. Tokens are transferrable after this function successfully returns.

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
The new owner must call `acceptOwnership()` for ownership to be transferred

`_newOwner` The new owner address

### acceptOwnership
```
function acceptOwnership() public returns (bool)
```
For a potential owner to accept ownership.
Required to prove new owner address can call the contract.

### changeVeredictum
```
changeVeredictum(address _addr) public returns (bool)
```
Allows the owner to change the Veredictum utility contract the Ventana token contract interacts with.

### destroy
```
destroy()
```
Allows the owner to remove the contract from the blockchain on the condition it has been aborted and the ther balance is 0.

### transferAnyERC20Token
```
function transferAnyERC20Token(address tokenAddress, uint amount) public returns (bool)
```
Allows any ERC20 tokens owned by this contract's address to transferred to the owner address


## Events

### KYCAddress
```
DiscountedAddress(address indexed _addr, uint indexed _tranch);
```
Triggered when the owner registers an address with a tranched bonus

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

### FundsTransferred
```
FundsTransferred(address intexed _wallet, uint indexed _value);
```
Triggered when raised funds are transferred to the fund wallet. This also indicated that tokens have become transferable

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

Conditional Entry Table (functions must throw on F conditions)

renetry prevention on all public mutating functions
Reentry mutex set in moveFundsToWallet(), refund()

|function                |<START_DATE|<END_DATE |fundFailed  |fundSucceeded|icoSucceeded
|------------------------|:---------:|:--------:|:----------:|:-----------:|:---------:|
|()                      |KYC        |T         |F           |T            |F          |
|abort()                 |T          |T         |T           |T            |F          |
|proxyPurchase()         |KYC        |T         |F           |T            |F          |
|addKycAddress()         |T          |T         |F           |T            |T          |
|finaliseICO()           |F          |F         |F           |T            |T          |
|refund()                |F          |F         |T           |F            |F          |
|transfer()              |F          |F         |F           |F            |T          |
|transferFrom()          |F          |F         |F           |F            |T          |
|approve()               |F          |F         |F           |F            |T          |
|changeOwner()           |T          |T         |T           |T            |T          |
|acceptOwnership()       |T          |T         |T           |T            |T          |
|changeVeredictum()      |T          |T         |T           |T            |T          |
|destroy()               |F          |F         |!__abortFuse|F            |F          |
|transferAnyERC20Tokens()|T          |T         |T           |T            |T          |
