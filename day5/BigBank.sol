// SPDX-License-Identifier: MIT
pragma solidity >=0.4.12 <0.9.0;

import "./Bank.sol";

contract BigBank is Bank {
    modifier check_deposit_amount() {
        // 检查是否存入金额大于或者等于0.001个eth
        require(msg.value >= 0.001 ether, "deposit amount must be greater than or equal to 0.001 ether");
        _;
    }

    receive() external payable override check_deposit_amount {
        deposits[msg.sender] += msg.value;
        super.sort(msg.sender);
    }
}