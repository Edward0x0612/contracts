// SPDX-License-Identifier: MIT
pragma solidity >=0.4.12 <0.9.0;

import "./Ownable.sol";
import "./BigBank.sol";
import "./IBank.sol";

/** 这里提供2种调用，如果是组合，需要在部署的时候指定指定的合约地址; 如果是接口，不需要部署时候指定，而是在函数调用阶段指定地址参数 */
contract TransferredOwnershipBank is Ownable {
    BigBank caller;
    error AMOUNT_LESS_THAN_ZERO();

    constructor(address payable _addr) {
        caller = BigBank(_addr);
    }

    // 从其他合约取钱(组合方式实现)
    function withdraw(uint256 amount) public admin returns (bool) {
        // 校验取钱金额
        if (amount < 0) revert AMOUNT_LESS_THAN_ZERO();
        // 调用BigBank合约进行取钱
        return caller.withdrwal(amount);
    }

    // 从其他合约取钱(接口实现)
    function withdraw(uint256 amount, address payable _addr) public admin returns (bool) {
        // 校验取钱金额
        if (amount < 0) revert AMOUNT_LESS_THAN_ZERO();

        // 通过interface调用BigBank合约进行取钱
        return IBank(_addr).withdraw(amount);
    }

    receive() external payable {

    }
}