# CoolDex

This repository contains the smart contracts source code, interaction scripts and unit test suites for CoolDex. The repository uses Hardhat as development environment for compilation, testing and deployment tasks.

## What is CoolDex

CoolDex is an order-based decentralised exchange platform, that allows users to deposit any ERC20 token of choice and request for another ERC20 token they want, at a rate of choice. Users can create orders, cancel orders and withdraw their funds at anytime, or accept orders from other users. The process of deposting, swapping and withdrawing is fully handled by the [CoolToken.sol](https://github.com/obah/cool-dex/blob/main/contracts/CoolDex.sol) smart contract.

## Contracts Documentation & Deployments

### [CoolDex.sol](https://github.com/obah/cool-dex/blob/main/contracts/CoolDex.sol)

- Deployed address (Lisk Testnet): 0x9269252D4F1ebc69104534e82586f65C9CF3e605
- [Lisk Sepolia Blockscout verification link](https://sepolia-blockscout.lisk.com/address/0x9269252D4F1ebc69104534e82586f65C9CF3e605#code)

Key features:

- `Multi-ERC20 token support`: Any ERC20 token can be deposited, bought, sold and withdrawn.
- `Trustless peer-to-peer`: Process of swapping ERC20 tokens is peer-to-peer but the smart contract acts as an escrow only sending tokens when both parties have deposited the right amount.
- `Create/Accept/Cancel order anytime`: No time constraints to when users can create, accept and cancel orders.

Functions:

- `deposit(uint256 _amount, address _tokenAddress)`: Allows users to deposit any amount of ERC20 tokens into the smart contract.
- `createOrder(uint256 _amountToBuy, address _tokenToBuy,  uint256 _amountToSell, address _tokenToSell)`: Allows a user to list a portion of their balance for exchange with another ERC20 token.
- `getOrder(uint256 _orderId, address _seller)`: Returns an order selected by id and seller.
- `acceptOrder(uint256 _orderId, uint256 _amount, address _tokenAddress, address _seller)`: Allows a user to send and receive tokens being exchanged in an order.
- `cancelOrder(uint256 _orderId)`: Allows the creator of an order to cancel it and get back their balance.
- `getUserBalance(address _account, address _tokenAddress)`: Returns the balance of an user for a particular ERC20 token.
- `function withdraw(uint256 _amount, address _tokenAddress)`: Allows a user to withdraw any of their available token balace.

## Setup and Installation

### Prerequisites

Ensure you have the following installed:

- Node.js
- Hardhat

### Installation

1. Clone the repository:

   ```
   git clone https://github.com/obah/cool-dex.git
   cd cool-dex
   ```

2. Install dependencies:
   ```
   npm install
   ```

## Test

To run the tests, use:

```
npx hardhat test
```
