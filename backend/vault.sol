// SPDX-License-Identifier: Apache-2.0 (see LICENSE)

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

pragma solidity ^0.8.8;

/// @title VAULT

contract Vault is Ownable {
  address public token; //can be allowedTokens in a future
  mapping(address => uint) public stakingBalance;

  constructor() {
    token = address(0xB4FBF271143F4FBf7B91A5ded31805e42b2208d6); //WETH IN CELO
  }

  function depositFunds(uint amount_, address strategy_) public payable {
    uint256 allowance = IERC20(token).allowance(msg.sender, address(this));
    require(allowance >= amount_, "Not approved to send balance requested");

    bool success = IERC20(token).transferFrom(
      msg.sender,
      address(this),
      amount_
    );
    require(success, "Transaction was not successful");

    //APPROVE THE VAULT TO SEND FUNDS TO THE STRATEGY
    IERC20(token).approve(strategy_, amount_);
  }

  function withdrawFunds(uint amount_) public payable {
    uint256 allowance = IERC20(token).allowance(msg.sender, address(this));
    require(allowance >= amount_, "Not approved to send balance requested");
    bool success = IERC20(token).transferFrom(
      address(this),
      msg.sender,
      amount_
    );
    require(success, "Transaction was not successful");
  }

  /*function subscribeToStrategy(address strategy) {
    bool success = IERC20(token).transferFrom(
      address(this),
      strategy,
      stakingBalance[msg.sender]
    ); //Transfer funds from vault to strategy
    //require(success, "Transaction was not successful");
  }*/

  /*function depositAndSubscribe(uint amount_) public {
    bool successfulDeposit = deposit(amount_);
    require(successfulDeposit);
    bool succesfullSubscribe = subscribeToStrategy();
    require(succesfullSubscribe);
  }*/
}
