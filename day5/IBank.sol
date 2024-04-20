// SPDX-License-Identifier: MIT
pragma solidity >=0.4.12 <0.9.0;

// 声明一个IBank接口
interface IBank {

    // 取钱
    function withdraw(uint256 amount) external returns (bool);

    // 查询当前合约余额
    function getContractDepositBalance() external view returns (uint256);

    // 查询当前用户余额
    function getAddressDepositBalance() external view returns (uint256);
}